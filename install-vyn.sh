#!/bin/bash
# Vyn Video Converter - One-Command Installer
# Install vyn with a single command: sh -c "$(curl -fsSL https://raw.githubusercontent.com/samonide/vyn/main/install-vyn.sh)"
# Cross-platform installer for Linux, macOS, and Windows

set -e

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
WHITE='\033[1;37m'
NC='\033[0m' # No Color

# Functions
print_color() {
    printf "${1}${2}${NC}\n"
}

print_success() {
    print_color "$GREEN" "✅ $1"
}

print_error() {
    print_color "$RED" "❌ $1"
}

print_warning() {
    print_color "$YELLOW" "⚠️  $1"
}

print_info() {
    print_color "$BLUE" "ℹ️  $1"
}

# Check if command exists
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# Detect OS
detect_os() {
    if [[ "$OSTYPE" == "linux-gnu"* ]]; then
        echo "linux"
    elif [[ "$OSTYPE" == "darwin"* ]]; then
        echo "macos"
    elif [[ "$OSTYPE" == "msys" || "$OSTYPE" == "cygwin" ]]; then
        echo "windows"
    else
        echo "unknown"
    fi
}

# Install dependencies based on OS
install_dependencies() {
    local os=$(detect_os)
    
    print_info "Installing dependencies for $os..."
    
    case "$os" in
        "linux")
            if command_exists apt; then
                # Debian/Ubuntu
                print_info "Using apt package manager..."
                sudo apt update
                sudo apt install -y ffmpeg curl jq bc
            elif command_exists dnf; then
                # Fedora
                print_info "Using dnf package manager..."
                sudo dnf install -y ffmpeg curl jq bc
            elif command_exists yum; then
                # CentOS/RHEL
                print_info "Using yum package manager..."
                sudo yum install -y ffmpeg curl jq bc
            elif command_exists pacman; then
                # Arch Linux
                print_info "Using pacman package manager..."
                sudo pacman -S --noconfirm ffmpeg curl jq bc
            elif command_exists zypper; then
                # openSUSE
                print_info "Using zypper package manager..."
                sudo zypper install -y ffmpeg curl jq bc
            else
                print_warning "Unknown Linux package manager. Please install ffmpeg, curl, jq, and bc manually."
                return 1
            fi
            ;;
        "macos")
            if command_exists brew; then
                print_info "Using Homebrew..."
                brew install ffmpeg jq bc
            else
                print_error "Homebrew not found. Please install Homebrew first:"
                print_info "Visit: https://brew.sh"
                return 1
            fi
            ;;
        "windows")
            print_warning "Windows detected. Please install dependencies manually:"
            print_info "1. Install FFmpeg: https://ffmpeg.org/download.html"
            print_info "2. Install Git Bash or Windows Subsystem for Linux (WSL)"
            print_info "3. Install jq and bc through your package manager"
            return 1
            ;;
        *)
            print_error "Unsupported operating system: $OSTYPE"
            return 1
            ;;
    esac
}

