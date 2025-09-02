#!/usr/bin/env bash

# Installation script for vyn - A powerful video format converter
# Fast, intuitive video conversion using FFmpeg with interactive CLI
#
# Repository: https://github.com/samonide/vyn
# License: Unlicense
# Version: 1.0.0

set -euo pipefail

# Script information
readonly SCRIPT_NAME="install-vyn"
readonly VERSION="1.0.1-dev"
readonly REPOSITORY="https://github.com/samonide/vyn"

# Terminal color codes
readonly RED='\033[0;31m'
readonly GREEN='\033[0;32m'
readonly YELLOW='\033[1;33m'
readonly BLUE='\033[0;34m'
readonly PURPLE='\033[0;35m'
readonly CYAN='\033[0;36m'
readonly NC='\033[0m' # No Color

# Functions for colored output
print_color() {
    printf "${1}${2}${NC}\n"
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

# Detect script directory and vyn script location
readonly SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
readonly VYN_SCRIPT="$SCRIPT_DIR/vyn"

# Function to check dependencies
check_dependencies() {
    local missing_deps=()
    local install_cmd=""
    
    # Check for ffmpeg
    if ! command -v ffmpeg &> /dev/null; then
        missing_deps+=("ffmpeg")
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
    elif command -v zypper &> /dev/null; then
        install_cmd="sudo zypper install"
    else
        install_cmd="# Use your package manager to install"
    fi
    
    if [[ ${#missing_deps[@]} -gt 0 ]]; then
        print_error "Missing required dependencies!"
        print_info "Please install the following packages first:"
        for dep in "${missing_deps[@]}"; do
            echo "  ${install_cmd} ${dep}"
        done
        echo ""
        print_info "jq is optional but recommended for better file information display:"
        echo "  ${install_cmd} jq"
        exit 1
    fi
    
    print_success "✅ FFmpeg is installed: $(which ffmpeg)"
    
    if command -v jq &> /dev/null; then
        print_success "✅ jq is installed: $(which jq)"
    else
        print_warning "⚠️  jq is not installed (optional but recommended)"
        print_info "Install with: ${install_cmd} jq"
    fi
}

# Function to validate vyn script
validate_script() {
    if [[ ! -f "$VYN_SCRIPT" ]]; then
        print_error "vyn script not found at $VYN_SCRIPT"
        print_info "Please ensure you're running this script from the vyn directory"
        exit 1
    fi
    
    if [[ ! -x "$VYN_SCRIPT" ]]; then
        print_info "Making vyn script executable..."
        chmod +x "$VYN_SCRIPT"
    fi
    
    print_success "✅ vyn script found and validated"
}

# Function to install to system directory
install_system() {
    print_info "🚀 Installing to /usr/local/bin..."
    
    if sudo ln -sf "$VYN_SCRIPT" /usr/local/bin/vyn; then
        print_success "✅ Successfully installed to /usr/local/bin/vyn"
        print_success "🎉 You can now use 'vyn' from anywhere!"
        return 0
    else
        print_error "Installation to /usr/local/bin failed!"
        return 1
    fi
}

# Function to install to user directory
install_user() {
    print_info "🏠 Installing to ~/.local/bin..."
    
    # Create directory if it doesn't exist
    mkdir -p ~/.local/bin
    
    # Create symlink
    if ln -sf "$VYN_SCRIPT" ~/.local/bin/vyn; then
        print_success "✅ Successfully installed to ~/.local/bin/vyn"
        
        # Check if ~/.local/bin is in PATH
        if [[ ":$PATH:" == *":$HOME/.local/bin:"* ]]; then
            print_success "✅ ~/.local/bin is already in your PATH"
            print_success "🎉 You can now use 'vyn' from anywhere!"
        else
            print_warning "⚠️  ~/.local/bin is not in your PATH"
            print_info "Add this line to your shell configuration file:"
            print_color "$CYAN" 'export PATH="$HOME/.local/bin:$PATH"'
            
            # Detect shell and provide specific instructions
            local shell_config=""
            case "$SHELL" in
                */bash)
                    shell_config="~/.bashrc"
                    ;;
                */zsh)
                    shell_config="~/.zshrc"
                    ;;
                */fish)
                    shell_config="~/.config/fish/config.fish"
                    print_info "For fish shell, use: set -U fish_user_paths \$HOME/.local/bin \$fish_user_paths"
                    ;;
                *)
                    shell_config="your shell's configuration file"
                    ;;
            esac
            
            if [[ "$shell_config" != *"fish"* ]]; then
                print_info "Add to $shell_config, then run: source $shell_config"
            fi
        fi
        return 0
    else
        print_error "Installation to ~/.local/bin failed!"
        return 1
    fi
}

# Function to add current directory to PATH
install_path() {
    print_info "📁 Adding current directory to PATH..."
    
    # Check if directory is already in PATH
    if [[ ":$PATH:" == *":$SCRIPT_DIR:"* ]]; then
        print_warning "⚠️  Directory is already in PATH"
    else
        print_info "Add this line to your shell configuration file:"
        print_color "$CYAN" "export PATH=\"$SCRIPT_DIR:\$PATH\""
        
        # Detect shell and provide specific instructions
        local shell_config=""
        case "$SHELL" in
            */bash)
                shell_config="~/.bashrc"
                ;;
            */zsh)
                shell_config="~/.zshrc"
                ;;
            */fish)
                shell_config="~/.config/fish/config.fish"
                print_info "For fish shell, use: set -U fish_user_paths $SCRIPT_DIR \$fish_user_paths"
                ;;
            *)
                shell_config="your shell's configuration file"
                ;;
        esac
        
        if [[ "$shell_config" != *"fish"* ]]; then
            print_info "Add to $shell_config, then run: source $shell_config"
        fi
    fi
    
    print_success "🎉 You can use 'vyn' once PATH is updated!"
    return 0
}

# Main installation function
main() {
    print_color "$BLUE" "🎬 Vyn Installation Script v${VERSION}"
    print_info "Repository: $REPOSITORY"
    echo ""
    
    # Validate dependencies and script
    check_dependencies
    validate_script
    
    echo ""
    print_color "$YELLOW" "📦 Installation Options:"
    echo "1) 🌐 Global installation (/usr/local/bin) - requires sudo, accessible from anywhere"
    echo "2) 🏠 User installation (~/.local/bin) - no sudo required, accessible from anywhere"
    echo "3) 📁 PATH addition - uses current directory location"
    echo "4) ❌ Cancel installation"
    echo ""
    
    while true; do
        read -r -p "Choose installation method (1-4): " choice
        case $choice in
            1)
                if install_system; then
                    break
                else
                    print_info "System installation failed. Try user installation instead."
                fi
                ;;
            2)
                if install_user; then
                    break
                else
                    exit 1
                fi
                ;;
            3)
                if install_path; then
                    break
                else
                    exit 1
                fi
                ;;
            4)
                print_info "Installation cancelled."
                exit 0
                ;;
            *)
                print_error "Invalid choice. Please enter 1, 2, 3, or 4."
                ;;
        esac
    done
    
    echo ""
    print_success "🎉 Installation completed!"
    print_info "Test the installation by running:"
    print_color "$CYAN" "vyn --help"
    echo ""
    print_info "💡 Usage examples:"
    print_color "$CYAN" "vyn input.mkv output.mp4"
    print_color "$CYAN" "vyn /path/to/video.avi"
    echo ""
    print_info "🐛 Report issues at: $REPOSITORY/issues"
}

# Run main function with all arguments
main "$@"
