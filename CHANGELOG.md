# Changelog

All notable changes to Vyn will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [1.5.0] - 2026-01-28

### Added
- **🏗️ Complete Modular Architecture**
  - `src/utils.sh` - Core utility functions (20+ functions)
  - `src/config.sh` - Configuration management (load, save, Vimeo config)
  - `src/gpu.sh` - GPU acceleration detection (NVENC, VAAPI, QSV)
  - `src/presets.sh` - Professional preset system (7 presets)
  - `src/analytics.sh` - Performance tracking and analytics
  - `src/plugins.sh` - Complete plugin management system
  - `src/batch.sh` - Batch processing functionality
  - `src/filters.sh` - Video filter application (scale, crop, denoise, etc.)
- **📚 Comprehensive Documentation**
  - `docs/Usage.md` - Complete usage guide (969 lines)
  - `docs/Plugins.md` - Plugin development guide (782 lines)
  - `docs/Contributing.md` - Contributor guidelines (621 lines)
  - `docs/Architecture.md` - Technical architecture (413 lines)
  - `ROADMAP.md` - Development roadmap and timeline
  - `QUICKSTART-DEV.md` - Developer quick start guide
  - `MODULARIZATION-PROGRESS.md` - Refactoring progress tracker

### Changed
- **📦 Project Structure**
  - Reorganized into professional structure (bin/, src/, docs/, config/, tests/)
  - Main script reduced from 2541 to 1519 lines (40% reduction)
  - README.md reduced from 485 to 163 lines (66% reduction)
  - Updated `.gitignore` with new structure
- **🛠️ Code Quality**
  - Removed duplicate code through modularization
  - Improved separation of concerns across 8 modules
  - Enhanced error handling and user feedback
  - Better maintainability and testability

### Technical
- All 45+ functions properly organized into focused modules
- Clean module interfaces with clear responsibilities
- Optimized module loading order
- Professional bash scripting practices throughout
- Ready for Phase 2 (testing framework)

### Developer Notes
- This is the beginning of the modularization roadmap
- Functions in `src/utils.sh`: print functions, file validation, format helpers
- Next modules to extract: presets, GPU, plugins, analytics, config

## [1.4.1] - 2026-01-08

### Changed
- **🏗️ Major Codebase Refactoring** - Reorganized project structure for better maintainability
  - Created professional directory structure: `bin/`, `src/`, `docs/`, `config/`, `tests/`
  - Moved main script to `bin/vyn` for cleaner organization
  - Organized all documentation in `docs/` directory
  - Prepared modular architecture in `src/` for future improvements

- **📖 Documentation Overhaul**
  - **README.md** - Completely rewritten to be compact and focused (quick start, features, basic usage)
  - **docs/Usage.md** - New comprehensive usage guide with all detailed documentation
  - **docs/Plugins.md** - Complete plugin development and usage guide
  - **docs/Contributing.md** - Detailed contribution guidelines and standards
  - **docs/Architecture.md** - Technical architecture and design documentation
  - Moved all plugin documentation to `docs/` directory

- **📦 Project Structure Improvements**
  - Updated `package.json` with proper metadata and scripts
  - Updated installer script to work with new directory structure
  - Improved `.gitignore` with comprehensive patterns
  - Better organization for future scalability

### Benefits
- **Easier Navigation** - Clear separation of concerns with dedicated directories
- **Better Documentation** - Compact README with detailed docs separated
- **Professional Structure** - Industry-standard project organization
- **Improved Maintainability** - Prepared for modular architecture
- **Better Contributions** - Clear guidelines and structure for contributors

## [1.4.0] - 2025-09-05

### Added
- **🔌 Comprehensive Plugin Management System** 
  - `--add-plugins` - Interactive plugin installation from official repository
  - `--remove-plugins` - Interactive plugin removal interface
  - Enhanced `--list-plugins` with detailed plugin information
  - `plugins.json` manifest system with rich metadata

- **🎬 Vimeo Uploader Plugin**
  - Batch upload entire video folders to Vimeo
  - Automatic playlist/album creation for each folder
  - One-time personal access token setup
  - Generates `links.txt` with all video and playlist URLs
  - Multi-format support (MP4, AVI, MOV, MKV, WebM, FLV, WMV)
  - Seamless workflow integration - skips standard conversion prompts

