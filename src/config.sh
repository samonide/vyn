#!/usr/bin/env bash
# Vyn Configuration Module
# Configuration file management and loading
# Version: 1.5.0

readonly CONFIG_MODULE_VERSION="1.5.0"

# Load configuration from file
load_config() {
    if [[ -f "$CONFIG_FILE" ]]; then
        print_info "📄 Loading configuration from $CONFIG_FILE"
        # shellcheck source=/dev/null
        source "$CONFIG_FILE"
        print_success "✅ Configuration loaded"
    fi
}

# Load Vimeo configuration
load_vimeo_config() {
    if [[ -f "$VIMEO_CONFIG_FILE" ]]; then
        print_info "📄 Loading Vimeo configuration from $VIMEO_CONFIG_FILE"
        # shellcheck source=/dev/null
        source "$VIMEO_CONFIG_FILE"
        print_success "✅ Vimeo configuration loaded"
    fi
}

# Save current configuration to file
save_config() {
    local config_dir
    config_dir="$(dirname "$CONFIG_FILE")"
    
    if [[ ! -d "$config_dir" ]]; then
        mkdir -p "$config_dir"
    fi
    
    cat > "$CONFIG_FILE" << EOF
# Vyn Configuration File
# Generated on $(date)

# Default operation mode: remux or encode
DEFAULT_OPERATION_MODE="$OPERATION_MODE"

# Default quality settings for encode mode
DEFAULT_CRF_VALUE="$CRF_VALUE"

# GPU acceleration settings
USE_GPU="$USE_GPU"
GPU_TYPE="$GPU_TYPE"

# UI preferences
USE_COLOR="$USE_COLOR"

# Audio-only mode preference
AUDIO_ONLY="$AUDIO_ONLY"

# Original file handling preference
DELETE_ORIGINAL="$DELETE_ORIGINAL"
EOF
    
    print_success "✅ Configuration saved to $CONFIG_FILE"
}

# Module info
config_module_info() {
    echo "Vyn Configuration Module v${CONFIG_MODULE_VERSION}"
}
