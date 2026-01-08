#!/usr/bin/env bash
# Vyn GPU Acceleration Module
# GPU detection and hardware acceleration support
# Version: 1.5.0

readonly GPU_MODULE_VERSION="1.5.0"

# Detect available GPU acceleration
detect_gpu_acceleration() {
    print_info "🔍 Detecting GPU acceleration capabilities..."
    
    # Check for NVIDIA GPU support
    if ffmpeg -hide_banner -encoders 2>/dev/null | grep -q "nvenc"; then
        if nvidia-smi &>/dev/null; then
            print_success "🎮 NVIDIA GPU acceleration available (NVENC)"
            GPU_TYPE="nvenc"
            return 0
        fi
    fi
    
    # Check for AMD/Intel VAAPI support (Linux)
    if [[ "$OSTYPE" == "linux-gnu"* ]] && ffmpeg -hide_banner -encoders 2>/dev/null | grep -q "vaapi"; then
        if [[ -e /dev/dri/renderD128 ]]; then
            print_success "🎮 VAAPI GPU acceleration available"
            GPU_TYPE="vaapi"
            return 0
        fi
    fi
    
    # Check for Intel QuickSync support
    if ffmpeg -hide_banner -encoders 2>/dev/null | grep -q "qsv"; then
        print_info "🎮 Intel QuickSync may be available"
        GPU_TYPE="qsv"
        return 0
    fi
    
    print_warning "⚠️  No GPU acceleration detected"
    return 1
}

# Get GPU-specific encoder
get_gpu_encoder() {
    local codec="${1:-h264}"
    
    case "$GPU_TYPE" in
        nvenc)
            echo "h264_nvenc"
            ;;
        vaapi)
            echo "h264_vaapi"
            ;;
        qsv)
            echo "h264_qsv"
            ;;
        *)
            echo "libx264"
            ;;
    esac
}

# Module info
gpu_module_info() {
    echo "Vyn GPU Module v${GPU_MODULE_VERSION}"
}
