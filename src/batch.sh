#!/usr/bin/env bash
# Vyn Batch Processing Module
# Batch video conversion and processing
# Version: 1.5.0

readonly BATCH_MODULE_VERSION="1.5.0"

# Setup batch processing
setup_batch_processing() {
    echo ""
    print_color "$PURPLE" "🗂️  Batch Processing Setup"
    
    # Get input directory
    while true; do
        read -r -p "📁 Enter input directory (or type files): " input_path
        if [[ -d "$input_path" ]]; then
            BATCH_INPUT_DIR="$input_path"
            break
        elif [[ -f "$input_path" ]]; then
            print_error "That's a file, not a directory. Please provide a directory path."
        else
            print_error "Directory '$input_path' does not exist!"
        fi
    done
    
    # Get output directory
    while true; do
        read -r -p "📤 Enter output directory: " output_path
        if [[ -n "$output_path" ]]; then
            BATCH_OUTPUT_DIR="$output_path"
            if [[ ! -d "$output_path" ]]; then
                if [[ "$DRY_RUN" == true ]]; then
                    print_info "Would create directory: $output_path"
                else
                    mkdir -p "$output_path"
                    print_success "✅ Created output directory: $output_path"
                fi
            fi
            break
        else
            print_error "Output directory cannot be empty!"
        fi
    done
    
    # Get target format
    while true; do
        echo ""
        print_color "$PURPLE" "Select target format:"
        echo "1) MP4 (H.264 + AAC)"
        echo "2) MKV (H.264 + AAC)"
        echo "3) WebM (VP9 + Opus)"
        echo "4) Custom format"
        
        read -r -p "Enter your choice (1-4): " format_choice
        case $format_choice in
            1) BATCH_FORMAT="mp4"; break ;;
            2) BATCH_FORMAT="mkv"; break ;;
            3) BATCH_FORMAT="webm"; break ;;
            4) 
                read -r -p "Enter custom format extension (e.g., avi): " custom_format
                if [[ -n "$custom_format" ]]; then
                    BATCH_FORMAT="$custom_format"
                    break
                fi
                ;;
            *) print_error "Invalid choice. Please enter 1-4." ;;
        esac
    done
    
    print_success "✅ Batch processing configured"
}

# Process batch files
process_batch_files() {
    local input_dir="$1"
    local output_dir="$2"
    local target_format="$3"
    
    # Define supported input formats
    local supported_input="mp4 mkv avi mov webm m4v flv 3gp wmv mpg mpeg ts"
    
    # Build find command with all supported extensions
    local find_conditions=()
    local first=true
    for ext in $supported_input; do
        if [[ "$first" == true ]]; then
            find_conditions+=("-iname" "*.$ext")
            first=false
        else
            find_conditions+=("-o" "-iname" "*.$ext")
        fi
    done
    
    # Find all video files in input directory
    local video_files=()
    while IFS= read -r -d '' file; do
        video_files+=("$file")
    done < <(find "$input_dir" -type f \( "${find_conditions[@]}" \) -print0 2>/dev/null)
    
    # Check for common non-standard extensions
    local common_alt_exts="nix ts4 m2ts mts mod vob"
    for ext in $common_alt_exts; do
        while IFS= read -r -d '' file; do
            if [[ -f "$file" ]]; then
                # Use file command to check if it's actually a video file
                if file "$file" 2>/dev/null | grep -q -i "video\|media\|mp4\|mov\|avi\|mkv"; then
                    video_files+=("$file")
                    print_info "🔍 Detected video file with non-standard extension: $(basename "$file")"
                fi
            fi
        done < <(find "$input_dir" -type f -iname "*.$ext" -print0 2>/dev/null)
    done
    
    if [[ ${#video_files[@]} -eq 0 ]]; then
        print_error "No video files found in '$input_dir'"
        print_info "Supported formats: $supported_input"
        print_info "💡 Tip: Files with non-standard extensions will be auto-detected if they contain video data"
        exit 1
    fi
    
    print_info "📊 Found ${#video_files[@]} video file(s) to process"
    
    if [[ "$DRY_RUN" == true ]]; then
        print_info "🔍 DRY RUN: Batch processing preview"
        for file in "${video_files[@]}"; do
            local basename_file
            basename_file="$(basename "$file")"
            local name_without_ext="${basename_file%.*}"
            local output_file="$output_dir/${name_without_ext}.${target_format}"
            print_info "Would convert: $file → $output_file"
        done
        return 0
    fi
    
    # Process each file
    local processed=0
    local failed=0
    local start_time=$(date +%s)
    
    for file in "${video_files[@]}"; do
        local basename_file
        basename_file="$(basename "$file")"
        local name_without_ext="${basename_file%.*}"
        local output_file="$output_dir/${name_without_ext}.${target_format}"
        
        echo ""
        print_info "🎬 Processing file $((processed + failed + 1))/${#video_files[@]}: $basename_file"
        
        # Skip if output already exists
        if [[ -f "$output_file" ]]; then
            print_warning "⚠️  Output file already exists: $output_file (skipping)"
            continue
        fi
        
        # Process the file
        set +e
        if [[ "$OPERATION_MODE" == "remux" ]]; then
            if do_remux "$file" "$output_file"; then
                ((processed++))
                print_info "✅ Successfully processed: $(basename "$file")"
            else
                ((failed++))
                print_error "❌ Failed to process: $(basename "$file")"
            fi
        else
            if do_encode "$file" "$output_file"; then
                ((processed++))
                print_info "✅ Successfully processed: $(basename "$file")"
            else
                ((failed++))
                print_error "❌ Failed to process: $(basename "$file")"
            fi
        fi
        set -e
    done
    
    # Show batch summary
    local end_time=$(date +%s)
    local total_time=$((end_time - start_time))
    
    echo ""
    print_success "🎉 Batch processing completed!"
    print_info "📊 Summary:"
    print_info "   ✅ Successfully processed: $processed files"
    if [[ $failed -gt 0 ]]; then
        print_warning "   ❌ Failed: $failed files"
    fi
    print_info "   ⏱️  Total time: ${total_time}s"
}

# Module info
batch_module_info() {
    echo "Vyn Batch Module v${BATCH_MODULE_VERSION}"
}
