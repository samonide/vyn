# Vyn Architecture

Technical overview of Vyn's codebase and architecture.

## Project Structure

```
vyn/
├── bin/                    # Executable scripts
│   └── vyn                 # Main application script
│
├── src/                    # Source modules (future modularization)
│   ├── core.sh            # Core conversion logic
│   ├── presets.sh         # Professional presets
│   ├── plugins.sh         # Plugin system
│   ├── analytics.sh       # Analytics tracking
│   └── utils.sh           # Utility functions
│
├── plugins/                # Plugin repository
│   ├── README.md          # Plugin documentation
│   ├── vimeo-uploader.sh  # Vimeo upload plugin
│   ├── vimeo-uploader.md  # Plugin documentation
│   ├── quality-analyzer.sh # Quality analysis plugin
│   └── quality-analyzer.md # Plugin documentation
│
├── docs/                   # Documentation
│   ├── Usage.md           # Complete usage guide
│   ├── Plugins.md         # Plugin development guide
│   ├── Contributing.md    # Contribution guidelines
│   └── Architecture.md    # This file
│
├── config/                 # Configuration templates
│   └── default.conf       # Default configuration template
│
├── tests/                  # Test suite
│   ├── run_tests.sh       # Test runner
│   └── fixtures/          # Test fixtures
│
├── README.md              # Project overview (compact)
├── CHANGELOG.md           # Version history
├── LICENSE                # Unlicense (Public Domain)
├── package.json           # Project metadata
├── plugins.json           # Plugin manifest
├── install-vyn.sh         # Installation script
└── .gitignore             # Git ignore patterns
```

## Architecture Overview

### Core Components

#### 1. Main Script (`bin/vyn`)

The main executable that orchestrates all functionality:

- **Argument parsing** - Command-line option handling
- **Mode selection** - Interactive vs automatic
- **Operation dispatch** - Route to appropriate functions
- **Error handling** - Graceful failure and cleanup
- **User interface** - Interactive prompts and output

#### 2. Conversion Engine

FFmpeg-based video processing:

- **Remux mode** - Container-only changes (fast)
- **Encode mode** - Full re-encoding with quality control
- **GPU acceleration** - Hardware encoding support
- **Format detection** - Automatic codec selection
- **Progress tracking** - Real-time feedback

#### 3. Preset System

Professional workflow presets:

- **Broadcast** - TV/Broadcasting quality
- **Cinema** - Film industry standards
- **Web** - Streaming optimization
- **Mobile** - Mobile device optimization
- **Archive** - Maximum quality preservation
- **Social** - Social media formats

#### 4. Plugin System

Extensible architecture for additional features:

- **Plugin discovery** - Automatic plugin detection
- **Plugin installation** - Repository-based installation
- **Plugin execution** - Isolated plugin environment
- **Dependency checking** - Requirement validation
- **Error isolation** - Plugin failures don't crash core

#### 5. Analytics System

Performance tracking and optimization:

- **Metrics collection** - Conversion statistics
- **JSON storage** - Structured data format
- **Historical tracking** - Long-term trends
- **Performance insights** - Optimization recommendations

### Data Flow

```
User Input
    ↓
Argument Parsing
    ↓
[Interactive Mode] ← → [Automatic Mode]
    ↓
Validation & Setup
    ↓
[Remux] ← Mode Selection → [Encode]
    ↓                          ↓
Container Change          Quality Control
    ↓                          ↓
GPU Acceleration Check ←───────┘
    ↓
FFmpeg Execution
    ↓
Progress Tracking
    ↓
[Analytics Collection]
    ↓
Post-processing
    ↓
Output Validation
    ↓
Success/Error Report
```

### Key Design Patterns

#### 1. Function-Based Architecture

```bash
# Modular functions for each feature
function convert_video() { }
function setup_presets() { }
function execute_plugin() { }
function track_analytics() { }
```

#### 2. Configuration Management

```bash
# User configuration
~/.config/vyn/
├── config.conf          # Main configuration
├── vimeo.conf           # Plugin configs
├── analytics.json       # Analytics data
└── plugins/             # Installed plugins
```

#### 3. Plugin Architecture

```bash
# Plugin interface
plugin_script "$input" "$options"
    → Process
    → Return status code
    → Output results
```

#### 4. Error Handling

```bash
# Graceful error handling
set -euo pipefail           # Strict mode
trap cleanup EXIT           # Cleanup on exit
validate_input || return 1  # Input validation
```

### Technology Stack

- **Language**: Bash 4.0+
- **Core Engine**: FFmpeg
- **JSON Processing**: jq
- **Package Manager**: Multiple (apt, pacman, brew, etc.)
- **Platform Support**: Linux, macOS, Windows (WSL)

### Dependencies

**Required:**
- FFmpeg - Video processing
- Bash 4.0+ - Shell environment

