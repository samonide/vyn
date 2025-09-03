<div align="center">

# 🎬 Vyn

**Video. Simplified.**

[![License: Unlicense](https://img.shields.io/badge/license-Unlicense-blue.svg)](http://unlicense.org/)
[![Shell Script](https://img.shields.io/badge/Shell-Bash-green.svg)](https://www.gnu.org/software/bash/)
[![FFmpeg](https://img.shields.io/badge/Powered%20by-FFmpeg-orange.svg)](https://ffmpeg.org/)
[![Version](https://img.shields.io/badge/version-1.3.0-brightgreen.svg)](https://github.com/samonide/vyn/releases)
[![Platform](https://img.shields.io/badge/platform-Linux%20%7C%20macOS%20%7C%20Windows-lightgrey.svg)]()

*A powerful, professional video converter that transforms complex FFmpeg workflows into simple, beautiful commands*

[🚀 Quick Start](#-quick-start) • [✨ Features](#-features) • [📖 Documentation](#-documentation) • [🤝 Contributing](#-contributing)

</div>

---

## 🚀 Quick Start

```bash
# Install Vyn
git clone https://github.com/samonide/vyn.git && cd vyn && ./install-vyn.sh

# Convert a video (interactive mode)
vyn movie.mkv movie.mp4

# That's it! Vyn guides you through the rest.
```

## ✨ Features

### 🎯 **Core Capabilities**
- **🚀 Dual Modes**: Lightning-fast **Remux** (container-only) or precision **Encode** (quality control)
- **🗂️ Batch Processing**: Convert entire directories with intelligent file discovery
- **🎵 Audio Extraction**: Extract audio tracks in any format (MP3, FLAC, AAC, Opus)
- **🎮 GPU Acceleration**: Hardware-accelerated encoding (NVENC, VAAPI, QuickSync)
- **🔍 Dry Run**: Preview operations safely without touching files

### 🎯 **Professional Features (v1.3.0)**
- **🎬 Professional Presets**: Industry-standard settings for broadcast, cinema, web, mobile, archive, and social media
- **📊 Analytics Framework**: Track conversion performance, file sizes, and optimization metrics
- **🔌 Plugin System**: Extensible architecture for custom video processing workflows
- **🎨 Video Filters**: Apply deinterlacing, denoising, scaling, and color correction
- **📄 Configuration Management**: Save and load workflow preferences for consistent results

### 🎨 **User Experience**
- **💫 Interactive CLI**: Beautiful, intuitive prompts with real-time feedback
- **⚡ Progress Tracking**: Animated progress bars with ETA and speed metrics
- **🎨 Professional Interface**: Color-coded output with icons and visual hierarchy
- **🔄 Smart Defaults**: Optimal settings chosen automatically based on your content
- **🌍 Cross-Platform**: Works seamlessly on Linux, macOS, and Windows (WSL)

---

## 📋 Installation

### Automatic Installation

```bash
git clone https://github.com/samonide/vyn.git
cd vyn
./install-vyn.sh
```

The installer automatically:
- ✅ Detects your system and package manager
- ✅ Installs FFmpeg and jq dependencies
- ✅ Configures PATH for global access
- ✅ Validates installation

### Manual Installation

**Install Dependencies:**
```bash
# Arch Linux / CachyOS
sudo pacman -S ffmpeg jq

# Ubuntu / Debian  
sudo apt install ffmpeg jq

# Fedora
sudo dnf install ffmpeg jq

# macOS
brew install ffmpeg jq
```

**Install Vyn:**
```bash
chmod +x vyn
sudo ln -sf "$(pwd)/vyn" /usr/local/bin/vyn
```

---

## 🎯 Usage

### Basic Conversion
```bash
# Interactive mode - Vyn guides you through options
vyn input.mkv output.mp4

# Automatic mode - Quick conversion with smart defaults  
vyn movie.avi movie.mp4
```

### Professional Workflows

```bash
# Cinema-quality conversion with BT.709 colorspace
vyn --preset cinema input.mov output.mp4

# Broadcast-ready with deinterlacing
vyn --preset broadcast source.ts output.mp4

# Web-optimized streaming format
vyn --preset web video.mkv video.webm

# Mobile-optimized with 720p scaling
vyn --preset mobile large_video.avi mobile.mp4

# Archive-quality preservation
vyn --preset archive original.mov archive.mkv

# Social media square format
vyn --preset social landscape.mp4 square.mp4
```

### Batch Operations
```bash
# Convert entire directories
vyn --batch

# GPU-accelerated batch processing
vyn --batch --gpu

# Batch with professional preset
vyn --batch --preset web
```

### Advanced Features
```bash
# Extract audio only
vyn --audio-only movie.mp4 soundtrack.mp3

# Apply video filters
vyn --filters deinterlace old_video.ts clean.mp4
vyn --filters "denoise,scale=1920:1080" input.avi output.mp4

# Enable analytics tracking
vyn --analytics --gpu movie.mkv output.mp4

# Use custom plugins
vyn --plugin example input.mp4 processed.mp4

# Preview operations (dry run)
vyn --dry-run --preset cinema input.mov output.mp4
```

### Utility Commands
```bash
# Show version and system info
vyn --version

# Display comprehensive help
vyn --help

# View analytics summary
vyn --show-analytics

# List available plugins
vyn --list-plugins

# Use custom configuration
vyn --config ~/my-settings.conf input.avi output.mp4
```

---

## 📊 Professional Presets

| Preset | CRF | Resolution | Use Case | Features |
|--------|-----|------------|----------|----------|
| **Broadcast** | 18 | Original | TV/Broadcasting | Deinterlacing, broadcast-ready |
| **Cinema** | 16 | Original | Film Industry | BT.709 colorspace, maximum quality |
| **Web** | 23 | 1080p | Streaming | Optimized for YouTube, Twitch |
| **Mobile** | 28 | 720p | Mobile Devices | Battery-efficient playback |
| **Archive** | 12 | Original | Long-term Storage | Near-lossless preservation |
| **Social Media** | 26 | 1080x1080 | Social Platforms | Square format for Instagram, TikTok |

---

## 🎨 Quality Guide

### CRF Values (Lower = Higher Quality)
```
🔥 Excellent (CRF 16-18): Archival, professional work
⭐ Great     (CRF 20-23): General use, streaming  
👍 Good      (CRF 24-28): Web, mobile devices
📱 Acceptable (CRF 29-32): Quick sharing, previews
```

### Mode Selection
- **🏃‍♂️ Remux**: Change container only (MKV → MP4) - seconds, no quality loss
- **🎯 Encode**: Full conversion with compression - minutes, size optimization
- **🗂️ Batch**: Process multiple files with consistent settings
- **🎵 Audio**: Extract audio tracks in any format

---

## 🔌 Plugin System

Vyn includes an extensible plugin architecture for custom processing:

```bash
# List available plugins
vyn --list-plugins

# Use a plugin
vyn --plugin example input.mp4 output.mp4

# Plugin directory
~/.config/vyn/plugins/
```

**Create Custom Plugin:**
```bash
# Plugin template at ~/.config/vyn/plugins/my-plugin.sh
#!/bin/bash
plugin_name="My Custom Plugin"
plugin_description="Custom video processing"

execute_plugin() {
    local input="$1"
    local output="$2"
    
    # Your custom FFmpeg processing here
    ffmpeg -i "$input" -vf "your_filter" "$output"
}
```

---

## 📊 Analytics & Tracking

Track conversion performance and optimize your workflows:

```bash
# Enable analytics for a conversion
vyn --analytics input.mkv output.mp4

# View analytics summary
vyn --show-analytics

# Analytics data location
~/.config/vyn/analytics.json
```

**Analytics Include:**
- ⏱️ Conversion time and speed
- 📊 File size comparisons
- 🎯 Compression ratios
- 🔧 Settings used
- 📈 Performance trends

---

## 🎚️ Supported Formats

### Input Formats
**Video**: MKV, MP4, AVI, MOV, WebM, FLV, WMV, M4V, 3GP, TS, VOB, MPG, MPEG  
**Audio**: MP3, FLAC, AAC, Opus, WAV, OGG, M4A

### Output Formats

| Format | Best For | Codecs |
|--------|----------|---------|
| **MP4** | Universal compatibility | H.264 + AAC |
| **MKV** | High quality, features | H.264/H.265 + AAC |
| **WebM** | Web streaming | VP9 + Opus |
| **AVI** | Legacy compatibility | H.264 + AAC |

---

## 🛠️ Advanced Usage

### Configuration Files
```bash
# Save current settings
vyn --save-config

# Use custom config
vyn --config ~/work-settings.conf input.avi output.mp4

# Config location
~/.config/vyn/config.conf
```

### Integration Examples
```bash
# Automated workflow
for video in *.mkv; do
    vyn --preset web --gpu "$video" "${video%.*}.mp4"
done

# Watch folder automation  
inotifywait -m ~/incoming -e create | while read dir action file; do
    vyn --preset mobile "$dir$file" ~/converted/"${file%.*}.mp4"
done

# Batch processing with specific settings
find /media/videos -name "*.avi" -exec vyn --preset cinema {} {}.mp4 \;
```

---

## 🔍 Troubleshooting

### Common Solutions

**"FFmpeg not found"**
```bash
# Install FFmpeg first
sudo pacman -S ffmpeg  # Arch/CachyOS
sudo apt install ffmpeg  # Ubuntu/Debian
brew install ffmpeg     # macOS
```

**"Permission denied"**
```bash
chmod +x vyn
```

**"GPU acceleration not available"**
- Install appropriate drivers (NVIDIA/AMD/Intel)
- Check GPU support: `ffmpeg -encoders | grep nvenc`
- GPU acceleration automatically falls back to CPU

**Performance Issues**
- Use `--gpu` for hardware acceleration
- Consider `--preset mobile` for faster encoding
- Ensure sufficient disk space and RAM
- Use SSD storage for better I/O performance

### Getting Help
```bash
# Comprehensive help
vyn --help

# System information
vyn --version  

# Check dependencies
ffmpeg -version && jq --version
```

---

## 📁 Project Structure

```
vyn/
├── 🎬 vyn                  # Main executable
├── ⚙️  install-vyn.sh       # Automatic installer
├── 📖 README.md            # This documentation
├── 📋 CHANGELOG.md         # Version history & roadmap
├── 📜 LICENSE              # Unlicense (Public Domain)
├── 🚫 .gitignore           # Git ignore patterns  
└── 📦 package.json         # Project metadata
```

---

## 🚀 What's New in v1.3.0

**🎯 Professional Workflow Integration**
- **Industry Presets**: Broadcast, Cinema, Web, Mobile, Archive, Social Media
- **Analytics Framework**: Performance tracking with JSON logging  
- **Plugin Architecture**: Extensible custom processing system
- **Video Filters**: Deinterlacing, denoising, scaling, color correction
- **Enhanced CLI**: New options for professional workflows

**🔧 Technical Improvements**
- **Configuration System**: Persistent settings and workflow management
- **Error Handling**: Robust validation and recovery mechanisms  
- **Performance**: Optimized processing and resource utilization
- **Documentation**: Comprehensive help system and examples

---

## 🗺️ Roadmap

### Upcoming Features
- **v1.4.0**: Cloud integration, AI-powered optimization, streaming protocols
- **v2.0.0**: Web interface, distributed processing, advanced analytics

See [CHANGELOG.md](CHANGELOG.md) for detailed roadmap and version history.

---

## 🤝 Contributing

Vyn is **public domain** - contribute freely without legal complexity!

### Ways to Contribute
- 🐛 **Report Bugs**: [Open an issue](https://github.com/samonide/vyn/issues)
- 💡 **Suggest Features**: [Feature requests welcome](https://github.com/samonide/vyn/issues)
- 🔧 **Submit Code**: [Pull requests](https://github.com/samonide/vyn/pulls)
- 📖 **Improve Docs**: Documentation improvements
- 🌟 **Spread the Word**: Share with fellow creators

### Development Setup
```bash
git clone https://github.com/samonide/vyn.git
cd vyn
chmod +x vyn install-vyn.sh

# Test your changes
./vyn --version
./vyn --help
```

---

## 📄 License

**Public Domain** - [Unlicense](https://unlicense.org/)

This means you can:
- ✅ Use commercially
- ✅ Modify freely  
- ✅ Distribute without restrictions
- ✅ Use in proprietary software
- ✅ No attribution required (but appreciated!)

---

## 🙏 Acknowledgments

- **[FFmpeg Team](https://ffmpeg.org/)** - Incredible video processing engine
- **[jq Authors](https://jqlang.github.io/jq/)** - JSON processing excellence  
- **Community Contributors** - Testing, feedback, and improvements
- **Video Creators Worldwide** - Inspiration and real-world use cases

---

## 📊 Project Stats

- **Language**: Bash Shell Script
- **Core Engine**: FFmpeg  
- **Dependencies**: FFmpeg (required), jq (optional)
- **Platforms**: Linux, macOS, Windows (WSL)
- **License**: Unlicense (Public Domain)
- **Size**: ~2000+ lines of refined code

---

<div align="center">

**Made with ❤️ for the video creation community**

[🌟 Star on GitHub](https://github.com/samonide/vyn) • [🐛 Report Issue](https://github.com/samonide/vyn/issues) • [💡 Request Feature](https://github.com/samonide/vyn/issues) • [🤝 Contribute](https://github.com/samonide/vyn/pulls)

---

*"Making professional video conversion as simple as it should be"*

</div>