- **📦 Plugin Repository Architecture**
  - Organized plugin source files in `plugins/` directory
  - Comprehensive plugin documentation and setup instructions
  - Automatic dependency validation and requirement checking
  - Plugin categorization (Upload, Conversion, Utility)

### Changed
- **Streamlined Help System** - Reduced examples to focus on core functionality
- **Enhanced User Experience** - Directory-based plugins bypass conversion workflow
- **Better Plugin Integration** - Plugins execute directly without video conversion prompts

### Fixed
- **Color Display Issues** - Removed problematic color codes in plugin listings
- **Plugin Workflow** - Directory inputs now work seamlessly with plugin system

## [1.3.0] - 2025-09-04

### Added
- **🎯 Professional Preset System** - Industry-standard presets for broadcast, cinema, web, mobile, archive, and social media workflows
- **📊 Analytics Framework** - Comprehensive performance tracking with JSON logging and detailed metrics
- **🔌 Plugin Architecture** - Extensible plugin system for custom video processing workflows
- **🎨 Video Filters** - Apply deinterlacing, denoising, scaling, and color correction filters
- **📄 Enhanced Configuration Management** - Advanced settings persistence and workflow management
- **🎬 Professional Preset Options**:
  - **Broadcast** (CRF 18) - High quality for TV/broadcasting with deinterlacing
  - **Cinema** (CRF 16) - Film industry standard with BT.709 colorspace
  - **Web** (CRF 23) - Optimized for streaming platforms (1080p)
  - **Mobile** (CRF 28) - Battery-efficient playback (720p)
  - **Archive** (CRF 12) - Near-lossless preservation quality
  - **Social Media** (CRF 26) - Square format for social platforms (1080x1080)
- **📈 Analytics & Reporting**:
  - Conversion time and speed tracking
  - File size comparisons and compression ratios
  - Performance trends and optimization metrics
  - JSON-based analytics storage
  - Detailed conversion history
- **🔌 Plugin System Features**:
  - Extensible architecture for custom processing
  - Plugin template and example included
  - Validation and error handling
  - Community plugin support framework

### New Command Line Options
- `--preset <type>` - Apply professional presets (broadcast, cinema, web, mobile, archive, social)
- `--filters <filter>` - Apply video filters (deinterlace, denoise, scale, color correction)
- `--analytics` - Enable conversion analytics tracking
- `--show-analytics` - Display analytics summary and performance data
- `--list-plugins` - List all available plugins
- `--plugin <name>` - Execute custom plugin for processing

### Improved
- **🎨 Professional Interface** - Enhanced CLI with improved visual hierarchy and professional presentation
- **📋 Comprehensive Help System** - Updated documentation with all new features and examples
- **🛡️ Error Handling** - Robust validation and recovery mechanisms for professional workflows
- **⚡ Performance Optimization** - Enhanced processing pipeline with better resource utilization
- **📖 Documentation** - Complete rewrite of README.md with professional formatting and comprehensive guides

### Technical Improvements
- **🏗️ Modular Architecture** - Clean separation of preset, analytics, and plugin systems
- **🔧 Configuration System** - Advanced settings management with validation
- **📊 Data Management** - JSON-based analytics with structured logging
- **🎯 Quality Control** - Professional-grade preset validation and optimization
- **🔌 Extensibility** - Plugin system designed for community contributions

### Professional Features
- **🎬 Industry Standards** - Presets based on real-world professional requirements
- **📊 Performance Analytics** - Track and optimize conversion workflows
- **🔧 Advanced Filters** - Professional video processing capabilities
- **🎯 Workflow Integration** - Seamless integration with professional video pipelines
- **📈 Metrics & Reporting** - Detailed performance tracking and optimization insights

## [1.1.0] - 2025-09-03

### Added
- **🗂️ Batch Processing Mode** - Convert multiple files at once with `--batch` flag
- **📄 Configuration File Support** - Save and load preferences with `--config` and `--save-config`
- **🎮 GPU Acceleration** - Hardware acceleration support for NVENC, VAAPI, and QuickSync with `--gpu`
- **🎵 Audio-Only Mode** - Extract audio tracks with `--audio-only` flag
- **📊 Enhanced Progress Display** - Improved visual feedback with detailed operation status
- **🔧 Smart Codec Selection** - Automatic GPU codec selection based on available hardware
- **📁 Auto-Directory Scanning** - Batch mode automatically finds all video files in directories
- **💾 Configuration Persistence** - Remember user preferences across sessions
- **🎯 Format-Specific Optimization** - GPU acceleration tailored for different output formats

