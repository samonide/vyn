# 🎬 Vyn

**Vyn — Video. Simplified.**

[![License: Unlicense](https://img.shields.io/badge/license-Unlicense-blue.svg)](http://unlicense.org/)
[![Shell Script](https://img.shields.io/badge/Shell-Bash-green.svg)](https://www.gnu.org/software/bash/)
[![FFmpeg](https://img.shields.io/badge/Powered%20by-FFmpeg-orange.svg)](https://ffmpeg.org/)
[![Version](https://img.shields.io/badge/version-1.1.0-brightgreen.svg)](https://github.com/samonide/vyn/releases)
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
- **🗂️ Batch Processing**: Convert multiple files at once with intelligent directory scanning
- **🎵 Audio-Only Mode**: Extract audio tracks with support for MP3, AAC, FLAC, Opus, and more
- **� GPU Acceleration**: Hardware-accelerated encoding with NVENC, VAAPI, and QuickSync support
- **📄 Configuration Management**: Save and load preferences for consistent workflows
- **�🎯 Interactive CLI**: User-friendly prompts for all conversion options
- **🔍 Dry Run Mode**: Preview operations safely without modifying files
- **⚡ Animated Progress Bars**: Beautiful real-time progress indicators during conversion
- **📊 Quality Control**: Multiple presets (High, Good, Medium, Low) plus custom CRF values
- **📁 Wide Format Support**: MP4, MKV, WebM, AVI, MOV, FLV, 3GP, and many more
- **🌍 Cross-Platform**: Works on Linux, macOS, and Windows (with WSL)
- **📈 Advanced Analytics**: File size comparisons, compression ratios, and timing information
- **🎨 Professional Interface**: Beautiful, color-coded terminal output with icons
- **⚡ Smart Features**: Auto-directory creation, format validation, and intelligent codec selection
- **🛡️ Robust Error Handling**: Better validation and recovery from edge cases

## 🆕 What's New in v1.1.0

**🚀 Major Productivity Features:**
- **🗂️ Batch Processing**: Process entire directories with `vyn --batch` for maximum efficiency
- **🎮 GPU Acceleration**: Hardware-accelerated encoding with `--gpu` for 3-5x faster conversion
- **🎵 Audio-Only Mode**: Extract audio with `--audio-only` supporting MP3, FLAC, AAC, Opus, and more
- **� Configuration Management**: Save preferences with `--save-config` and load with `--config`

**🎯 Enhanced Performance:**
- **NVIDIA NVENC**: Hardware H.264/H.265 encoding for GeForce and Quadro cards
- **AMD/Intel VAAPI**: Linux hardware acceleration for AMD and Intel graphics
- **Intel QuickSync**: Optimized encoding for Intel integrated graphics
- **Smart Fallback**: Automatic CPU fallback when GPU acceleration isn't available

**💡 Workflow Improvements:**
- **Intelligent Directory Scanning**: Batch mode finds all video files automatically
- **Format-Specific Optimization**: GPU codecs tailored for different output formats
- **Enhanced Progress Display**: Better visual feedback for batch operations
- **Configuration Persistence**: Remember your preferred settings across sessions

> 🚀 **Try it now**: `vyn --batch` to convert entire directories or `vyn --gpu input.mkv output.mp4` for lightning-fast encoding!

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
# Batch convert entire directory
vyn --batch

# GPU-accelerated conversion
vyn --gpu input.mkv output.mp4

# Extract audio only
vyn --audio-only movie.mp4 soundtrack.mp3

# Use custom configuration
vyn --config ~/my-vyn-config.conf input.avi output.webm

# Save current settings
vyn --save-config --gpu input.mov output.mp4

# Silent mode for scripts
vyn --no-color input.mov output.mp4

# Pro tip: Combine options for powerful workflows
vyn --batch --gpu --save-config
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

#### 🗂️ Batch Mode (Productivity)
- Converting multiple files at once
- Consistent settings across all files
- Directory-wide format standardization
- Automated workflow processing

#### 🎵 Audio-Only Mode (Extraction)
- Extracting soundtracks from videos
- Converting between audio formats
- Creating podcast episodes from video
- Reducing file sizes for audio-only content

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

### 🗂️ Batch Processing Workflow
```bash
# Convert entire video collection to MP4
vyn --batch
# 1. Select input directory: ~/Videos/Raw
# 2. Select output directory: ~/Videos/Converted  
# 3. Choose format: MP4
# 4. Select mode: Encode + Good Quality
# Result: All videos converted consistently

# GPU-accelerated batch processing
vyn --batch --gpu
# Same as above but 3-5x faster with hardware acceleration
```

### 🎵 Audio Extraction Workflow
```bash
# Extract high-quality audio from video
vyn --audio-only concert.mkv audio.flac
# Choose: Extract → FLAC (lossless)
# Result: Perfect quality audio file

# Create MP3 for mobile devices
vyn --audio-only podcast.mp4 episode.mp3
# Choose: Extract → MP3 (320kbps)
# Result: Compressed audio for easy sharing
```

### 🎮 GPU Acceleration Workflow
```bash
# High-speed conversion with NVIDIA GPU
vyn --gpu large_video.mov optimized.mp4
# Choose: Encode → Good Quality (hardware accelerated)
# Result: 3-5x faster than CPU-only encoding

# Batch GPU processing for maximum throughput
vyn --batch --gpu
# Process entire directories with hardware acceleration
# Result: Professional-grade speed for large workflows
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

### Batch Processing (Current Feature!)
```bash
# Convert entire directory
vyn --batch

# GPU-accelerated batch processing
vyn --batch --gpu

# Custom configuration for consistent results
vyn --batch --config ~/video-workflow.conf
```

### Audio-Only Processing
```bash
# Extract audio in various formats
vyn --audio-only movie.mp4 soundtrack.mp3
vyn --audio-only concert.mkv audio.flac
vyn --audio-only podcast.mp4 episode.aac

# Batch audio extraction
vyn --batch --audio-only
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
# Automated video processing script with GPU acceleration
for input in "$@"; do
    output="${input%.*}_processed.mp4"
    echo "Processing: $input → $output"
    vyn --gpu "$input" "$output"
done

# Batch processing with saved configuration
vyn --batch --config ~/production-settings.conf
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

**"GPU acceleration not available"**
- Your system doesn't support hardware acceleration
- Install appropriate drivers (NVIDIA/AMD/Intel)
- GPU acceleration will fall back to CPU automatically

**"Batch processing failed"**
- Check input directory permissions
- Ensure output directory is writable
- Verify video files are valid

**"Configuration file error"**
- Check config file syntax
- Use `--save-config` to generate a valid config
- Verify file permissions

### Performance Tips

1. **GPU Acceleration**: Use `--gpu` for 3-5x faster encoding when available
2. **Batch Processing**: Use `--batch` for efficient multi-file workflows
3. **SSD Storage**: Store files on SSD for faster I/O
4. **CPU Considerations**: Encoding is CPU-intensive (fallback when no GPU)
5. **Memory**: Ensure sufficient RAM for large files
6. **Disk Space**: Output files can be larger than input
7. **Configuration**: Save settings with `--save-config` for consistent results

## � Troubleshooting

## 🤝 Join the Community

**Vyn is public domain** - which means it belongs to everyone! Here's how you can help make video conversion even better:

### 🐛 Found a Bug?
[Open an issue](https://github.com/samonide/vyn/issues) with:
- Your operating system
- FFmpeg version (`ffmpeg -version`)
- What you expected vs what happened
- Steps to reproduce

### 💡 Have an Idea?
We love feature requests! Check our [comprehensive roadmap in CHANGELOG.md](CHANGELOG.md#planned-future-versions) to see what's planned and suggest new ideas.

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
