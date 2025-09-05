#!/bin/bash
# Vimeo Uploader Plugin for Vyn
# Upload entire folders to Vimeo and generate links.txt file

plugin_name="Vimeo Uploader"
plugin_version="1.4.0"
plugin_description="Upload video folders to Vimeo and create playlist links"

# Vimeo API configuration
VIMEO_ACCESS_TOKEN=""
VIMEO_API_BASE="https://api.vimeo.com"

# Plugin validation
validate_plugin() {
    # Check if curl is available
    if ! command -v curl >/dev/null 2>&1; then
        echo "❌ curl is required for Vimeo API calls"
        return 1
    fi
    
    # Check if jq is available for JSON parsing
    if ! command -v jq >/dev/null 2>&1; then
        echo "❌ jq is required for JSON parsing"
        echo "💡 Install with: sudo apt install jq (or brew install jq on macOS)"
        return 1
    fi
    
    return 0
}

# Initialize Vimeo configuration
init_vimeo_config() {
    local config_dir="$HOME/.config/vyn"
    local config_file="$config_dir/vimeo.conf"
    
    if [[ ! -f "$config_file" ]]; then
        echo ""
        echo "🎬 Vimeo Uploader Configuration"
        echo "================================"
        echo ""
        echo "To use the Vimeo uploader, you need to:"
        echo "1. Create a Vimeo developer app at: https://developer.vimeo.com/apps"
        echo "2. Generate an access token with 'upload' and 'create' scopes"
        echo "3. Enter your access token below"
        echo ""
        
        read -p "Enter your Vimeo Access Token: " vimeo_token
        
        if [[ -z "$vimeo_token" ]]; then
            echo "❌ Access token is required"
            return 1
        fi
        
        # Save configuration
        cat > "$config_file" << EOF
# Vimeo Configuration for Vyn
VIMEO_ACCESS_TOKEN="$vimeo_token"
EOF
        
        echo "✅ Configuration saved to $config_file"
        echo ""
    fi
    
    # Load configuration
    source "$config_file"
    
    if [[ -z "$VIMEO_ACCESS_TOKEN" ]]; then
        echo "❌ Vimeo access token not configured"
        echo "💡 Edit $config_file or delete it to reconfigure"
        return 1
    fi
    
    return 0
}

# Test Vimeo API connection
test_vimeo_connection() {
    echo "🔍 Testing Vimeo API connection..."
    
    local response=$(curl -s -H "Authorization: bearer $VIMEO_ACCESS_TOKEN" \
                          -H "Accept: application/vnd.vimeo.*+json;version=3.4" \
                          "$VIMEO_API_BASE/me")
    
    if echo "$response" | jq -e '.name' >/dev/null 2>&1; then
        local name=$(echo "$response" | jq -r '.name')
        echo "✅ Connected to Vimeo as: $name"
        return 0
    else
        echo "❌ Failed to connect to Vimeo API"
        echo "Response: $response"
        return 1
    fi
}

# Create a Vimeo folder (album)
create_vimeo_folder() {
    local folder_name="$1"
    local folder_description="$2"
    
    echo "📁 Creating Vimeo folder: $folder_name"
    
    local response=$(curl -s -X POST \
                          -H "Authorization: bearer $VIMEO_ACCESS_TOKEN" \
                          -H "Accept: application/vnd.vimeo.*+json;version=3.4" \
                          -H "Content-Type: application/json" \
                          -d "{\"name\":\"$folder_name\",\"description\":\"$folder_description\"}" \
                          "$VIMEO_API_BASE/me/albums")
    
    if echo "$response" | jq -e '.uri' >/dev/null 2>&1; then
        local album_uri=$(echo "$response" | jq -r '.uri')
        local album_id=$(basename "$album_uri")
        echo "✅ Folder created with ID: $album_id"
        echo "$album_id"
        return 0
    else
        echo "❌ Failed to create folder"
        echo "Response: $response"
        return 1
    fi
}