### Improved
- **🎬 Video Encoding Pipeline** - Enhanced with GPU acceleration and better error handling
- **📋 Help System** - Updated with new batch processing and GPU acceleration options
- **🚀 Performance** - Significant speed improvements when GPU acceleration is available
- **🛡️ Error Recovery** - Better handling of GPU fallback scenarios
- **💬 User Experience** - More informative feedback for batch operations and GPU status
- **🔄 File Processing** - Smarter file discovery and validation in batch mode

### Technical Improvements
- **🎮 Hardware Detection** - Automatic GPU capability detection (NVIDIA, AMD, Intel)
- **📦 Codec Compatibility** - Enhanced codec selection for different output containers
- **⚡ Batch Optimization** - Efficient processing pipeline for multiple files
- **🔧 Configuration Management** - Robust config file handling with validation
- **📊 Progress Tracking** - Enhanced progress indicators for long-running batch operations

### Supported GPU Acceleration
- **NVIDIA NVENC** - H.264/H.265 hardware encoding for GeForce/Quadro cards
- **AMD/Intel VAAPI** - Hardware acceleration for Linux systems
- **Intel QuickSync** - Hardware acceleration for Intel integrated graphics

### New Command Line Options
- `--batch` - Enter batch processing mode for multiple files
- `--audio-only` - Extract audio tracks only
- `--gpu` - Enable GPU acceleration if available
- `--config <path>` - Specify custom configuration file path
- `--save-config` - Save current settings to configuration file

## [1.0.1] - 2025-09-02

### Added
- **🎨 Beautiful Help System** - Redesigned help output with professional styling to match version output
- **⚡ Animated Progress Bars** - Real-time progress indicators during encoding and remuxing operations
- **🔍 Dry Run Mode** - Preview operations without modifying files using `--dry-run` flag
- **📊 Size Estimation** - Intelligent file size prediction based on compression ratios
- **📁 Auto Directory Creation** - Automatically creates output directories if they don't exist
- **🎬 Enhanced File Format Support** - Added support for MOV, FLV, and 3GP formats
- **🛡️ Better Error Handling** - Improved error messages and file validation
- **🎯 Enhanced Codec Selection** - More intelligent codec selection based on output format
- **⏱️ Timing Information** - Shows conversion duration for completed operations
- **📊 File Size Comparison** - Displays before/after file sizes with compression ratios
- **⚠️ Format Validation** - Warns users about potentially unsupported file formats
- **🎚️ Progress Indicators** - Better visual feedback during file analysis and conversion
- **💾 Human-Readable File Sizes** - Automatic conversion to KB/MB/GB formats

### Improved
- **🎨 User Interface** - Professional styling with icons, color coding, and visual hierarchy
- **📋 Help Output** - Tree-structured layout with clear sections and examples
- **🔄 Progress Feedback** - Animated spinners and progress bars for better user experience
- **📁 File Information Display** - Better handling of empty or corrupted files
- **🖥️ FFmpeg Output** - Cleaner progress display with improved logging levels
- **🐛 Error Recovery** - Better handling of edge cases in strict mode
- **💬 User Experience** - More informative feedback throughout the conversion process

### Fixed
- **🐛 Printf Formatting** - Resolved percentage symbol formatting issues in output messages
- **🧹 Cleanup** - Better temporary file management and error handling
- **⚡ Performance** - Optimized progress display and reduced overhead
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

---

**Development Philosophy**: Each release maintains Vyn's core principle of "simplicity first" while adding powerful features that users can adopt progressively. The modular architecture ensures that basic users aren't overwhelmed by advanced features, while power users have access to professional-grade capabilities.

**Community-Driven**: Feature priorities will be adjusted based on community feedback, real-world usage patterns, and emerging technology trends. The roadmap remains flexible to adapt to user needs and industry developments.

---

**Note**: This project follows the "release early, release often" philosophy. Each version aims to add meaningful value while maintaining stability and simplicity.