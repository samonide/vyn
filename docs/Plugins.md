# Vyn Plugin System

Complete guide to Vyn's extensible plugin architecture.

## Table of Contents

- [Overview](#overview)
- [Available Plugins](#available-plugins)
- [Using Plugins](#using-plugins)
- [Plugin Development](#plugin-development)
- [Plugin Structure](#plugin-structure)
- [Plugin Manifest](#plugin-manifest)
- [Best Practices](#best-practices)
- [Publishing Plugins](#publishing-plugins)

---

## Overview

Vyn features a comprehensive plugin system that extends its functionality beyond core video conversion. Plugins can add support for:

- Video platform uploads (Vimeo, YouTube, etc.)
- Quality analysis and reporting
- Custom video processing workflows
- Metadata manipulation
- Subtitle handling
- Thumbnail generation
- And much more!

### Plugin Features

- **Easy Installation** - Install from official repository
- **Simple Management** - List, install, and remove with commands
- **Rich Metadata** - Detailed plugin information and documentation
- **Dependency Checking** - Automatic validation of requirements
- **Seamless Integration** - Works naturally with Vyn workflows

---

## Available Plugins

### Vimeo Uploader

Upload videos to Vimeo with automatic playlist creation.

**Features:**
- Batch upload entire folders
- Automatic playlist/album creation
- Generate links.txt with all URLs
- Multi-format support
- Progress tracking
- Privacy settings

**Usage:**
```bash
# Upload folder to Vimeo
vyn --plugin vimeo-uploader /path/to/videos/

# Plugin will prompt for:
# - Vimeo access token (one-time setup)
# - Folder/album name
# - Privacy settings
# - Upload location
```

**Setup:**
1. Go to https://developer.vimeo.com/apps
2. Create a new app
3. Generate access token with 'upload' and 'create' scopes
4. Token will be requested on first use

**Requirements:**
- `curl` - HTTP requests
- `jq` - JSON processing
- Vimeo API access token

### Quality Analyzer

Analyze video quality metrics and generate optimization reports.

**Features:**
- Quality metrics analysis
- Bitrate analysis
- Resolution statistics
- Codec information
- Optimization recommendations
- Detailed reports

**Usage:**
```bash
# Analyze single video
vyn --plugin quality-analyzer /path/to/video.mp4

# Analyze directory
vyn --plugin quality-analyzer /path/to/videos/
```

**Requirements:**
- `ffprobe` (included with FFmpeg)
- `jq` - JSON processing

---

## Using Plugins

### Plugin Management

```bash
# List available plugins
vyn --list-plugins

# Install plugins from repository
vyn --add-plugins

# Remove installed plugins
vyn --remove-plugins
```

### Executing Plugins

```bash
# Basic plugin execution
vyn --plugin <plugin-name> <input>

# Examples
vyn --plugin vimeo-uploader /videos/my-project/
vyn --plugin quality-analyzer video.mp4

# With additional Vyn options
vyn --plugin quality-analyzer --analytics video.mp4
```

### Plugin Output

Plugins may generate:
- Console output with progress
- Report files (JSON, TXT, HTML)
- Modified videos
- Links and URLs
- Metadata files

Check plugin documentation for specific outputs.

---

## Plugin Development

### Creating a Plugin

Plugins are bash scripts that extend Vyn's functionality.

#### Basic Plugin Template

```bash
#!/usr/bin/env bash

# Plugin: My Custom Plugin
# Description: Brief description of what the plugin does
# Author: Your Name
# Version: 1.0.0
# Requirements: curl, jq

set -euo pipefail

# Plugin metadata
readonly PLUGIN_NAME="my-custom-plugin"
readonly PLUGIN_VERSION="1.0.0"
readonly PLUGIN_AUTHOR="Your Name"

# Color output (optional)
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

print_info() {
    echo -e "${GREEN}ℹ ${NC}$1"
}

print_error() {
    echo -e "${RED}✗ ${NC}$1" >&2
}

print_success() {
    echo -e "${GREEN}✓ ${NC}$1"
}

# Validate requirements
check_requirements() {
    local missing=()
    
    for cmd in curl jq; do
        if ! command -v "$cmd" &>/dev/null; then
            missing+=("$cmd")
        fi
    done
    
    if [[ ${#missing[@]} -gt 0 ]]; then
        print_error "Missing required commands: ${missing[*]}"
        print_info "Install with: sudo apt install ${missing[*]}"
        return 1
    fi
    
    return 0
}

# Main plugin logic
process_video() {
    local input="${1}"
    
    # Validate input
    if [[ ! -f "$input" ]]; then
        print_error "File not found: $input"
        return 1
    fi
    
    print_info "Processing: $input"
    
    # Your plugin logic here
    # Example: Extract metadata
    local duration
    duration=$(ffprobe -v quiet -show_entries format=duration \
        -of default=noprint_wrappers=1:nokey=1 "$input")
    
    print_success "Duration: ${duration}s"
    
    return 0
}

# Main entry point
main() {
    print_info "🔌 ${PLUGIN_NAME} v${PLUGIN_VERSION}"
    
    # Check requirements
    if ! check_requirements; then
        return 1
    fi
    
    # Process input
    local input="${1:-}"
    if [[ -z "$input" ]]; then
        print_error "Usage: vyn --plugin ${PLUGIN_NAME} <input>"
        return 1
    fi
    
    # Handle directory or file
    if [[ -d "$input" ]]; then
        print_info "Processing directory: $input"
        for video in "$input"/*.{mp4,mkv,avi,mov}; do
            [[ -f "$video" ]] && process_video "$video"
        done
    else
        process_video "$input"
    fi
    
    print_success "Plugin completed successfully!"
}

# Execute main function
main "$@"
```

### Advanced Plugin Example

```bash
#!/usr/bin/env bash

# Plugin: Video Thumbnail Generator
# Description: Generate thumbnails at intervals
# Author: Plugin Developer
# Version: 1.0.0

set -euo pipefail

readonly PLUGIN_NAME="thumbnail-generator"
readonly OUTPUT_DIR="thumbnails"

generate_thumbnails() {
    local input="${1}"
    local interval="${2:-10}"  # Every 10 seconds
    local output_dir="${3:-$OUTPUT_DIR}"
    
    # Create output directory
    mkdir -p "$output_dir"
    
    # Get video duration
    local duration
    duration=$(ffprobe -v quiet -show_entries format=duration \
        -of default=noprint_wrappers=1:nokey=1 "$input")
    
    # Calculate number of thumbnails
    local count=$((${duration%.*} / interval))
    
    echo "Generating $count thumbnails..."
    
    # Generate thumbnails
    for ((i=0; i<=count; i++)); do
        local timestamp=$((i * interval))
        local filename="${output_dir}/thumb_$(printf '%04d' $i).jpg"
        
        ffmpeg -ss "$timestamp" -i "$input" -vframes 1 \
            -vf "scale=320:-1" "$filename" -y 2>/dev/null
        
        echo -ne "Progress: $i/$count\r"
    done
    
    echo -e "\nGenerated $count thumbnails in $output_dir/"
}

main() {
    local input="${1:-}"
    
    if [[ -z "$input" ]]; then
        echo "Usage: vyn --plugin $PLUGIN_NAME <video-file> [interval] [output-dir]"
        return 1
    fi
    
    local interval="${2:-10}"
    local output_dir="${3:-$OUTPUT_DIR}"
    
    generate_thumbnails "$input" "$interval" "$output_dir"
}

main "$@"
```

---

## Plugin Structure

### File Organization

```
plugins/
├── README.md
├── my-plugin/
│   ├── my-plugin.sh           # Main plugin script
│   ├── my-plugin.md           # Plugin documentation
│   └── config.json            # Plugin configuration (optional)
```

### Plugin Script Requirements

- **Shebang**: `#!/usr/bin/env bash`
- **Executable**: `chmod +x plugin-name.sh`
- **Exit codes**: 0 for success, non-zero for errors
- **Input handling**: Accept file or directory path
- **Error handling**: Validate inputs and dependencies

### Plugin Documentation

Each plugin should have a `.md` file with:

```markdown
# Plugin Name

Brief description of what the plugin does.

## Features

- Feature 1
- Feature 2
- Feature 3

## Usage

```bash
vyn --plugin plugin-name <input>
```

## Options

- `--option1` - Description
- `--option2` - Description

## Examples

```bash
# Example 1
vyn --plugin plugin-name video.mp4

# Example 2
vyn --plugin plugin-name /path/to/videos/
```

## Requirements

- Command 1
- Command 2
- API access (if applicable)

## Configuration

Setup instructions if needed.

## Output

Description of what the plugin produces.
```

---

## Plugin Manifest

### plugins.json Structure

```json
{
  "version": "1.0",
  "repository": "vyn-plugins",
  "description": "Official plugin repository for Vyn",
  "plugins": [
    {
      "id": "my-plugin",
      "name": "My Custom Plugin",
      "version": "1.0.0",
      "description": "Brief description",
      "author": "Plugin Author",
      "file": "my-plugin.sh",
      "documentation": "my-plugin.md",
      "category": "Upload|Analysis|Conversion|Utility",
      "tags": ["tag1", "tag2", "tag3"],
      "requirements": {
        "commands": ["curl", "jq"],
        "api": "API description if required"
      },
      "features": [
        "Feature 1",
        "Feature 2",
        "Feature 3"
      ],
      "usage": "vyn --plugin my-plugin <input>",
      "setup": {
        "required": true,
        "description": "Setup requirements",
        "instructions": [
          "Step 1",
          "Step 2",
          "Step 3"
        ]
      }
    }
  ]
}
```

### Adding to Manifest

When creating a new plugin, add its entry to `plugins.json`:

```bash
# Edit plugins.json
vim plugins.json

# Validate JSON
jq . plugins.json

# Test plugin listing
vyn --list-plugins
```

---

## Best Practices

### Code Quality

- **Use shellcheck**: Validate script syntax
- **Error handling**: Check all commands and inputs
- **Clean output**: Clear, informative messages
- **Progress feedback**: Show progress for long operations
- **Exit codes**: Return proper status codes

### User Experience

- **Help text**: Show usage when called without args
- **Validation**: Validate inputs before processing
- **Confirmation**: Ask before destructive operations
- **Logs**: Optionally save logs for debugging
- **Cleanup**: Remove temporary files on exit

### Security

- **Input validation**: Sanitize user inputs
- **Safe commands**: Avoid eval and command injection
- **Permissions**: Check file permissions before writing
- **API keys**: Store securely, never hardcode
- **HTTPS**: Use secure connections for uploads

### Performance

- **Batch processing**: Handle multiple files efficiently
- **Progress updates**: Update progress periodically
- **Resource usage**: Be mindful of CPU/memory
- **Parallel processing**: Use when appropriate
- **Cleanup**: Remove temporary files promptly

### Example: Complete Plugin

```bash
#!/usr/bin/env bash

# Plugin: Video Metadata Extractor
# Description: Extract comprehensive video metadata to JSON
# Author: Vyn Team
# Version: 1.0.0
# Requirements: ffprobe, jq

set -euo pipefail

readonly PLUGIN_NAME="metadata-extractor"
readonly VERSION="1.0.0"

# Colors
readonly RED='\033[0;31m'
readonly GREEN='\033[0;32m'
readonly BLUE='\033[0;34m'
readonly NC='\033[0m'

# Logging functions
log_info() { echo -e "${BLUE}ℹ${NC} $1"; }
log_error() { echo -e "${RED}✗${NC} $1" >&2; }
log_success() { echo -e "${GREEN}✓${NC} $1"; }

# Check requirements
check_dependencies() {
    local missing=()
    for cmd in ffprobe jq; do
        command -v "$cmd" &>/dev/null || missing+=("$cmd")
    done
    
    if [[ ${#missing[@]} -gt 0 ]]; then
        log_error "Missing: ${missing[*]}"
        return 1
    fi
    return 0
}

# Extract metadata
extract_metadata() {
    local input="${1}"
    local output="${2:-${input%.*}_metadata.json}"
    
    log_info "Extracting metadata from: $input"
    
    # Get comprehensive metadata
    if ! ffprobe -v quiet -print_format json \
        -show_format -show_streams "$input" > "$output"; then
        log_error "Failed to extract metadata"
        return 1
    fi
    
    # Format output
    jq . "$output" > "${output}.tmp" && mv "${output}.tmp" "$output"
    
    log_success "Metadata saved to: $output"
    
    # Show summary
    local codec duration size
    codec=$(jq -r '.streams[0].codec_name' "$output")
    duration=$(jq -r '.format.duration' "$output")
    size=$(jq -r '.format.size' "$output")
    
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo "Codec: $codec"
    echo "Duration: ${duration}s"
    echo "Size: $((size / 1024 / 1024))MB"
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    
    return 0
}

# Main function
main() {
    log_info "🔌 $PLUGIN_NAME v$VERSION"
    
    # Check dependencies
    check_dependencies || return 1
    
    # Validate input
    local input="${1:-}"
    if [[ -z "$input" ]]; then
        log_error "Usage: vyn --plugin $PLUGIN_NAME <video-file>"
        return 1
    fi
    
    if [[ ! -f "$input" ]]; then
        log_error "File not found: $input"
        return 1
    fi
    
    # Process
    extract_metadata "$input"
}

# Cleanup on exit
cleanup() {
    # Remove any temporary files
    rm -f /tmp/vyn_plugin_*
}
trap cleanup EXIT

# Execute
main "$@"
```

---

## Publishing Plugins

### Submission Process

1. **Develop and test** your plugin thoroughly
2. **Create documentation** (README.md)
3. **Add to manifest** (plugins.json entry)
4. **Submit pull request** to main repository
5. **Review process** by maintainers
6. **Publication** to official repository

### Plugin Checklist

Before submitting:

- [ ] Plugin works correctly
- [ ] Code passes shellcheck
- [ ] Documentation is complete
- [ ] Manifest entry is accurate
- [ ] Dependencies are documented
- [ ] Error handling is robust
- [ ] Tested on multiple systems
- [ ] Examples are provided
- [ ] No hardcoded paths
- [ ] Follows best practices

### Submission Template

```markdown
## Plugin Submission: [Plugin Name]

### Description
[Brief description of plugin functionality]

### Category
- [ ] Upload
- [ ] Analysis
- [ ] Conversion
- [ ] Utility
- [ ] Other: ________

### Features
- Feature 1
- Feature 2
- Feature 3

### Requirements
- Dependency 1
- Dependency 2
- API access (if applicable)

### Testing
Tested on:
- [ ] Linux (distro: _______)
- [ ] macOS
- [ ] Windows WSL

### Checklist
- [ ] Code passes shellcheck
- [ ] Documentation complete
- [ ] Manifest entry added
- [ ] Examples provided
- [ ] No hardcoded values
- [ ] Error handling implemented
- [ ] Dependencies documented

### Additional Notes
[Any additional information]
```

---

## Plugin API Reference

### Available Functions

Plugins can use Vyn's utility functions:

```bash
# Color printing (if available)
print_info "Information message"
print_error "Error message"
print_success "Success message"
print_warning "Warning message"

# Video detection
is_video_file "$file"

# Format detection
get_video_codec "$file"
get_audio_codec "$file"
get_video_duration "$file"
```

### Environment Variables

Available to plugins:

```bash
$VYN_VERSION         # Vyn version
$VYN_CONFIG_DIR      # Config directory (~/.config/vyn)
$VYN_PLUGIN_DIR      # Plugin install directory
$VYN_ANALYTICS_FILE  # Analytics data file (if enabled)
```

---

## Examples

### Simple Plugin: File Size Reporter

```bash
#!/usr/bin/env bash

main() {
    local input="${1:-}"
    [[ -z "$input" ]] && echo "Usage: vyn --plugin size-reporter <video>" && return 1
    [[ ! -f "$input" ]] && echo "File not found" && return 1
    
    local size=$(du -h "$input" | cut -f1)
    echo "File size: $size"
}

main "$@"
```

### Advanced Plugin: Multi-format Converter

```bash
#!/usr/bin/env bash

convert_formats() {
    local input="${1}"
    local base="${input%.*}"
    
    # Convert to multiple formats
    for format in mp4 webm mkv; do
        echo "Converting to $format..."
        ffmpeg -i "$input" -c:v libx264 -crf 23 "${base}.${format}" -y 2>/dev/null
    done
    
    echo "Created: ${base}.{mp4,webm,mkv}"
}

main() {
    [[ -z "${1:-}" ]] && echo "Usage: vyn --plugin multi-format <video>" && return 1
    convert_formats "$1"
}

main "$@"
```

---

## Resources

- **Bash Guide**: https://mywiki.wooledge.org/BashGuide
- **ShellCheck**: https://www.shellcheck.net/
- **FFmpeg Docs**: https://ffmpeg.org/documentation.html
- **jq Manual**: https://jqlang.github.io/jq/manual/

---

## Community Plugins

Share your plugins with the community! Submit to:

- **GitHub**: https://github.com/samonide/vyn
- **Discussions**: Plugin showcase and ideas
- **Pull Requests**: Official plugin submissions

---

*For general contribution guidelines, see [Contributing.md](Contributing.md)*
