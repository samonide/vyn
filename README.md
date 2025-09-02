# 🎬 Vyn

**Vyn — Video. Simplified.**

[![License: Unlicense](https://img.shields.io/badge/license-Unlicense-blue.svg)](http://unlicense.org/)
[![Shell Script](https://img.shields.io/badge/Shell-Bash-green.svg)](https://www.gnu.org/software/bash/)
[![FFmpeg](https://img.shields.io/badge/Powered%20by-FFmpeg-orange.svg)](https://ffmpeg.org/)
[![Version](https://img.shields.io/badge/version-1.0.0-brightgreen.svg)](https://github.com/samonide/vyn/releases)
[![Platform](https://img.shields.io/badge/platform-Linux%20%7C%20macOS%20%7C%20Windows-lightgrey.svg)]()
[![Made by](https://img.shields.io/badge/made%20by-samonide-red.svg)](https://github.com/samonide)

A powerful, fast, and intuitive video format converter built with FFmpeg. Convert videos with just a few keystrokes using an interactive CLI that makes video conversion simple and enjoyable.

> 🚀 **One command, infinite possibilities**: `vyn input.mkv output.mp4`

## ⚡ Quick Start

```bash
# Install Vyn
git clone https://github.com/samonide/vyn.git && cd vyn && ./install-vyn.sh

# Convert a video (interactive mode)
vyn movie.mkv movie.mp4

# That's it! Vyn guides you through the rest.
```

## ✨ Features

- **🚀 Two Operation Modes:**
  - **Remux**: Lightning-fast container format changes (no re-encoding)
  - **Encode**: Full conversion with quality control and size optimization
- **🎯 Interactive CLI**: User-friendly prompts for all conversion options
- **📊 Quality Control**: Multiple presets (High, Good, Medium, Low) plus custom CRF values
- **📁 Wide Format Support**: MP4, MKV, WebM, AVI, MOV, and many more
- **🌍 Cross-Platform**: Works on Linux, macOS, and Windows (with WSL)
- **📈 Progress Tracking**: Real-time conversion progress and detailed summaries
- **🎨 Colored Output**: Beautiful, readable terminal interface
- **⚡ Smart Codec Detection**: Automatically selects optimal codecs for each format

## 📁 Project Structure

```
vyn/
├── 📄 vyn                  # Main executable - the heart of video conversion
├── ⚙️  install-vyn.sh       # Smart installer with multiple installation options  
├── 📖 README.md            # This comprehensive guide
├── 📋 CHANGELOG.md         # Version history and future roadmap
├── 📜 LICENSE              # Unlicense - public domain freedom
├── 🚫 .gitignore           # Git ignore patterns
└── 📦 package.json         # Project metadata and configuration
```

## 🎯 Why Choose Vyn?

### **Simplicity First**
- **3-letter command**: `vyn` vs lengthy alternatives
- **Interactive prompts**: No need to memorize complex FFmpeg parameters
- **Smart defaults**: Optimal settings chosen automatically

### **Power When Needed**
- **Professional quality**: Same engine used by major video platforms
- **Full control**: Custom CRF values and advanced options available
- **Format flexibility**: Support for virtually any video format

### **Developer Friendly**
- **Public domain**: Use, modify, distribute freely
- **Cross-platform**: Works everywhere FFmpeg does
- **Extensible**: Clean codebase ready for contributions

## 📋 Requirements

### Required
- **FFmpeg** - The core video processing engine

### Optional
- **jq** - Provides enhanced file information display

## 🔧 Installation

### Quick Install

1. **Clone the repository:**
   ```bash
   git clone https://github.com/samonide/vyn.git
   cd vyn
   ```

2. **Run the installation script:**
   ```bash
   ./install-vyn.sh
   ```

3. **Choose your preferred installation method:**
   - **Global** (`/usr/local/bin`) - requires sudo, works everywhere
   - **User** (`~/.local/bin`) - no sudo needed, user-specific
   - **PATH addition** - uses current directory

### Manual Installation

1. **Install dependencies:**

   **Arch Linux / CachyOS:**
   ```bash
   sudo pacman -S ffmpeg jq
   ```

   **Ubuntu / Debian:**
   ```bash
   sudo apt install ffmpeg jq
   ```

   **Fedora:**
   ```bash
   sudo dnf install ffmpeg jq
   ```

   **macOS:**
   ```bash
   brew install ffmpeg jq
   ```

2. **Make script executable:**
   ```bash
   chmod +x vyn
   ```

3. **Create global symlink (optional):**
   ```bash
   sudo ln -sf "$(pwd)/vyn" /usr/local/bin/vyn
   ```

## 🚀 Usage

### The Vyn Way: Simple & Intuitive

```bash
# Basic conversion - Vyn does the thinking for you
vyn input.mkv output.mp4

# Just specify input - Vyn will ask for output
vyn /path/to/large_video.avi

# Quick help when you need it
vyn --help

# Check your setup
vyn --version
```

### Advanced Options

```bash
# Silent mode for scripts
vyn --no-color input.mov output.mp4

# Pro tip: Vyn remembers your preferences during the session
```

### Interactive Workflow

1. **File Analysis**: Displays detailed information about your input file
2. **Mode Selection**: Choose between Remux (fast) or Encode (quality)
3. **Quality Settings**: Select from presets or set custom CRF value
4. **Confirmation**: Review all settings before conversion
5. **Progress Tracking**: Monitor conversion progress in real-time
6. **Summary**: View file size changes and conversion statistics

## 📊 Quality Guide

### Understanding CRF Values
The Constant Rate Factor (CRF) controls video quality vs file size:

| CRF | Quality | Use Case | File Size |
|-----|---------|----------|-----------|
| 18  | 🔥 **Excellent** | Archival, professional work | Very Large |
| 23  | ⭐ **Good** | General use, streaming | Balanced |
| 28  | 👍 **Medium** | Web, mobile devices | Smaller |
| 32  | 📱 **Low** | Quick sharing, previews | Very Small |

### When to Use Each Mode

#### 🏃‍♂️ Remux Mode (Fast)
- Changing container format only (MKV → MP4)
- No quality loss needed
- Maximum speed required (seconds vs minutes)
- Preserving original encoding

#### 🎯 Encode Mode (Quality)
- Reducing file size significantly
- Changing video codec or settings
- Optimizing for specific devices/platforms
- Converting legacy formats

## 🎯 Format Support

### Input Formats
- **Video**: MKV, MP4, AVI, MOV, WebM, FLV, WMV, M4V, 3GP, TS, VOB
- **Audio**: All audio formats supported by FFmpeg

### Output Formats & Codecs

| Format | Video Codec | Audio Codec | Best For |
|--------|-------------|-------------|----------|
| **MP4** | H.264 | AAC | Universal compatibility, mobile devices |
| **MKV** | H.264 | AAC | High quality, large files, PC playback |
| **WebM** | VP9 | Opus | Web streaming, modern browsers |
| **AVI** | H.264 | AAC | Legacy compatibility |

## 📖 Real-World Examples

### 🎬 Content Creator Workflow
```bash
# Quick upload prep: Large MKV → Optimized MP4
vyn raw_recording.mkv youtube_upload.mp4
# Choose: Encode → Good Quality (CRF 23)
# Result: 60% smaller file, upload-ready
```

### 📱 Mobile-First Conversion
```bash
# Heavy desktop video → Mobile-friendly
vyn desktop_capture.avi mobile_share.mp4
# Choose: Encode → Medium Quality (CRF 28)
# Result: Perfect for WhatsApp, social media
```

### 🌐 Web Optimization
```bash
# Any format → Web-optimized WebM
vyn source_video.mov website_embed.webm
# Choose: Encode → Good Quality (CRF 23)
# Result: VP9/Opus, perfect for modern browsers
```

### ⚡ Lightning-Fast Container Swap
```bash
# MKV → MP4 in seconds (no re-encoding)
vyn movie.mkv movie.mp4
# Choose: Remux
# Result: Same quality, compatible format, 10x faster
```

### 🎯 Professional Archive
```bash
# Preserve maximum quality for archival
vyn original_footage.avi archive_master.mkv
# Choose: Encode → High Quality (CRF 18)
# Result: Near-lossless quality in efficient container
```

## 🛠️ Power User Features

### Batch Processing (Current Workaround)
```bash
# Convert entire directory
for file in *.mkv; do
    echo "Converting: $file"
    vyn "$file" "${file%.mkv}.mp4"
done

# Convert with specific pattern
find . -name "*.avi" -exec vyn {} {}.mp4 \;
```

### Integration with Other Tools
```bash
# Use with find for complex filtering
find /videos -name "*.mov" -size +100M | while read file; do
    vyn "$file" "${file%.*}_compressed.mp4"
done

# Combine with rsync for backup workflow
vyn original.mkv compressed.mp4 && rsync compressed.mp4 backup_server:/videos/
```

### Script Integration
```bash
#!/bin/bash
# Automated video processing script
for input in "$@"; do
    output="${input%.*}_processed.mp4"
    echo "Processing: $input → $output"
    vyn "$input" "$output"
done
```

## 🔍 Troubleshooting

### Common Issues

**"FFmpeg not found"**
```bash
# Install FFmpeg first
sudo pacman -S ffmpeg  # Arch/CachyOS
sudo apt install ffmpeg  # Ubuntu/Debian
```

**"Permission denied"**
```bash
chmod +x vyn
```

**"Command not found"**
- Ensure installation completed successfully
- Restart terminal after PATH changes
- Verify installation: `which vyn`

**"Encoding failed"**
- Check input file integrity
- Ensure sufficient disk space
- Try remux mode first to test file validity

### Performance Tips

1. **SSD Storage**: Store files on SSD for faster I/O
2. **CPU Considerations**: Encoding is CPU-intensive
3. **Memory**: Ensure sufficient RAM for large files
4. **Disk Space**: Output files can be larger than input

## 📋 TODO - Future Plans

### 🔥 Upcoming Features (v1.1.0)
- [ ] **Batch Processing Mode** - Convert multiple files with one command
- [ ] **Configuration File** - Save preferred settings (quality, format, etc.)
- [ ] **Progress Bar** - Visual progress indicator during conversion
- [ ] **GPU Acceleration** - NVENC/VAAPI support for faster encoding
- [ ] **Audio-only Mode** - Extract and convert audio tracks separately

### 🚀 Advanced Features (v1.2.0)
- [ ] **Subtitle Handling** - Preserve, extract, or burn-in subtitles
- [ ] **Video Filters** - Basic filters (resize, crop, rotate)
- [ ] **Preset Management** - Create and save custom encoding presets
- [ ] **Resume Support** - Resume interrupted conversions
- [ ] **Queue System** - Add multiple files to conversion queue

### 🎯 Long-term Goals (v2.0.0)
- [ ] **Web Interface** - Optional web-based GUI for remote usage
- [ ] **Streaming Output** - Direct upload to cloud services
- [ ] **Auto-optimization** - AI-powered quality/size optimization
- [ ] **Plugin System** - Custom filters and codecs
- [ ] **Distributed Processing** - Multi-machine encoding support

### 🔧 Technical Improvements
- [ ] **Unit Tests** - Comprehensive testing suite
- [ ] **Performance Profiling** - Optimize bottlenecks
- [ ] **Error Recovery** - Better handling of corrupted files
- [ ] **Logging System** - Detailed conversion logs
- [ ] **Docker Support** - Containerized deployment

*Have a feature request? [Open an issue](https://github.com/samonide/vyn/issues) and let's discuss!*

## 🤝 Join the Community

**Vyn is public domain** - which means it belongs to everyone! Here's how you can help make video conversion even better:

### 🐛 Found a Bug?
[Open an issue](https://github.com/samonide/vyn/issues) with:
- Your operating system
- FFmpeg version (`ffmpeg -version`)
- What you expected vs what happened
- Steps to reproduce

### 💡 Have an Idea?
We love feature requests! Check our [TODO list](#-todo---future-plans) and suggest new ideas.

### 🚀 Want to Contribute Code?
1. Fork the repo
2. Make your changes
3. Test on multiple platforms
4. Submit a pull request

**No complex legal stuff** - since it's public domain, your contributions are immediately free for everyone!

### 🌟 Spread the Word
- Star the repository
- Share with fellow creators
- Write about Vyn in your blog/social media

### Development Setup
```bash
git clone https://github.com/samonide/vyn.git
cd vyn
chmod +x vyn install-vyn.sh

# Test your changes
./vyn --help
./vyn --version
```

## 📄 License

This project is released into the **public domain** under the [Unlicense](https://unlicense.org/). You can do whatever you want with it!

## 🙏 Acknowledgments

- **FFmpeg Team** - For the amazing video processing library
- **Community Contributors** - For testing and feedback
- **Shell Scripting Community** - For best practices and techniques

## 📊 Project Info

- **Language**: Bash Shell Script
- **Core Engine**: FFmpeg
- **Dependencies**: FFmpeg (required), jq (optional)
- **Platforms**: Linux, macOS, Windows (WSL)
- **License**: Unlicense (Public Domain)
- **Lines of Code**: ~500+

---

<div align="center">

**Vyn — Video. Simplified.**

Made with ❤️ by [samonide](https://github.com/samonide) | Public Domain Software

[🐛 Report Bug](https://github.com/samonide/vyn/issues) • [💡 Request Feature](https://github.com/samonide/vyn/issues) • [🤝 Contribute](https://github.com/samonide/vyn/pulls) • [⭐ Star on GitHub](https://github.com/samonide/vyn)

*"Making video conversion as simple as it should be"*

</div>
