#!/usr/bin/env bash
# Vyn Professional Presets Module
# Industry-standard conversion presets
# Version: 1.5.0

readonly PRESETS_MODULE_VERSION="1.5.0"

# Load professional presets
load_professional_presets() {
    local preset_file="$HOME/.config/vyn/presets.json"
    if [[ -f "$preset_file" ]]; then
        print_info "📋 Loading professional presets from $preset_file"
    fi
    return 0
}

# Setup professional presets menu
setup_professional_presets() {
    echo ""
    print_color "$PURPLE" "🎯 Professional Preset Selection"
    echo "1) Broadcast (High quality for TV/broadcasting)"
    echo "2) Cinema (Film industry standard)"
    echo "3) Web Streaming (Optimized for YouTube, Twitch)"
    echo "4) Mobile (Optimized for phones and tablets)"
    echo "5) Archive (Maximum quality preservation)"
    echo "6) Social Media (Instagram, TikTok, Twitter)"
    echo "7) Custom Professional"
    echo ""
    
    while true; do
        read -r -p "Select professional preset (1-7): " preset_choice
        case $preset_choice in
            1)
                PROFESSIONAL_PRESET="broadcast"
                CRF_VALUE="18"
                VIDEO_FILTERS="deinterlace"
                print_success "Selected: Broadcast preset (CRF 18, deinterlaced)"
                break
                ;;
            2)
                PROFESSIONAL_PRESET="cinema"
                CRF_VALUE="16"
                VIDEO_FILTERS="colorspace=bt709"
                print_success "Selected: Cinema preset (CRF 16, BT.709 colorspace)"
                break
                ;;
            3)
                PROFESSIONAL_PRESET="web_streaming"
                CRF_VALUE="23"
                VIDEO_FILTERS="scale=1920:1080"
                print_success "Selected: Web Streaming preset (CRF 23, 1080p)"
                break
                ;;
            4)
                PROFESSIONAL_PRESET="mobile"
                CRF_VALUE="28"
                VIDEO_FILTERS="scale=1280:720"
                print_success "Selected: Mobile preset (CRF 28, 720p)"
                break
                ;;
            5)
                PROFESSIONAL_PRESET="archive"
                CRF_VALUE="12"
                VIDEO_FILTERS="denoise=light"
                print_success "Selected: Archive preset (CRF 12, light denoising)"
                break
                ;;
            6)
                PROFESSIONAL_PRESET="social_media"
                CRF_VALUE="26"
                VIDEO_FILTERS="scale=1080:1080"
                print_success "Selected: Social Media preset (CRF 26, square format)"
                break
                ;;
            7)
                setup_custom_professional_preset
                break
                ;;
            *)
                print_error "Invalid choice. Please enter 1-7."
                ;;
        esac
    done
}

# Setup custom professional preset
setup_custom_professional_preset() {
    print_color "$CYAN" "🔧 Custom Professional Preset Configuration"
    
    read -r -p "Enter custom CRF value (10-30): " custom_crf
    if [[ "$custom_crf" =~ ^[0-9]+$ ]] && [ "$custom_crf" -ge 10 ] && [ "$custom_crf" -le 30 ]; then
        CRF_VALUE="$custom_crf"
    else
        print_warning "Invalid CRF, using default 23"
        CRF_VALUE="23"
    fi
    
    echo ""
    print_color "$CYAN" "Available video filters:"
    echo "1) None"
    echo "2) Deinterlace"
    echo "3) Denoise (light)"
    echo "4) Denoise (strong)"
    echo "5) Scale to 1080p"
    echo "6) Scale to 720p"
    echo "7) Color correction"
    
    read -r -p "Select video filter (1-7): " filter_choice
    case $filter_choice in
        1) VIDEO_FILTERS="" ;;
        2) VIDEO_FILTERS="deinterlace" ;;
        3) VIDEO_FILTERS="denoise=light" ;;
        4) VIDEO_FILTERS="denoise=strong" ;;
        5) VIDEO_FILTERS="scale=1920:1080" ;;
        6) VIDEO_FILTERS="scale=1280:720" ;;
        7) VIDEO_FILTERS="colorspace=bt709,eq=brightness=0.02:contrast=1.1" ;;
        *) VIDEO_FILTERS="" ;;
    esac
    
    PROFESSIONAL_PRESET="custom"
    print_success "Custom preset configured: CRF $CRF_VALUE, Filters: ${VIDEO_FILTERS:-none}"
}

# Apply preset by name
apply_preset() {
    local preset_name="${1}"
    
    case "$preset_name" in
        broadcast)
            CRF_VALUE="18"
            VIDEO_FILTERS="deinterlace"
            PROFESSIONAL_PRESET="broadcast"
            ;;
        cinema)
            CRF_VALUE="16"
            VIDEO_FILTERS="colorspace=bt709"
            PROFESSIONAL_PRESET="cinema"
            ;;
        web)
            CRF_VALUE="23"
            VIDEO_FILTERS="scale=1920:1080"
            PROFESSIONAL_PRESET="web_streaming"
            ;;
        mobile)
            CRF_VALUE="28"
            VIDEO_FILTERS="scale=1280:720"
            PROFESSIONAL_PRESET="mobile"
            ;;
        archive)
            CRF_VALUE="12"
            VIDEO_FILTERS="denoise=light"
            PROFESSIONAL_PRESET="archive"
            ;;
        social)
            CRF_VALUE="26"
            VIDEO_FILTERS="scale=1080:1080"
            PROFESSIONAL_PRESET="social_media"
            ;;
        *)
            print_error "Unknown preset: $preset_name"
            return 1
            ;;
    esac
    
    return 0
}

# Module info
presets_module_info() {
    echo "Vyn Presets Module v${PRESETS_MODULE_VERSION}"
}
