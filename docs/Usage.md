# Vyn Usage Guide

Complete documentation for Vyn video converter.

## Table of Contents

- [Installation](#installation)
- [Basic Usage](#basic-usage)
- [Professional Presets](#professional-presets)
- [Advanced Features](#advanced-features)
- [Batch Processing](#batch-processing)
- [GPU Acceleration](#gpu-acceleration)
- [Audio Extraction](#audio-extraction)
- [Plugins](#plugins)
- [Configuration](#configuration)
- [Analytics](#analytics)
- [Video Filters](#video-filters)
- [Supported Formats](#supported-formats)
- [Troubleshooting](#troubleshooting)
- [Integration Examples](#integration-examples)

---

## Installation

### Automatic Installation

```bash
# One-command installation
sh -c "$(curl -fsSL https://raw.githubusercontent.com/samonide/vyn/main/install-vyn.sh)"

# Or clone and install
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

# Windows (WSL)
sudo apt install ffmpeg jq
```

**Install Vyn:**

```bash
chmod +x bin/vyn
sudo ln -sf "$(pwd)/bin/vyn" /usr/local/bin/vyn
```

### Verify Installation

```bash
vyn --version
ffmpeg -version
jq --version
```

---

## Basic Usage

### Interactive Mode

Interactive mode guides you through conversion options:

```bash
vyn input.mkv output.mp4
```

The interactive prompt will ask:
1. Operation mode (Remux or Encode)
2. Quality settings (if encoding)
3. Audio preferences
4. GPU acceleration
5. Additional options

### Automatic Mode

Quick conversion with smart defaults:

```bash
# Simple format conversion
vyn movie.avi movie.mp4

# Automatically detects best settings
vyn video.mkv video.webm
```

### Command Line Options

```bash
# Show all available options
vyn --help

# Display version information
vyn --version

# Dry run (preview without executing)
vyn --dry-run input.mkv output.mp4
```

---

## Professional Presets

Vyn includes industry-standard presets for common workflows.

### Available Presets

| Preset | CRF | Resolution | Bitrate | Use Case | Features |
|--------|-----|------------|---------|----------|----------|
| **broadcast** | 18 | Original | High | TV/Broadcasting | Deinterlacing, broadcast-ready |
| **cinema** | 16 | Original | Very High | Film Industry | BT.709 colorspace, maximum quality |
| **web** | 23 | 1080p | Medium | Streaming | Optimized for YouTube, Twitch |
| **mobile** | 28 | 720p | Low | Mobile Devices | Battery-efficient playback |
| **archive** | 12 | Original | Very High | Long-term Storage | Near-lossless preservation |
| **social** | 26 | 1080x1080 | Medium | Social Platforms | Square format for Instagram, TikTok |

### Using Presets

```bash
# Cinema-quality conversion
vyn --preset cinema input.mov output.mp4

# Web-optimized for streaming
vyn --preset web video.mkv video.mp4

# Mobile-friendly conversion
vyn --preset mobile large_video.avi mobile.mp4

# Archive with maximum quality
vyn --preset archive original.mov archive.mkv

# Social media square format
vyn --preset social landscape.mp4 square.mp4

# Broadcast with deinterlacing
vyn --preset broadcast source.ts output.mp4
```

### Combining with Other Options

```bash
# Preset with GPU acceleration
vyn --preset web --gpu input.avi output.mp4

# Preset with batch processing
vyn --batch --preset mobile /path/to/videos/

# Preset with analytics
vyn --preset cinema --analytics movie.mkv output.mp4

# Preset with filters
vyn --preset web --filters denoise input.mp4 output.mp4
```

---

## Advanced Features

### Quality Control

#### CRF Values (Constant Rate Factor)

Lower CRF = Higher Quality = Larger File Size

```bash
🔥 Excellent (12-16): Archival, professional work
⭐ Great     (18-23): General use, streaming
👍 Good      (24-28): Web, mobile devices
📱 Acceptable (29-32): Quick sharing, previews
```

#### Custom Quality Settings

```bash
# High quality encode
vyn --encode --crf 18 input.mkv output.mp4

# Balanced quality and size
vyn --encode --crf 23 input.mkv output.mp4

# Smaller file size
vyn --encode --crf 28 input.mkv output.mp4
```

### Operation Modes

#### Remux Mode

Change container only (no re-encoding):
- ⚡ **Speed**: Seconds (vs minutes for encoding)
- 💎 **Quality**: No quality loss
- 📦 **Use Case**: Format compatibility (MKV → MP4)

```bash
# Fast remux (container only)
vyn --remux input.mkv output.mp4

# Remux with audio copy
vyn --remux movie.mkv movie.mp4
```

#### Encode Mode

Full re-encoding with compression:
- 🎯 **Control**: Adjust quality and file size
- 📉 **Size**: Optimize file size
- 🔧 **Use Case**: Compression, format conversion

```bash
# Standard encode
vyn --encode input.avi output.mp4

# Encode with quality setting
vyn --encode --crf 20 input.avi output.mp4
```

---

## Batch Processing

Convert multiple files with consistent settings.

### Basic Batch Operations

```bash
# Interactive batch mode
vyn --batch

# Specify input directory
vyn --batch /path/to/videos/

# Specify output directory
vyn --batch --output /path/to/output/

# Specify output format
vyn --batch --format mp4
```

### Batch with Presets

```bash
# Convert all videos with web preset
vyn --batch --preset web /path/to/videos/

# Mobile optimization for entire directory
vyn --batch --preset mobile --gpu /videos/

# Archive entire collection
vyn --batch --preset archive /media/originals/
```

### Advanced Batch Options

```bash
# Batch with GPU acceleration
vyn --batch --gpu /path/to/videos/

# Batch with custom quality
vyn --batch --encode --crf 20 /videos/

# Batch with analytics tracking
vyn --batch --analytics --preset web /videos/

# Batch with filters
vyn --batch --filters denoise /path/to/videos/
```

### Batch File Selection

Vyn automatically processes these video formats:
- MKV, MP4, AVI, MOV, WebM, FLV, WMV
- M4V, 3GP, TS, VOB, MPG, MPEG

```bash
# Process only specific format
find /videos -name "*.mkv" -exec vyn --preset web {} {}.mp4 \;

# Process with file patterns
for video in /videos/*.avi; do
    vyn --preset mobile "$video" "${video%.avi}.mp4"
done
```

---

## GPU Acceleration

Hardware-accelerated encoding for faster processing.

### Supported GPU Types

- **NVENC** - NVIDIA GPUs (GeForce, Quadro, Tesla)
- **VAAPI** - AMD and Intel GPUs (Linux)
- **QuickSync** - Intel integrated graphics

### Detecting GPU Support

```bash
# Check available encoders
ffmpeg -encoders | grep nvenc    # NVIDIA
ffmpeg -encoders | grep vaapi    # AMD/Intel
ffmpeg -encoders | grep qsv      # QuickSync

# Vyn auto-detection
vyn --gpu --version
```

### Using GPU Acceleration

```bash
# Enable GPU acceleration
vyn --gpu input.mkv output.mp4

# GPU with preset
vyn --preset web --gpu video.avi video.mp4

# GPU batch processing
vyn --batch --gpu /path/to/videos/

# GPU with specific quality
vyn --gpu --crf 23 input.mkv output.mp4
```

### GPU Performance Tips

- GPU encoding is 3-5x faster than CPU
- Slightly larger file sizes vs CPU encoding
- Best for batch processing and large files
- Falls back to CPU if GPU unavailable

---

## Audio Extraction

Extract audio tracks in any format.

### Basic Audio Extraction

```bash
# Extract audio (interactive format selection)
vyn --audio-only video.mp4 audio

# Specify audio format
vyn --audio-only movie.mkv soundtrack.mp3
vyn --audio-only video.mp4 audio.flac
vyn --audio-only clip.avi sound.aac
```

### Supported Audio Formats

- **MP3** - Universal compatibility
- **FLAC** - Lossless compression
- **AAC** - High quality, small size
- **Opus** - Best quality per bitrate
- **WAV** - Uncompressed
- **OGG** - Open format
- **M4A** - Apple/iTunes compatible

### Audio Quality Settings

```bash
# High quality audio extraction
vyn --audio-only --quality high video.mp4 audio.mp3

# Batch audio extraction
for video in *.mp4; do
    vyn --audio-only "$video" "${video%.mp4}.mp3"
done
```

---

## Plugins

Vyn features an extensible plugin system for additional functionality.

### Plugin Management

```bash
# List available plugins
vyn --list-plugins

# Install plugins from repository
vyn --add-plugins

# Remove installed plugins
vyn --remove-plugins
```

### Available Plugins

#### Vimeo Uploader

Upload videos to Vimeo with playlist creation:

```bash
# Upload folder to Vimeo
vyn --plugin vimeo-uploader /path/to/videos/

# Features:
# - Batch upload entire folders
# - Automatic playlist creation
# - Generates links.txt with URLs
# - Multi-format support
```

#### Quality Analyzer

Analyze video quality and generate reports:

```bash
# Analyze video quality
vyn --plugin quality-analyzer /path/to/video.mp4

# Features:
# - Quality metrics analysis
# - Optimization recommendations
# - Detailed reports
# - Performance insights
```

### Using Plugins

```bash
# Execute plugin
vyn --plugin <plugin-name> <input>

# Plugin with options
vyn --plugin vimeo-uploader --folder "My Videos" /videos/

# Combine with other options
vyn --plugin quality-analyzer --analytics video.mp4
```

For plugin development, see [Plugins.md](Plugins.md).

---

## Configuration

Save and load conversion preferences.

### Configuration Files

```bash
# Save current settings
vyn --save-config

# Use custom configuration
vyn --config ~/my-settings.conf input.avi output.mp4

# Configuration location
~/.config/vyn/config.conf
```

### Configuration Options

Configuration files can include:

```bash
# Default operation mode
DEFAULT_OPERATION_MODE="encode"

# Quality settings
DEFAULT_CRF_VALUE="23"

# GPU acceleration
USE_GPU="true"
GPU_TYPE="nvenc"

# UI preferences
USE_COLOR="true"

# File handling
DELETE_ORIGINAL="false"
```

### Preset Configurations

Create custom preset configurations:

```bash
# Web streaming config
echo 'DEFAULT_OPERATION_MODE="encode"
DEFAULT_CRF_VALUE="23"
USE_GPU="true"' > ~/.config/vyn/web.conf

# Use custom config
vyn --config ~/.config/vyn/web.conf input.mkv output.mp4
```

---

## Analytics

Track conversion performance and optimize workflows.

### Enabling Analytics

```bash
# Enable for single conversion
vyn --analytics input.mkv output.mp4

# View analytics summary
vyn --show-analytics

# Analytics data location
~/.config/vyn/analytics.json
```

### Analytics Data

Tracked metrics include:

- ⏱️ **Conversion Time** - Total processing duration
- ⚡ **Speed** - Frames per second processed
- 📊 **File Sizes** - Input vs output comparison
- 🎯 **Compression Ratio** - Space saved percentage
- 🔧 **Settings Used** - CRF, preset, GPU status
- 📈 **Performance Trends** - Historical data

### Analytics Examples

```bash
# Track batch conversion performance
vyn --batch --analytics --preset web /videos/

# Compare presets
vyn --analytics --preset cinema video.mkv cinema.mp4
vyn --analytics --preset web video.mkv web.mp4
vyn --show-analytics

# GPU performance tracking
vyn --analytics --gpu video.mkv gpu_output.mp4
vyn --analytics video.mkv cpu_output.mp4
vyn --show-analytics
```

---

## Video Filters

Apply video processing filters during conversion.

### Available Filters

- **deinterlace** - Remove interlacing artifacts
- **denoise** - Reduce video noise
- **scale** - Resize video resolution
- **crop** - Crop video dimensions
- **color** - Color correction and grading

### Using Filters

```bash
# Single filter
vyn --filters deinterlace old_video.ts clean.mp4

# Multiple filters
vyn --filters "denoise,scale=1920:1080" input.avi output.mp4

# Filters with preset
vyn --preset web --filters denoise video.mkv output.mp4
```

### Filter Examples

```bash
# Deinterlace old footage
vyn --filters deinterlace vhs_capture.avi clean.mp4

# Denoise and scale
vyn --filters "denoise,scale=1280:720" noisy.mp4 clean.mp4

# Color correction
vyn --filters "eq=brightness=0.1:contrast=1.2" input.mp4 output.mp4

# Crop and scale
vyn --filters "crop=1920:800:0:140,scale=1920:1080" input.mkv output.mp4
```

---

## Supported Formats

### Input Formats

**Video Containers**:
- MKV, MP4, AVI, MOV, WebM
- FLV, WMV, M4V, 3GP
- TS, VOB, MPG, MPEG

**Audio Formats**:
- MP3, FLAC, AAC, Opus
- WAV, OGG, M4A

### Output Formats

| Format | Container | Video Codec | Audio Codec | Best For |
|--------|-----------|-------------|-------------|----------|
| **MP4** | MPEG-4 | H.264 | AAC | Universal compatibility |
| **MKV** | Matroska | H.264/H.265 | AAC/Opus | High quality, features |
| **WebM** | WebM | VP9 | Opus | Web streaming |
| **AVI** | AVI | H.264 | AAC | Legacy compatibility |

### Codec Information

**Video Codecs**:
- **H.264 (x264)** - Best compatibility and quality balance
- **H.265 (x265)** - Better compression, limited compatibility
- **VP9** - Open source, web streaming
- **AV1** - Next-gen codec (experimental)

**Audio Codecs**:
- **AAC** - Universal compatibility
- **Opus** - Best quality per bitrate
- **MP3** - Universal legacy support
- **FLAC** - Lossless compression

---

## Troubleshooting

### Common Issues and Solutions

#### FFmpeg Not Found

```bash
# Install FFmpeg
sudo pacman -S ffmpeg  # Arch/CachyOS
sudo apt install ffmpeg  # Ubuntu/Debian
sudo dnf install ffmpeg  # Fedora
brew install ffmpeg     # macOS
```

Verify installation:
```bash
ffmpeg -version
which ffmpeg
```

#### Permission Denied

```bash
# Make executable
chmod +x bin/vyn

# Check file permissions
ls -l bin/vyn

# Reinstall if needed
./install-vyn.sh
```

#### GPU Acceleration Not Available

```bash
# Check GPU drivers
nvidia-smi           # NVIDIA
lspci | grep VGA     # List graphics cards

# Check FFmpeg GPU support
ffmpeg -encoders | grep nvenc   # NVIDIA
ffmpeg -encoders | grep vaapi   # AMD/Intel
ffmpeg -encoders | grep qsv     # QuickSync

# Install GPU drivers
# NVIDIA: Install proprietary drivers
# AMD: Install mesa drivers
# Intel: Usually included in kernel
```

Falls back to CPU automatically if GPU unavailable.

#### Conversion Fails

```bash
# Check input file
ffprobe input.mkv

# Test with simple conversion
vyn --remux input.mkv output.mp4

# Enable verbose output
vyn --verbose input.mkv output.mp4

# Try different preset
vyn --preset web input.mkv output.mp4
```

#### Performance Issues

**Slow Encoding**:
- Use GPU acceleration: `--gpu`
- Use faster preset: `--preset mobile`
- Reduce quality: `--crf 28`
- Check system resources: `htop`

**High CPU Usage**:
- Use GPU acceleration
- Reduce concurrent processes
- Use remux mode when possible

**Disk Space**:
- Check available space: `df -h`
- Use higher CRF for smaller files
- Clean temporary files
- Use batch output directory

#### File Not Found

```bash
# Use absolute paths
vyn /full/path/to/input.mkv /full/path/to/output.mp4

# Check current directory
pwd
ls -la

# Verify file exists
file input.mkv
```

### Getting Help

```bash
# Comprehensive help
vyn --help

# Version and system info
vyn --version

# Check dependencies
ffmpeg -version && jq --version

# Community support
# GitHub: https://github.com/samonide/vyn/issues
```

---

## Integration Examples

### Automated Workflows

#### Watch Folder Automation

```bash
# Monitor folder and auto-convert (requires inotifywait)
inotifywait -m ~/incoming -e create | while read dir action file; do
    vyn --preset mobile "$dir$file" ~/converted/"${file%.*}.mp4"
done
```

#### Batch Processing Script

```bash
#!/bin/bash
# Batch convert all videos in a directory

INPUT_DIR="/path/to/videos"
OUTPUT_DIR="/path/to/output"
PRESET="web"

for video in "$INPUT_DIR"/*.{mkv,avi,mov,mp4}; do
    [ -f "$video" ] || continue
    filename=$(basename "$video")
    name="${filename%.*}"
    vyn --preset "$PRESET" --gpu "$video" "$OUTPUT_DIR/$name.mp4"
done
```

#### Quality Comparison Script

```bash
#!/bin/bash
# Compare different quality settings

INPUT="original.mkv"

for crf in 16 20 23 28; do
    vyn --encode --crf "$crf" --analytics \
        "$INPUT" "output_crf${crf}.mp4"
done

vyn --show-analytics
```

### CI/CD Integration

#### GitHub Actions

```yaml
name: Video Processing
on: [push]
jobs:
  convert:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v2
      - name: Install Vyn
        run: |
          git clone https://github.com/samonide/vyn.git
          cd vyn && ./install-vyn.sh
      - name: Convert Videos
        run: vyn --batch --preset web videos/
```

### Integration with Other Tools

#### FFmpeg Direct Integration

```bash
# Vyn generates FFmpeg commands that can be used directly
vyn --dry-run --preset cinema input.mkv output.mp4

# Customize FFmpeg commands based on Vyn output
```

#### Script Integration

```python
#!/usr/bin/env python3
import subprocess

def convert_video(input_file, output_file, preset="web"):
    cmd = ["vyn", "--preset", preset, input_file, output_file]
    result = subprocess.run(cmd, capture_output=True, text=True)
    return result.returncode == 0

# Usage
if convert_video("input.mkv", "output.mp4", preset="cinema"):
    print("Conversion successful!")
```

```javascript
// Node.js integration
const { exec } = require('child_process');

function convertVideo(input, output, preset = 'web') {
    return new Promise((resolve, reject) => {
        exec(`vyn --preset ${preset} ${input} ${output}`, 
            (error, stdout, stderr) => {
                if (error) reject(error);
                else resolve(stdout);
            });
    });
}

// Usage
convertVideo('input.mkv', 'output.mp4', 'cinema')
    .then(output => console.log('Success:', output))
    .catch(error => console.error('Error:', error));
```

---

## Best Practices

### Quality vs. Size Trade-offs

```bash
# Maximum quality (large files)
vyn --preset archive input.mkv output.mkv

# Balanced quality/size (recommended)
vyn --preset web input.mkv output.mp4

# Smaller files (acceptable quality)
vyn --preset mobile input.mkv output.mp4
```

### Workflow Recommendations

1. **Test First**: Use `--dry-run` to preview operations
2. **Start Simple**: Begin with presets before custom settings
3. **Use GPU**: Enable `--gpu` for batch processing
4. **Track Performance**: Use `--analytics` to optimize
5. **Preserve Originals**: Keep backups until verified

### Performance Optimization

```bash
# Fast processing
vyn --remux --gpu input.mkv output.mp4

# Balanced performance
vyn --preset web --gpu input.mkv output.mp4

# Maximum quality (slower)
vyn --preset cinema --analytics input.mkv output.mp4
```

---

## Advanced Topics

### Custom Encoding Settings

For advanced users who need fine-grained control:

```bash
# Custom CRF and resolution
vyn --encode --crf 18 --filters "scale=1920:1080" input.mkv output.mp4

# Multiple passes (better quality)
# (Advanced FFmpeg usage - refer to FFmpeg documentation)

# Custom audio settings
# Configure via FFmpeg directly or use Vyn presets
```

### Metadata Preservation

```bash
# Vyn preserves metadata by default
# Check metadata:
ffprobe -hide_banner output.mp4

# Custom metadata handling via FFmpeg
```

### Subtitle Handling

```bash
# Subtitles are preserved by default in MKV
vyn input.mkv output.mkv

# For MP4, subtitles may need external handling
# Extract subtitles: ffmpeg -i input.mkv -map 0:s:0 subs.srt
```

---

## Additional Resources

- **FFmpeg Documentation**: https://ffmpeg.org/documentation.html
- **Video Codecs Guide**: https://trac.ffmpeg.org/wiki/Encode/H.264
- **GPU Acceleration**: https://trac.ffmpeg.org/wiki/HWAccelIntro
- **GitHub Repository**: https://github.com/samonide/vyn
- **Issue Tracker**: https://github.com/samonide/vyn/issues

---

*For plugin development and contribution guidelines, see [Plugins.md](Plugins.md) and [Contributing.md](Contributing.md)*
