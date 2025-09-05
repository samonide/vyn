#!/bin/bash
# Quality Analyzer Plugin for Vyn
# Analyze video quality metrics, generate reports, and suggest optimal settings

plugin_name="Quality Analyzer"
plugin_version="1.0.0"
plugin_description="Analyze video quality metrics and generate optimization reports"

# Plugin validation
validate_plugin() {
    # Check if ffprobe is available (comes with ffmpeg)
    if ! command -v ffprobe >/dev/null 2>&1; then
        echo "❌ ffprobe is required for quality analysis"
        return 1
    fi
    
    # Check if bc is available for calculations
    if ! command -v bc >/dev/null 2>&1; then
        echo "❌ bc (calculator) is required for quality analysis"
        echo "💡 Install with: sudo apt install bc (or brew install bc on macOS)"
        return 1
    fi
    
    return 0
}

# Get comprehensive video information
get_video_info() {
    local video_file="$1"
    local temp_file="/tmp/vyn_video_info_$$.json"
    
    # Extract detailed video information using ffprobe
    ffprobe -v quiet -print_format json -show_format -show_streams "$video_file" > "$temp_file" 2>/dev/null
    
    if [[ $? -eq 0 && -f "$temp_file" ]]; then
        echo "$temp_file"
        return 0
    else
        echo ""
        return 1
    fi
}

# Calculate video quality metrics
analyze_video_quality() {
    local video_file="$1"
    local info_file="$2"
    
    echo "🔍 Analyzing: $(basename "$video_file")"
    
    # Extract basic information
    local duration=$(jq -r '.format.duration // "0"' "$info_file")
    local file_size=$(stat -c%s "$video_file" 2>/dev/null || stat -f%z "$video_file" 2>/dev/null || echo "0")
    local format_name=$(jq -r '.format.format_name // "unknown"' "$info_file")
    
    # Video stream information
    local video_stream=$(jq -r '.streams[] | select(.codec_type=="video") | @base64' "$info_file" | head -1)
    
    if [[ -n "$video_stream" ]]; then
        local width=$(echo "$video_stream" | base64 -d | jq -r '.width // 0')
        local height=$(echo "$video_stream" | base64 -d | jq -r '.height // 0')
        local codec=$(echo "$video_stream" | base64 -d | jq -r '.codec_name // "unknown"')
        local bitrate=$(echo "$video_stream" | base64 -d | jq -r '.bit_rate // "0"')
        local fps=$(echo "$video_stream" | base64 -d | jq -r '.r_frame_rate // "0/1"')
        local pixel_format=$(echo "$video_stream" | base64 -d | jq -r '.pix_fmt // "unknown"')
        local profile=$(echo "$video_stream" | base64 -d | jq -r '.profile // "unknown"')
        local level=$(echo "$video_stream" | base64 -d | jq -r '.level // 0')
        
        # Calculate additional metrics
        local resolution="${width}x${height}"
        local total_pixels=$((width * height))
        local fps_decimal=$(echo "$fps" | bc -l 2>/dev/null || echo "0")
        
        # Calculate bitrate if not available
        if [[ "$bitrate" == "0" && "$duration" != "0" ]]; then
            bitrate=$(echo "scale=0; ($file_size * 8) / $duration" | bc 2>/dev/null || echo "0")
        fi
        
        # Bitrate per pixel calculation
        local bitrate_per_pixel="0"
        if [[ "$total_pixels" -gt 0 && "$bitrate" -gt 0 ]]; then
            bitrate_per_pixel=$(echo "scale=6; $bitrate / $total_pixels" | bc 2>/dev/null || echo "0")
        fi
        
        # Quality assessment
        local quality_score=$(assess_quality "$width" "$height" "$bitrate" "$codec" "$fps_decimal")
        local compression_efficiency=$(assess_compression "$file_size" "$duration" "$total_pixels" "$fps_decimal")
        
        # Store results in associative array format
        cat << EOF
FILE="$video_file"
DURATION="$duration"
FILE_SIZE="$file_size" 
FORMAT="$format_name"
RESOLUTION="$resolution"
WIDTH="$width"
HEIGHT="$height"
CODEC="$codec"
BITRATE="$bitrate"
FPS="$fps_decimal"
PIXEL_FORMAT="$pixel_format"
PROFILE="$profile"
LEVEL="$level"
TOTAL_PIXELS="$total_pixels"
BITRATE_PER_PIXEL="$bitrate_per_pixel"
QUALITY_SCORE="$quality_score"
COMPRESSION_EFFICIENCY="$compression_efficiency"
EOF
    else
        echo "❌ No video stream found in $(basename "$video_file")"
        return 1
    fi
}