**Optional:**
- jq - JSON processing for plugins
- curl - Plugin downloads and updates
- GPU drivers - Hardware acceleration

### Performance Considerations

#### CPU Encoding
- Quality: Highest
- Speed: Slower (baseline)
- Use case: Maximum quality needs

#### GPU Encoding
- Quality: Very high (slightly reduced)
- Speed: 3-5x faster than CPU
- Use case: Batch processing, large files

#### Remux Mode
- Quality: No change (copy only)
- Speed: 10-100x faster (seconds)
- Use case: Container format changes

### Security

- **Input validation** - All user inputs sanitized
- **Safe command execution** - No eval or injection
- **API key storage** - Secure configuration files
- **Permission checks** - Validate before writing
- **HTTPS only** - Secure network connections

### Future Architecture Plans

#### Modularization (v1.5.0)
Split monolithic script into focused modules:
- `src/core.sh` - Core logic
- `src/presets.sh` - Preset management
- `src/plugins.sh` - Plugin system
- `src/analytics.sh` - Analytics
- `src/utils.sh` - Helper functions

#### Plugin API (v2.0.0)
Formal plugin API with:
- Standard interfaces
- Event hooks
- Shared utilities
- Better isolation

#### Web Interface (v2.0.0)
Optional web UI for:
- Visual conversion management
- Batch queue management
- Analytics dashboard
- Remote processing

## Development Guidelines

### Code Organization

#### Function Naming
```bash
# Public functions - descriptive names
convert_video_file()
setup_professional_presets()
execute_plugin_system()

# Private functions - underscore prefix
_validate_input()
_format_output()
_internal_helper()
```

#### Variable Naming
```bash
# Constants - uppercase
readonly VERSION="1.4.0"
readonly SCRIPT_DIR="/path"

# Globals - descriptive
declare -g USE_GPU=false
declare -g OPERATION_MODE=""

# Locals - lowercase
local input_file="video.mkv"
local crf_value=23
```

#### Error Handling
```bash
# Always check command success
if ! ffmpeg -i "$input" "$output"; then
    log_error "Conversion failed"
    return 1
fi

# Validate inputs
[[ -f "$input" ]] || {
    log_error "File not found: $input"
    return 1
}

# Use trap for cleanup
cleanup() {
    rm -f /tmp/vyn_temp_*
}
trap cleanup EXIT
```

### Testing Strategy

#### Unit Tests
Test individual functions:
```bash
test_video_detection()
test_preset_application()
test_plugin_execution()
```

#### Integration Tests
Test complete workflows:
```bash
test_basic_conversion()
test_batch_processing()
test_gpu_acceleration()
```

#### Edge Cases
Test error conditions:
```bash
test_missing_input()
test_invalid_options()
test_insufficient_space()
```

### Performance Optimization

#### Minimize FFmpeg Invocations
```bash
# Bad: Multiple probes
duration=$(ffprobe -show_format "$input" | grep duration)
codec=$(ffprobe -show_streams "$input" | grep codec)

# Good: Single probe
metadata=$(ffprobe -show_format -show_streams "$input")
duration=$(echo "$metadata" | grep duration)
codec=$(echo "$metadata" | grep codec)
```

#### Efficient Loops
```bash
# Bad: Subprocess per iteration
for file in *.mkv; do
    echo "$file" | sed 's/.mkv/.mp4/'
done

# Good: Bash string manipulation
for file in *.mkv; do
    echo "${file%.mkv}.mp4"
done
```

#### Parallel Processing
```bash
# Process multiple files in parallel
for video in *.mkv; do
    vyn --preset web "$video" "${video%.mkv}.mp4" &
done
wait
```

## Extension Points

### Adding New Presets

1. Add preset configuration
2. Update preset selection menu
3. Add documentation
4. Test preset thoroughly

### Creating New Plugins

1. Follow plugin template
2. Add to plugins.json
3. Create documentation
4. Submit pull request

### Adding New Features

1. Design function interface
2. Implement core logic
3. Add error handling
4. Update documentation
5. Add tests

## Debugging

### Enable Verbose Mode
```bash
# Add debug output
set -x  # Print commands

# Custom debug function
debug() {
    [[ "$DEBUG" == "true" ]] && echo "[DEBUG] $*" >&2
}

# Usage
DEBUG=true vyn input.mkv output.mp4
```

### Common Debug Points
- Input validation
- FFmpeg command construction
- Plugin execution
- Configuration loading
- Error handling paths

## Resources

- **Bash Guide**: https://mywiki.wooledge.org/BashGuide
- **FFmpeg Documentation**: https://ffmpeg.org/documentation.html
- **ShellCheck**: https://www.shellcheck.net/
- **Best Practices**: https://github.com/progrium/bashstyle

---

*For contribution guidelines, see [Contributing.md](Contributing.md)*
