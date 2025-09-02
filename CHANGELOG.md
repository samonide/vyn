# Changelog

All notable changes to Vyn will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased] v1.0.1-dev

### Added
- **Dry Run Mode** - Preview operations without modifying files using `--dry-run` flag
- **Size Estimation** - Intelligent file size prediction based on compression ratios
- **Auto Directory Creation** - Automatically creates output directories if they don't exist
- **Enhanced File Format Support** - Added support for MOV, FLV, and 3GP formats
- **Better Error Handling** - Improved error messages and file validation
- **Enhanced Codec Selection** - More intelligent codec selection based on output format
- **Timing Information** - Shows conversion duration for completed operations
- **File Size Comparison** - Displays before/after file sizes with compression ratios
- **Format Validation** - Warns users about potentially unsupported file formats
- **Progress Indicators** - Better visual feedback during file analysis and conversion
- **Human-Readable File Sizes** - Automatic conversion to KB/MB/GB formats

### Improved
- **File Information Display** - Better handling of empty or corrupted files
- **FFmpeg Output** - Cleaner progress display with -hide_banner and improved logging levels
- **User Experience** - More informative feedback throughout the conversion process
- **Error Recovery** - Better handling of edge cases in strict mode
- **User Experience** - More informative preview and confirmation dialogs
- **Cross-Platform Compatibility** - Better handling of various file systems

### Fixed
- **Directory Validation** - Fixed issues with non-existent output directories
- **File Extension Handling** - Case-insensitive file extension processing

## [1.0.0] - 2025-09-02

### Added
- Initial release of **Vyn** - A powerful video format converter
- Interactive CLI with beautiful colored output and emojis
- Two operation modes: Remux (fast) and Encode (quality control)
- Quality presets (High, Good, Medium, Low, Custom CRF)
- Cross-platform support (Linux, macOS, Windows with WSL)
- Comprehensive file information display with jq integration
- Progress tracking and detailed conversion summaries
- Multiple installation methods (global, user, PATH)
- Extensive format support (MP4, MKV, WebM, AVI, MOV, and more)
- Smart codec detection based on output format
- Size comparison and performance statistics
- Comprehensive documentation with usage examples
- Unlicense (Public Domain) for maximum freedom

### Features
- FFmpeg integration for professional video processing
- jq integration for enhanced file information (optional dependency)
- Robust error handling and input validation
- User-friendly prompts and confirmations
- Automatic dependency checking with cross-platform support
- Package manager detection (pacman, apt, dnf, brew, zypper)
- Shell detection for proper PATH configuration

### Supported Platforms
- **Arch Linux / CachyOS** (pacman)
- **Ubuntu / Debian** (apt)
- **Fedora** (dnf)
- **openSUSE** (zypper)
- **macOS** (brew)
- **Windows** (WSL)
- Other Linux distributions (manual installation)

### Dependencies
- **FFmpeg** (required) - Video processing engine
- **jq** (optional) - Enhanced file information display

### Technical Details
- Bash script with strict mode (`set -euo pipefail`)
- Google Shell Style Guide compliance
- Cross-platform path and command handling
- Memory-efficient processing
- Secure input validation

## [Planned] Future Versions

### v1.1.0 - Enhanced Productivity
- Batch processing mode for multiple files
- Configuration file support for saving preferences
- Visual progress bar during conversion
- GPU acceleration support (NVENC/VAAPI)
- Audio-only extraction and conversion mode

### v1.2.0 - Advanced Features
- Subtitle handling (preserve, extract, burn-in)
- Basic video filters (resize, crop, rotate)
- Custom preset management system
- Resume support for interrupted conversions
- Queue system for batch operations

### v2.0.0 - Next Generation
- Optional web interface for remote usage
- Streaming output to cloud services
- AI-powered optimization suggestions
- Plugin system for custom filters
- Distributed processing support

---

**Note**: This project follows the "release early, release often" philosophy. Each version aims to add meaningful value while maintaining stability and simplicity.
o