# Assess video quality based on metrics
assess_quality() {
    local width="$1"
    local height="$2" 
    local bitrate="$3"
    local codec="$4"
    local fps="$5"
    
    local score=0
    
    # Resolution scoring (0-30 points)
    local total_pixels=$((width * height))
    if [[ $total_pixels -ge 8294400 ]]; then score=$((score + 30))      # 4K+
    elif [[ $total_pixels -ge 2073600 ]]; then score=$((score + 25))    # 1080p
    elif [[ $total_pixels -ge 921600 ]]; then score=$((score + 20))     # 720p
    elif [[ $total_pixels -ge 307200 ]]; then score=$((score + 15))     # 480p
    else score=$((score + 10)); fi
    
    # Bitrate scoring (0-35 points)
    local bitrate_mbps=$(echo "scale=2; $bitrate / 1000000" | bc 2>/dev/null || echo "0")
    local bitrate_int=$(echo "$bitrate_mbps" | cut -d. -f1)
    
    if [[ $bitrate_int -ge 25 ]]; then score=$((score + 35))
    elif [[ $bitrate_int -ge 15 ]]; then score=$((score + 30))
    elif [[ $bitrate_int -ge 8 ]]; then score=$((score + 25))
    elif [[ $bitrate_int -ge 4 ]]; then score=$((score + 20))
    elif [[ $bitrate_int -ge 2 ]]; then score=$((score + 15))
    else score=$((score + 5)); fi
    
    # Codec scoring (0-20 points)
    case "$codec" in
        "h264"|"avc") score=$((score + 15)) ;;
        "hevc"|"h265") score=$((score + 20)) ;;
        "vp9") score=$((score + 18)) ;;
        "av1") score=$((score + 20)) ;;
        *) score=$((score + 10)) ;;
    esac
    
    # FPS scoring (0-15 points)
    local fps_int=$(echo "$fps" | cut -d. -f1)
    if [[ $fps_int -ge 60 ]]; then score=$((score + 15))
    elif [[ $fps_int -ge 30 ]]; then score=$((score + 12))
    elif [[ $fps_int -ge 24 ]]; then score=$((score + 10))
    else score=$((score + 5)); fi
    
    echo "$score"
}

# Assess compression efficiency
assess_compression() {
    local file_size="$1"
    local duration="$2"
    local total_pixels="$3"
    local fps="$4"
    
    if [[ "$duration" == "0" || "$total_pixels" == "0" ]]; then
        echo "N/A"
        return
    fi
    
    # Calculate data rate per pixel per second
    local total_pixel_seconds=$(echo "scale=0; $total_pixels * $duration * $fps" | bc 2>/dev/null || echo "1")
    local bytes_per_pixel_second=$(echo "scale=8; $file_size / $total_pixel_seconds" | bc 2>/dev/null || echo "0")
    
    # Efficiency rating based on bytes per pixel per second
    local efficiency_float=$(echo "$bytes_per_pixel_second" | cut -d. -f1)
    if [[ -z "$efficiency_float" ]]; then efficiency_float="0"; fi
    
    if (( $(echo "$bytes_per_pixel_second < 0.0001" | bc -l 2>/dev/null || echo 0) )); then
        echo "Excellent"
    elif (( $(echo "$bytes_per_pixel_second < 0.0005" | bc -l 2>/dev/null || echo 0) )); then
        echo "Very Good"
    elif (( $(echo "$bytes_per_pixel_second < 0.001" | bc -l 2>/dev/null || echo 0) )); then
        echo "Good"
    elif (( $(echo "$bytes_per_pixel_second < 0.005" | bc -l 2>/dev/null || echo 0) )); then
        echo "Fair"
    else
        echo "Poor"
    fi
}

