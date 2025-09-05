# Vyn Plugin System

A comprehensive plugin management system for seamless extension of vyn's functionality.

## Overview

The plugin system allows you to:
- **Install** plugins from the official repository
- **Remove** installed plugins 
- **List** available and installed plugins
- **Execute** plugins with streamlined workflows

## Quick Start

```bash
# See what plugins are available
vyn --add-plugins

# List installed plugins  
vyn --list-plugins

# Use a plugin
vyn --plugin vimeo-uploader /path/to/videos/

# Remove plugins
vyn --remove-plugins
```

## Available Commands

| Command | Description |
|---------|-------------|
| `--add-plugins` | Interactive plugin installation from repository |
| `--list-plugins` | Show all installed plugins |
| `--remove-plugins` | Interactive plugin removal |
| `--plugin <name> <path>` | Execute a specific plugin |

## Plugin Repository

Plugins are managed through `plugins.json` which contains:

- **Plugin metadata** (name, version, description)
- **Installation instructions**
- **Requirements and dependencies**
- **Usage examples**
- **Setup requirements**

## Directory Structure

```
vyn/
├── plugins.json           # Plugin repository manifest
├── plugins/              # Plugin source files
│   ├── vimeo-uploader.sh # Vimeo upload plugin
│   └── vimeo-uploader.md # Plugin documentation
└── vyn                   # Main vyn executable

~/.config/vyn/plugins/    # Installed plugins directory
├── vimeo-uploader.sh     # Installed plugins
└── example.sh
```

## Available Plugins

### 🎬 Vimeo Uploader
- **ID**: `vimeo-uploader`
- **Version**: 1.4.0
- **Category**: Upload
- **Description**: Upload video folders to Vimeo and create playlist links

**Features**:
- Folder-based batch uploads
- Automatic playlist creation
- Link generation (links.txt)
- Multi-format support
- Progress tracking
- One-time token setup

**Usage**:
```bash
vyn --plugin vimeo-uploader /path/to/videos/folder/
```

**Setup**: Requires Vimeo Personal Access Token
1. Go to https://developer.vimeo.com/apps
2. Create new app
3. Generate Personal Access Token with scopes:
   - Upload videos
   - Create/edit albums
   - Private access to your account

## Plugin Development

### Plugin Structure

Each plugin must have:

```bash
#!/bin/bash
# Plugin metadata
plugin_name="Your Plugin Name"
plugin_version="1.0.0"
plugin_description="What your plugin does"

# Required function
execute_plugin() {
    local input_path="$1"
    local output_path="$2"
    
    # Your plugin logic here
    return 0
}

# Optional validation function
validate_plugin() {
    # Check requirements
    return 0
}
```

### Adding to Repository

To add a plugin to the repository:

1. Create plugin file in `plugins/` directory
2. Add entry to `plugins.json`:

```json
{
  "id": "your-plugin",
  "name": "Your Plugin Name", 
  "version": "1.0.0",
  "description": "Plugin description",
  "file": "your-plugin.sh",
  "category": "Upload|Conversion|Utility",
  "requirements": {
    "commands": ["required", "commands"],
    "api": "API requirements if any"
  },
  "setup": {
    "required": true|false,
    "description": "Setup description",
    "instructions": ["Step 1", "Step 2"]
  }
}
```

### Plugin Categories

- **Upload**: Services for uploading videos (Vimeo, YouTube, etc.)
- **Conversion**: Specialized video conversion tasks  
- **Utility**: Helper tools and utilities

## Examples

### Installing the Vimeo Plugin

```bash
$ vyn --add-plugins

🔌 Plugin Installation
==============================

📦 Available Plugins (Repository)

1) Vimeo Uploader (v1.4.0) [Upload]
   📝 Upload video folders to Vimeo and create playlist links
   📊 Status: Not Installed

Enter plugin number to install (or 'q' to quit): 1
✅ Plugin 'Vimeo Uploader' installed successfully

⚙️  Setup Required
Requires Vimeo API access token
   1. Go to https://developer.vimeo.com/apps
   2. Create a new app
   3. Generate access token with 'upload' and 'create' scopes
   4. Token will be requested on first use
```

### Using the Vimeo Plugin

```bash
$ vyn --plugin vimeo-uploader myvids/january/

🎬 Vimeo Folder Uploader
========================
📁 Processing folder: myvids/january/

🎬 Vimeo Uploader Configuration
================================
# (First time setup - requests token)

🔍 Testing Vimeo API connection...
✅ Connected to Vimeo as: Your Name

📹 Found 5 video file(s)

📁 Creating Vimeo folder: january
✅ Folder created with ID: 12345

⬆️  Uploading: video1.mp4
✅ Upload complete: https://vimeo.com/987654321

# ... continues for all videos

🎉 Upload Summary
=================
✅ Successfully uploaded: 5/5 videos
📋 Links saved to: myvids/january/links.txt
🔗 Playlist URL: https://vimeo.com/album/12345
```

### Generated Links File

```
🔗 Playlist URL: https://vimeo.com/album/12345

Individual video links:
======================
video1: https://vimeo.com/987654321
video2: https://vimeo.com/987654322
video3: https://vimeo.com/987654323
video4: https://vimeo.com/987654324
video5: https://vimeo.com/987654325
```

## Benefits

### For Users
- **Seamless integration** - Plugins work natively with vyn
- **One-time setup** - Configuration saved permanently
- **Interactive installation** - Easy plugin management
- **Consistent interface** - All plugins use same command structure

### For Developers  
- **Modular architecture** - Clean separation of concerns
- **Extensible design** - Easy to add new services
- **Standard interface** - Consistent plugin API
- **Rich metadata** - Comprehensive plugin information

## Future Plugins

Potential additions to the plugin ecosystem:

- **YouTube Uploader** - Batch upload to YouTube
- **Google Drive** - Upload with shareable links
- **Dropbox** - Cloud storage integration
- **Thumbnail Generator** - Auto-extract video thumbnails
- **Subtitle Tools** - Generate/embed subtitles
- **Metadata Editor** - Batch edit video metadata
- **Format Converter** - Specialized conversion workflows

## Technical Notes

- Plugins run in the same environment as vyn
- Directory-based plugins skip standard vyn workflow
- Configuration stored in `~/.config/vyn/`
- Plugin isolation prevents conflicts
- JSON manifest enables rich metadata
- Automatic dependency checking
- Graceful error handling

The plugin system transforms vyn from a simple converter into a comprehensive video workflow platform while maintaining its clean, focused core functionality.
