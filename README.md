<div align="center">

# 🎬 Vyn

**Professional Video Converter for the Command Line**

[![License: Unlicense](https://img.shields.io/badge/license-Unlicense-blue.svg)](http://unlicense.org/)
[![Shell Script](https://img.shields.io/badge/Shell-Bash-green.svg)](https://www.gnu.org/software/bash/)
[![FFmpeg](https://img.shields.io/badge/Powered%20by-FFmpeg-orange.svg)](https://ffmpeg.org/)
[![Version](https://img.shields.io/badge/version-1.4.0-brightgreen.svg)](https://github.com/samonide/vyn/releases)

*Fast, intuitive video conversion powered by FFmpeg with professional presets and plugin support*

[📖 Documentation](docs/Usage.md) • [🚀 Quick Start](#-quick-start) • [🔌 Plugins](docs/Plugins.md) • [📋 Changelog](CHANGELOG.md)

</div>

---

## ✨ Features

- **⚡ Dual Modes** - Remux (instant container swap) or Encode (quality-optimized conversion)
- **🎯 Professional Presets** - Broadcast, Cinema, Web, Mobile, Archive, Social Media
- **🗂️ Batch Processing** - Convert entire directories with consistent settings
- **🎮 GPU Acceleration** - NVENC, VAAPI, QuickSync hardware encoding
- **🔌 Plugin System** - Extensible architecture for uploads and custom workflows
- **📊 Analytics** - Track performance, file sizes, and optimization metrics
- **🎨 Filters & Effects** - Deinterlacing, denoising, scaling, color correction
- **🎵 Audio Extraction** - Extract audio in MP3, FLAC, AAC, Opus formats

## 🚀 Quick Start

### Installation

```bash
# One-command installation
sh -c "$(curl -fsSL https://raw.githubusercontent.com/samonide/vyn/main/install-vyn.sh)"

# Or manual installation
git clone https://github.com/samonide/vyn.git && cd vyn && ./install-vyn.sh
```

### Basic Usage

```bash
# Interactive mode - guided conversion
vyn input.mkv output.mp4

# Professional preset
vyn --preset cinema movie.mov movie.mp4

# Batch convert directory
vyn --batch /path/to/videos/

# GPU-accelerated encoding
vyn --gpu input.avi output.mp4

# Extract audio
vyn --audio-only video.mp4 audio.mp3
```

### Professional Presets

| Preset | CRF | Resolution | Best For |
|--------|-----|------------|----------|
| `broadcast` | 18 | Original | TV/Broadcasting |
| `cinema` | 16 | Original | Film Industry |
| `web` | 23 | 1080p | YouTube, Streaming |
| `mobile` | 28 | 720p | Mobile Devices |
| `archive` | 12 | Original | Preservation |
| `social` | 26 | 1080x1080 | Instagram, TikTok |

```bash
# Use presets
vyn --preset web input.mov output.mp4
vyn --preset mobile --gpu video.avi mobile.mp4
```

## 📖 Documentation

- **[Usage Guide](docs/Usage.md)** - Complete documentation with examples
- **[Plugin System](docs/Plugins.md)** - Plugin development and management
- **[Contributing](docs/Contributing.md)** - How to contribute to Vyn
- **[Development Roadmap](ROADMAP.md)** - Project development plan
- **[Quick Start Dev](QUICKSTART-DEV.md)** - Start developing immediately
- **[Changelog](CHANGELOG.md)** - Version history and roadmap

## 🔌 Quick Plugin Usage

```bash
# List available plugins
vyn --list-plugins

# Install plugins
vyn --add-plugins

# Use a plugin (e.g., Vimeo uploader)
vyn --plugin vimeo-uploader /path/to/videos/
```

## 🛠️ Requirements

- **FFmpeg** (required) - Video processing engine
- **jq** (optional) - JSON processing for plugins
- **Bash 4.0+** - Shell environment

## 📋 Common Commands

```bash
# Help and information
vyn --help              # Show all options
vyn --version           # Show version info

# Quality modes
vyn --preset cinema     # Professional presets
vyn --gpu               # Enable GPU acceleration
vyn --analytics         # Track performance metrics

# Batch operations
vyn --batch             # Convert directory
vyn --batch --preset web  # Batch with preset

# Advanced features
vyn --filters denoise   # Apply video filters
vyn --show-analytics    # View performance data
vyn --config file.conf  # Use custom config
```

## 🎨 Supported Formats

**Input**: MKV, MP4, AVI, MOV, WebM, FLV, WMV, M4V, 3GP, TS, VOB, MPG  
**Output**: MP4, MKV, WebM, AVI  
**Audio**: MP3, FLAC, AAC, Opus, WAV, OGG, M4A

## 📊 Project Structure

```
vyn/
├── bin/            # Main executable
├── src/            # Source modules
├── plugins/        # Plugin repository
├── docs/           # Documentation
├── config/         # Configuration templates
├── tests/          # Test suite
└── install-vyn.sh  # Installer script
```

## 📄 License

**Public Domain** - [Unlicense](https://unlicense.org/)  
Use, modify, and distribute freely without restrictions.

## 🙏 Acknowledgments

Built with [FFmpeg](https://ffmpeg.org/) • JSON processing by [jq](https://jqlang.github.io/jq/)

---

<div align="center">

**[⭐ Star on GitHub](https://github.com/samonide/vyn)** • **[🐛 Report Issues](https://github.com/samonide/vyn/issues)** • **[🤝 Contribute](docs/Contributing.md)**

*Making professional video conversion simple and powerful*

</div>