# Generate optimization suggestions
suggest_optimizations() {
    local width="$1"
    local height="$2"
    local bitrate="$3"
    local codec="$4"
    local quality_score="$5"
    local file_size="$6"
    
    echo ""
    echo "💡 Optimization Suggestions:"
    echo "============================="
    
    local suggestions=()
    
    # Codec suggestions
    if [[ "$codec" != "hevc" && "$codec" != "h265" && "$codec" != "av1" ]]; then
        suggestions+=("🎯 Consider upgrading to HEVC (H.265) for better compression efficiency")
    fi
    
    # Bitrate optimization
    local bitrate_mbps=$(echo "scale=1; $bitrate / 1000000" | bc 2>/dev/null || echo "0")
    local total_pixels=$((width * height))
    
    if [[ $total_pixels -ge 2073600 ]]; then  # 1080p+
        if (( $(echo "$bitrate_mbps > 12" | bc -l 2>/dev/null || echo 0) )); then
            local suggested_bitrate="8-10"
            suggestions+=("📉 Reduce bitrate to ${suggested_bitrate}Mbps for 1080p content")
        fi
    elif [[ $total_pixels -ge 921600 ]]; then  # 720p
        if (( $(echo "$bitrate_mbps > 6" | bc -l 2>/dev/null || echo 0) )); then
            local suggested_bitrate="4-5"
            suggestions+=("📉 Reduce bitrate to ${suggested_bitrate}Mbps for 720p content")
        fi
    fi
    
    # Quality-based suggestions
    if [[ $quality_score -lt 50 ]]; then
        suggestions+=("⚠️  Low quality detected - consider increasing bitrate or using better codec")
    elif [[ $quality_score -gt 85 ]]; then
        suggestions+=("💾 High quality detected - potential for file size reduction")
    fi
    
    # File size suggestions
    local file_size_mb=$(echo "scale=1; $file_size / 1048576" | bc 2>/dev/null || echo "0")
    if (( $(echo "$file_size_mb > 500" | bc -l 2>/dev/null || echo 0) )); then
        suggestions+=("🗜️  Large file size - consider two-pass encoding for better compression")
    fi
    
    # Print suggestions
    if [[ ${#suggestions[@]} -eq 0 ]]; then
        echo "✅ Video appears well-optimized!"
    else
        for suggestion in "${suggestions[@]}"; do
            echo "$suggestion"
        done
    fi
    
    echo ""
    echo "🎛️  Recommended vyn commands:"
    echo "----------------------------"
    
    # Generate command suggestions based on analysis
    if [[ $quality_score -lt 60 ]]; then
        echo "vyn input.mp4 output.mp4 --preset cinema     # High quality preset"
    elif [[ $quality_score -gt 80 ]]; then
        echo "vyn input.mp4 output.mp4 --preset web        # Balanced quality/size"
    else
        echo "vyn input.mp4 output.mp4 --preset broadcast  # Professional quality"
    fi
    
    if [[ "$codec" != "hevc" && "$codec" != "h265" ]]; then
        echo "vyn input.mp4 output.mp4 --video-codec hevc  # Better compression"
    fi
    
    echo ""
}

# Convert bytes to human readable format
format_bytes() {
    local bytes="$1"
    if [[ $bytes -ge 1073741824 ]]; then
        echo "$(echo "scale=1; $bytes / 1073741824" | bc)GB"
    elif [[ $bytes -ge 1048576 ]]; then
        echo "$(echo "scale=1; $bytes / 1048576" | bc)MB"
    elif [[ $bytes -ge 1024 ]]; then
        echo "$(echo "scale=1; $bytes / 1024" | bc)KB"
    else
        echo "${bytes}B"
    fi
}

# Generate detailed quality report
generate_quality_report() {
    local video_file="$1"
    local analysis_data="$2"
    
    # Source the analysis data
    source <(echo "$analysis_data")
    
    echo ""
    echo "📊 Quality Analysis Report"
    echo "=========================="
    echo "📄 File: $(basename "$FILE")"
    echo "📅 Date: $(date)"
    echo ""
    
    # Basic Information
    echo "📋 Basic Information:"
    echo "-------------------"
    echo "Format: $FORMAT"
    echo "Duration: $(printf "%.2f" "$DURATION")s"
    echo "File Size: $(format_bytes "$FILE_SIZE")"
    echo ""
    
    # Video Quality Metrics
    echo "🎬 Video Quality Metrics:"
    echo "------------------------"
    echo "Resolution: $RESOLUTION"
    echo "Codec: $CODEC"
    echo "Profile: $PROFILE"
    echo "Pixel Format: $PIXEL_FORMAT"
    echo "Frame Rate: $(printf "%.2f" "$FPS") fps"
    echo "Bitrate: $(echo "scale=2; $BITRATE / 1000000" | bc)Mbps"
    echo "Bitrate per Pixel: $(printf "%.6f" "$BITRATE_PER_PIXEL") bpp"
    echo ""
    
    # Quality Assessment
    echo "🎯 Quality Assessment:"
    echo "---------------------"
    echo "Overall Quality Score: $QUALITY_SCORE/100"
    
    local quality_rating=""
    if [[ $QUALITY_SCORE -ge 90 ]]; then quality_rating="Excellent"
    elif [[ $QUALITY_SCORE -ge 80 ]]; then quality_rating="Very Good"
    elif [[ $QUALITY_SCORE -ge 70 ]]; then quality_rating="Good"
    elif [[ $QUALITY_SCORE -ge 60 ]]; then quality_rating="Fair"
    else quality_rating="Poor"; fi
    
    echo "Quality Rating: $quality_rating"
    echo "Compression Efficiency: $COMPRESSION_EFFICIENCY"
    echo ""
    
    # Generate optimization suggestions
    suggest_optimizations "$WIDTH" "$HEIGHT" "$BITRATE" "$CODEC" "$QUALITY_SCORE" "$FILE_SIZE"
}

# Get list of video files in directory
get_video_files() {
    local directory="$1"
    find "$directory" -type f \( -iname "*.mp4" -o -iname "*.avi" -o -iname "*.mov" -o -iname "*.mkv" -o -iname "*.webm" -o -iname "*.flv" -o -iname "*.wmv" -o -iname "*.m4v" -o -iname "*.3gp" -o -iname "*.ts" \) | sort
}

# Analyze single video file
analyze_single_video() {
    local video_file="$1"
    local output_dir="$2"
    
    echo "🔍 Analyzing: $(basename "$video_file")"
    
    local info_file=$(get_video_info "$video_file")
    if [[ -z "$info_file" ]]; then
        echo "❌ Failed to analyze: $(basename "$video_file")"
        return 1
    fi
    
    local analysis_data=$(analyze_video_quality "$video_file" "$info_file")
    if [[ -z "$analysis_data" ]]; then
        echo "❌ Failed to generate quality metrics for: $(basename "$video_file")"
        rm -f "$info_file"
        return 1
    fi
    
    # Generate and save report
    local report_file="$output_dir/$(basename "$video_file" | sed 's/\.[^.]*$/_quality_report.txt/')"
    generate_quality_report "$video_file" "$analysis_data" > "$report_file"
    
    # Also display summary
    source <(echo "$analysis_data")
    echo "✅ Quality Score: $QUALITY_SCORE/100 | Efficiency: $COMPRESSION_EFFICIENCY"
    echo "📄 Report saved: $(basename "$report_file")"
    echo ""
    
    # Cleanup
    rm -f "$info_file"
    return 0
}

# Main analysis function for folders
analyze_folder_quality() {
    local folder_path="$1"
    
    if [[ ! -d "$folder_path" ]]; then
        echo "❌ Directory not found: $folder_path"
        return 1
    fi
    
    echo ""
    echo "🔬 Quality Analyzer"
    echo "=================="
    echo "📁 Analyzing folder: $folder_path"
    echo ""
    
    # Get video files
    local video_files=($(get_video_files "$folder_path"))
    
    if [[ ${#video_files[@]} -eq 0 ]]; then
        echo "❌ No video files found in $folder_path"
        return 1
    fi
    
    echo "📹 Found ${#video_files[@]} video file(s)"
    echo ""
    
    # Create reports directory
    local reports_dir="$folder_path/quality_reports"
    if [[ ! -d "$reports_dir" ]]; then
        mkdir -p "$reports_dir"
        echo "📁 Created reports directory: quality_reports/"
        echo ""
    fi
    
    # Analyze all videos
    local success_count=0
    local total_files=${#video_files[@]}
    local total_score=0
    
    for video_file in "${video_files[@]}"; do
        if analyze_single_video "$video_file" "$reports_dir"; then
            # Get quality score for summary
            local info_file=$(get_video_info "$video_file")
            if [[ -n "$info_file" ]]; then
                local analysis_data=$(analyze_video_quality "$video_file" "$info_file")
                if [[ -n "$analysis_data" ]]; then
                    source <(echo "$analysis_data")
                    total_score=$((total_score + QUALITY_SCORE))
                fi
                rm -f "$info_file"
            fi
            success_count=$((success_count + 1))
        fi
    done
    
    # Generate summary report
    local summary_file="$reports_dir/summary_report.txt"
    local average_score=0
    if [[ $success_count -gt 0 ]]; then
        average_score=$((total_score / success_count))
    fi
    
    cat > "$summary_file" << EOF
📊 Quality Analysis Summary Report
================================
📅 Analysis Date: $(date)
📁 Folder: $folder_path
📹 Total Videos: $total_files
✅ Successfully Analyzed: $success_count
📊 Average Quality Score: $average_score/100

📋 Individual Reports:
$(ls "$reports_dir"/*_quality_report.txt 2>/dev/null | sed 's|.*/||' | sed 's|^|  - |')

💡 Overall Recommendations:
- Review individual reports for specific optimization suggestions
- Videos with scores below 60 may benefit from re-encoding
- Consider using vyn's professional presets for optimal results

🎛️  Batch optimization commands:
vyn --batch "$folder_path" --preset web      # Balanced quality/size
vyn --batch "$folder_path" --preset cinema   # High quality
vyn --batch "$folder_path" --preset mobile   # Size optimized
EOF
    
    echo ""
    echo "📊 Analysis Summary"
    echo "=================="
    echo "✅ Successfully analyzed: $success_count/$total_files videos"
    echo "📊 Average Quality Score: $average_score/100"
    echo "📁 Reports saved in: quality_reports/"
    echo "📄 Summary report: summary_report.txt"
    echo ""
    
    return 0
}

# Plugin execution function (required by vyn plugin system)
execute_plugin() {
    local input_path="$1"
    local output_path="$2"  # Not used for quality analysis
    
    # Validate plugin requirements
    if ! validate_plugin; then
        return 1
    fi
    
    # Check if input is a directory
    if [[ -d "$input_path" ]]; then
        analyze_folder_quality "$input_path"
        return $?
    elif [[ -f "$input_path" ]]; then
        # Single file analysis
        local file_dir=$(dirname "$input_path")
        local reports_dir="$file_dir/quality_reports"
        mkdir -p "$reports_dir"
        analyze_single_video "$input_path" "$reports_dir"
        return $?
    else
        echo "❌ Quality analyzer requires a video file or directory path"
        echo "💡 Usage: vyn --plugin quality-analyzer /path/to/video/folder"
        echo "💡 Usage: vyn --plugin quality-analyzer /path/to/video.mp4"
        return 1
    fi
}

# If script is run directly (not sourced), run the main function
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    if [[ $# -lt 1 ]]; then
        echo "Usage: $0 <folder_or_file_path>"
        exit 1
    fi
    
    if [[ -d "$1" ]]; then
        analyze_folder_quality "$1"
    else
        analyze_single_video "$1" "$(dirname "$1")"
    fi
fi
