#!/usr/bin/env bash
# Vyn Utilities Module
# Common helper functions used across Vyn
# Version: 1.5.0

# Module initialization
readonly UTILS_MODULE_VERSION="1.5.0"

# Color output functions
print_color() {
    if [[ $# -eq 2 ]]; then
        # If two arguments provided, first is color, second is message
        printf "${1}${2}${NC}\n"
    else
        # If only one argument provided, treat it as the message with default color
        printf "${1}\n"
    fi
}

print_error() {
    print_color "$RED" "ERROR: $1" >&2
}

print_warning() {
    print_color "$YELLOW" "WARNING: $1"
}

print_info() {
    print_color "$CYAN" "INFO: $1"
}

print_success() {
    print_color "$GREEN" "$1"
}

# Check if required tools are installed
check_dependencies() {
    local missing_deps=()
    local install_cmd=""
    
    # Check for ffmpeg
    if ! command -v ffmpeg &> /dev/null; then
        missing_deps+=("ffmpeg")
    fi
    
    # Check for jq (optional but recommended)
    if ! command -v jq &> /dev/null; then
        missing_deps+=("jq")
    fi
    
    # Determine package manager and install command
    if command -v pacman &> /dev/null; then
        install_cmd="sudo pacman -S"
    elif command -v apt &> /dev/null; then
        install_cmd="sudo apt install"
    elif command -v dnf &> /dev/null; then
        install_cmd="sudo dnf install"
    elif command -v brew &> /dev/null; then
        install_cmd="brew install"
    else
        install_cmd="# Use your package manager to install"
    fi
    
    if [ ${#missing_deps[@]} -gt 0 ]; then
        print_error "Missing required dependencies!"
        print_info "Please install the following packages:"
        for dep in "${missing_deps[@]}"; do
            echo "  ${install_cmd} ${dep}"
        done
        echo ""
        print_info "FFmpeg is required for video conversion."
        print_info "jq is optional but provides better file information display."
        exit 1
    fi
}

# File validation functions
is_video_file() {
    local file="${1}"
    local ext="${file##*.}"
    
    case "${ext,,}" in
        mp4|mkv|avi|mov|webm|flv|wmv|m4v|3gp|ts|vob|mpg|mpeg)
            return 0
            ;;
        *)
            return 1
            ;;
    esac
}

is_audio_file() {
    local file="${1}"
    local ext="${file##*.}"
    
    case "${ext,,}" in
        mp3|flac|aac|opus|wav|ogg|m4a)
            return 0
            ;;
        *)
            return 1
            ;;
    esac
}

# Get video file information
get_video_duration() {
    local file="${1}"
    if command -v ffprobe &>/dev/null; then
        ffprobe -v quiet -show_entries format=duration \
            -of default=noprint_wrappers=1:nokey=1 "$file" 2>/dev/null
    else
        echo "unknown"
    fi
}

get_video_codec() {
    local file="${1}"
    if command -v ffprobe &>/dev/null; then
        ffprobe -v quiet -show_entries stream=codec_name \
            -select_streams v:0 -of default=noprint_wrappers=1:nokey=1 "$file" 2>/dev/null
    else
        echo "unknown"
    fi
}

get_audio_codec() {
    local file="${1}"
    if command -v ffprobe &>/dev/null; then
        ffprobe -v quiet -show_entries stream=codec_name \
            -select_streams a:0 -of default=noprint_wrappers=1:nokey=1 "$file" 2>/dev/null
    else
        echo "unknown"
    fi
}

get_video_resolution() {
    local file="${1}"
    if command -v ffprobe &>/dev/null; then
        ffprobe -v quiet -show_entries stream=width,height \
            -select_streams v:0 -of csv=s=x:p=0 "$file" 2>/dev/null
    else
        echo "unknown"
    fi
}

get_file_size_mb() {
    local file="${1}"
    if [[ -f "$file" ]]; then
        local size_bytes=$(stat -f%z "$file" 2>/dev/null || stat -c%s "$file" 2>/dev/null)
        echo "$((size_bytes / 1024 / 1024))"
    else
        echo "0"
    fi
}

# Path manipulation helpers
get_output_extension() {
    local output_file="${1}"
    echo "${output_file##*.}"
}

get_filename_without_ext() {
    local file="${1}"
    local basename="${file##*/}"
    echo "${basename%.*}"
}

# Validation helpers
validate_input_file() {
    local input="${1}"
    
    if [[ ! -f "$input" ]]; then
        print_error "Input file not found: $input"
        return 1
    fi
    
    if ! is_video_file "$input" && ! is_audio_file "$input"; then
        print_error "Input file is not a supported video or audio format"
        return 1
    fi
    
    return 0
}

validate_output_path() {
    local output="${1}"
    local output_dir=$(dirname "$output")
    
    if [[ ! -d "$output_dir" ]]; then
        print_error "Output directory does not exist: $output_dir"
        return 1
    fi
    
    if [[ ! -w "$output_dir" ]]; then
        print_error "Output directory is not writable: $output_dir"
        return 1
    fi
    
    if [[ -f "$output" ]] && [[ ! -w "$output" ]]; then
        print_error "Output file exists and is not writable: $output"
        return 1
    fi
    
    return 0
}

# Format bytes to human readable
format_bytes() {
    local bytes="${1}"
    
    if [[ $bytes -lt 1024 ]]; then
        echo "${bytes}B"
    elif [[ $bytes -lt 1048576 ]]; then
        echo "$((bytes / 1024))KB"
    elif [[ $bytes -lt 1073741824 ]]; then
        echo "$((bytes / 1024 / 1024))MB"
    else
        echo "$((bytes / 1024 / 1024 / 1024))GB"
    fi
}

# Format seconds to human readable time
format_duration() {
    local seconds="${1%.*}"  # Remove decimal part
    
    if [[ -z "$seconds" ]] || [[ "$seconds" == "unknown" ]]; then
        echo "unknown"
        return
    fi
    
    local hours=$((seconds / 3600))
    local minutes=$(( (seconds % 3600) / 60 ))
    local secs=$((seconds % 60))
    
    if [[ $hours -gt 0 ]]; then
        printf "%dh %dm %ds" "$hours" "$minutes" "$secs"
    elif [[ $minutes -gt 0 ]]; then
        printf "%dm %ds" "$minutes" "$secs"
    else
        printf "%ds" "$secs"
    fi
}

# Progress bar helper
show_progress() {
    local current="${1}"
    local total="${2}"
    local width=50
    
    if [[ $total -eq 0 ]]; then
        return
    fi
    
    local percentage=$((current * 100 / total))
    local filled=$((width * current / total))
    local empty=$((width - filled))
    
    printf "\r["
    printf "%${filled}s" | tr ' ' '='
    printf "%${empty}s" | tr ' ' ' '
    printf "] %d%%" "$percentage"
}

# Confirmation prompt
confirm() {
    local prompt="${1:-Are you sure?}"
    local default="${2:-n}"
    
    if [[ "$default" == "y" ]]; then
        prompt="$prompt [Y/n]: "
    else
        prompt="$prompt [y/N]: "
    fi
    
    read -p "$prompt" -n 1 -r
    echo
    
    if [[ "$default" == "y" ]]; then
        [[ $REPLY =~ ^[Yy]$ ]] || [[ -z $REPLY ]]
    else
        [[ $REPLY =~ ^[Yy]$ ]]
    fi
}

# Module info
utils_module_info() {
    echo "Vyn Utilities Module v${UTILS_MODULE_VERSION}"
}