# Check dependencies
check_dependencies() {
    local missing_deps=()
    
    if ! command_exists ffmpeg; then
        missing_deps+=("ffmpeg")
    fi
    
    if ! command_exists curl; then
        missing_deps+=("curl")
    fi
    
    if ! command_exists jq; then
        missing_deps+=("jq")
    fi
    
    if ! command_exists bc; then
        missing_deps+=("bc")
    fi
    
    if [[ ${#missing_deps[@]} -gt 0 ]]; then
        print_warning "Missing dependencies: ${missing_deps[*]}"
        print_info "Attempting to install dependencies..."
        
        if ! install_dependencies; then
            print_error "Failed to install dependencies automatically."
            print_info "Please install the following manually: ${missing_deps[*]}"
            return 1
        fi
    else
        print_success "All dependencies are already installed!"
    fi
}

# Create installation directory
create_install_dir() {
    local install_dir="$HOME/.local/bin"
    
    if [[ ! -d "$install_dir" ]]; then
        mkdir -p "$install_dir"
        print_info "Created installation directory: $install_dir"
    fi
    
    # Add to PATH if not already there
    if [[ ":$PATH:" != *":$install_dir:"* ]]; then
        echo 'export PATH="$HOME/.local/bin:$PATH"' >> "$HOME/.bashrc"
        if [[ -f "$HOME/.zshrc" ]]; then
            echo 'export PATH="$HOME/.local/bin:$PATH"' >> "$HOME/.zshrc"
        fi
        print_info "Added $install_dir to PATH in shell configuration"
        print_warning "Please restart your terminal or run: source ~/.bashrc"
    fi
    
    echo "$install_dir"
}

# Download and install vyn
install_vyn() {
    local install_dir=$(create_install_dir)
    local temp_dir=$(mktemp -d)
    local vyn_url="https://raw.githubusercontent.com/samonide/vyn/main/vyn"
    
    print_info "Downloading vyn from GitHub..."
    
    if ! curl -fsSL "$vyn_url" -o "$temp_dir/vyn"; then
        print_error "Failed to download vyn from $vyn_url"
        rm -rf "$temp_dir"
        return 1
    fi
    
    # Download plugins manifest
    local plugins_url="https://raw.githubusercontent.com/samonide/vyn/main/plugins.json"
    print_info "Downloading plugin manifest..."
    
    if ! curl -fsSL "$plugins_url" -o "$temp_dir/plugins.json"; then
        print_warning "Failed to download plugins.json from $plugins_url"
        print_info "Plugin installation will be limited"
    fi
    
    # Make executable and install
    chmod +x "$temp_dir/vyn"
    
    if ! mv "$temp_dir/vyn" "$install_dir/vyn"; then
        print_error "Failed to install vyn to $install_dir"
        rm -rf "$temp_dir"
        return 1
    fi
    
    # Install plugins manifest if downloaded successfully
    if [[ -f "$temp_dir/plugins.json" ]]; then
        if ! mv "$temp_dir/plugins.json" "$install_dir/plugins.json"; then
            print_warning "Failed to install plugins.json to $install_dir"
        else
            print_info "Plugin manifest installed to $install_dir/plugins.json"
        fi
    fi
    
    # Create symlink for global access (optional)
    if command_exists sudo && [[ -d "/usr/local/bin" ]]; then
        if sudo ln -sf "$install_dir/vyn" "/usr/local/bin/vyn" 2>/dev/null; then
            print_info "Created global symlink: /usr/local/bin/vyn"
        fi
    fi
    
    rm -rf "$temp_dir"
    print_success "vyn installed successfully to $install_dir/vyn"
}

# Setup configuration directory
setup_config() {
    local config_dir="$HOME/.config/vyn"
    
    if [[ ! -d "$config_dir" ]]; then
        mkdir -p "$config_dir"
        print_info "Created configuration directory: $config_dir"
    fi
    
    # Create plugins directory
    if [[ ! -d "$config_dir/plugins" ]]; then
        mkdir -p "$config_dir/plugins"
        print_info "Created plugins directory: $config_dir/plugins"
    fi
    
    # Download default configuration if it doesn't exist
    if [[ ! -f "$config_dir/config.conf" ]]; then
        local config_url="https://raw.githubusercontent.com/samonide/vyn/main/config.conf"
        if curl -fsSL "$config_url" -o "$config_dir/config.conf" 2>/dev/null; then
            print_info "Downloaded default configuration"
        else
            print_warning "Could not download default configuration (will be created on first run)"
        fi
    fi
}

# Verify installation
verify_installation() {
    local install_dir="$HOME/.local/bin"
    
    if [[ -x "$install_dir/vyn" ]]; then
        print_success "Installation verified!"
        
        # Test basic functionality
        if "$install_dir/vyn" --version >/dev/null 2>&1; then
            print_success "vyn is working correctly!"
        else
            print_warning "vyn installed but may have issues. Try running: vyn --help"
        fi
        
        return 0
    else
        print_error "Installation verification failed!"
        return 1
    fi
}

# Show post-installation info
show_post_install_info() {
    echo ""
    print_color "$PURPLE" "🎉 Vyn Video Converter Installation Complete!"
    echo ""
    print_color "$CYAN" "📋 Quick Start:"
    echo "  vyn --help                    # Show help"
    echo "  vyn input.mp4 output.mp4     # Basic conversion"
    echo "  vyn --list-plugins            # List available plugins"
    echo ""
    print_color "$CYAN" "🔧 Configuration:"
    print_info "Config directory: ~/.config/vyn/"
    print_info "Plugins directory: ~/.config/vyn/plugins/"
    echo ""
    print_color "$CYAN" "� Advanced Usage:"
    echo "  vyn --preset cinema input.mp4 output.mp4    # Professional preset"
    echo "  vyn --batch /path/to/videos/                # Batch conversion"
    echo "  vyn --plugin quality-analyzer /videos/      # Analyze video quality"
    echo ""
    
    if [[ ":$PATH:" != *":$HOME/.local/bin:"* ]]; then
        print_color "$YELLOW" "⚠️  Important:"
        print_warning "Please restart your terminal or run: source ~/.bashrc"
        print_info "This ensures vyn is available in your PATH"
        echo ""
    fi
    
    print_color "$GREEN" "✨ Enjoy using vyn! Visit: https://github.com/samonide/vyn"
}

# Main installation function
main() {
    echo ""
    print_color "$PURPLE" "🎬 Vyn Video Converter - One-Command Installer"
    print_color "$CYAN" "=================================================="
    echo ""
    
    # Check if already installed
    if command_exists vyn; then
        print_warning "vyn is already installed!"
        print_info "Current version: $(vyn --version 2>/dev/null || echo 'unknown')"
        echo ""
        read -p "Do you want to reinstall/update? (y/N): " -n 1 -r
        echo ""
        if [[ ! $REPLY =~ ^[Yy]$ ]]; then
            print_info "Installation cancelled."
            exit 0
        fi
        echo ""
    fi
    
    # Check dependencies
    print_info "Checking dependencies..."
    if ! check_dependencies; then
        print_error "Dependency check failed!"
        exit 1
    fi
    echo ""
    
    # Install vyn
    print_info "Installing vyn..."
    if ! install_vyn; then
        print_error "Installation failed!"
        exit 1
    fi
    echo ""
    
    # Setup configuration
    print_info "Setting up configuration..."
    setup_config
    echo ""
    
    # Verify installation
    print_info "Verifying installation..."
    if ! verify_installation; then
        exit 1
    fi
    
    # Show post-installation info
    show_post_install_info
}

# Check if script is being run with bash
if [[ -z "${BASH_VERSION}" ]]; then
    print_error "This installer requires bash. Please run with bash."
    exit 1
fi

# Check internet connection
if ! curl -fsSL "https://api.github.com" >/dev/null 2>&1; then
    print_error "No internet connection detected. Please check your connection and try again."
    exit 1
fi

# Run main installation
main "$@"