# Upload a single video to Vimeo
upload_video_to_vimeo() {
    local video_file="$1"
    local video_title="$2"
    local album_id="$3"
    
    echo "⬆️  Uploading: $(basename "$video_file")"
    
    # Create upload ticket
    local video_size=$(stat -c%s "$video_file" 2>/dev/null || stat -f%z "$video_file" 2>/dev/null)
    local upload_response=$(curl -s -X POST \
                                 -H "Authorization: bearer $VIMEO_ACCESS_TOKEN" \
                                 -H "Accept: application/vnd.vimeo.*+json;version=3.4" \
                                 -H "Content-Type: application/json" \
                                 -d "{\"upload\":{\"approach\":\"tus\",\"size\":$video_size},\"name\":\"$video_title\"}" \
                                 "$VIMEO_API_BASE/me/videos")
    
    if ! echo "$upload_response" | jq -e '.upload.upload_link' >/dev/null 2>&1; then
        echo "❌ Failed to create upload ticket"
        echo "Response: $upload_response"
        return 1
    fi
    
    local upload_link=$(echo "$upload_response" | jq -r '.upload.upload_link')
    local video_uri=$(echo "$upload_response" | jq -r '.uri')
    local video_id=$(basename "$video_uri")
    
    # Upload the video file using tus protocol
    echo "📤 Uploading file..."
    local upload_result=$(curl -s -X PATCH \
                               -H "Tus-Resumable: 1.0.0" \
                               -H "Upload-Offset: 0" \
                               -H "Content-Type: application/offset+octet-stream" \
                               --data-binary "@$video_file" \
                               "$upload_link")
    
    # Add video to album if provided
    if [[ -n "$album_id" ]]; then
        curl -s -X PUT \
             -H "Authorization: bearer $VIMEO_ACCESS_TOKEN" \
             -H "Accept: application/vnd.vimeo.*+json;version=3.4" \
             "$VIMEO_API_BASE/me/albums/$album_id/videos/$video_id" >/dev/null
    fi
    
    local video_url="https://vimeo.com/$video_id"
    echo "✅ Upload complete: $video_url"
    echo "$video_url"
    return 0
}

# Get list of video files in directory
get_video_files() {
    local directory="$1"
    find "$directory" -type f \( -iname "*.mp4" -o -iname "*.avi" -o -iname "*.mov" -o -iname "*.mkv" -o -iname "*.webm" -o -iname "*.flv" -o -iname "*.wmv" \) | sort
}

# Main upload function for folders
upload_folder_to_vimeo() {
    local folder_path="$1"
    
    if [[ ! -d "$folder_path" ]]; then
        echo "❌ Directory not found: $folder_path"
        return 1
    fi
    
    echo ""
    echo "🎬 Vimeo Folder Uploader"
    echo "========================"
    echo "📁 Processing folder: $folder_path"
    echo ""
    
    # Initialize configuration
    if ! init_vimeo_config; then
        return 1
    fi
    
    # Test connection
    if ! test_vimeo_connection; then
        return 1
    fi
    
    # Get video files
    local video_files=($(get_video_files "$folder_path"))
    
    if [[ ${#video_files[@]} -eq 0 ]]; then
        echo "❌ No video files found in $folder_path"
        return 1
    fi
    
    echo "📹 Found ${#video_files[@]} video file(s)"
    echo ""
    
    # Create Vimeo folder
    local folder_name=$(basename "$folder_path")
    local folder_description="Uploaded from $folder_path on $(date)"
    local album_id=$(create_vimeo_folder "$folder_name" "$folder_description")
    
    if [[ -z "$album_id" ]]; then
        echo "❌ Failed to create Vimeo folder"
        return 1
    fi
    
    # Upload all videos
    local links_file="$folder_path/links.txt"
    local album_url="https://vimeo.com/album/$album_id"
    
    echo ""
    echo "🔗 Playlist URL: $album_url" | tee "$links_file"
    echo "" >> "$links_file"
    echo "Individual video links:" >> "$links_file"
    echo "======================" >> "$links_file"
    
    local success_count=0
    local total_files=${#video_files[@]}
    
    for video_file in "${video_files[@]}"; do
        local video_title=$(basename "$video_file" | sed 's/\.[^.]*$//')
        echo ""
        echo "📽️  Processing ($((success_count + 1))/$total_files): $video_title"
        
        local video_url=$(upload_video_to_vimeo "$video_file" "$video_title" "$album_id")
        
        if [[ $? -eq 0 && -n "$video_url" ]]; then
            echo "$video_title: $video_url" >> "$links_file"
            success_count=$((success_count + 1))
        else
            echo "❌ Failed to upload: $video_file"
            echo "FAILED: $video_title" >> "$links_file"
        fi
    done
    
    echo ""
    echo "🎉 Upload Summary"
    echo "================="
    echo "✅ Successfully uploaded: $success_count/$total_files videos"
    echo "📋 Links saved to: $links_file"
    echo "🔗 Playlist URL: $album_url"
    echo ""
    
    return 0
}

# Plugin execution function (required by vyn plugin system)
execute_plugin() {
    local input_path="$1"
    local output_path="$2"  # Not used for folder uploads
    
    # Validate plugin requirements
    if ! validate_plugin; then
        return 1
    fi
    
    # Check if input is a directory
    if [[ -d "$input_path" ]]; then
        upload_folder_to_vimeo "$input_path"
        return $?
    else
        echo "❌ Vimeo uploader requires a directory path"
        echo "💡 Usage: vyn --plugin vimeo-uploader /path/to/video/folder"
        return 1
    fi
}

# If script is run directly (not sourced), run the main function
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    if [[ $# -lt 1 ]]; then
        echo "Usage: $0 <folder_path>"
        exit 1
    fi
    
    upload_folder_to_vimeo "$1"
fi
