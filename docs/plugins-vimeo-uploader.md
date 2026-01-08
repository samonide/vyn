# Vimeo Uploader Plugin for Vyn v1.4.0

A powerful plugin that allows you to upload entire video folders to Vimeo and automatically create playlists with downloadable link files.

## Features

🎬 **Folder Upload**: Upload entire directories containing video files  
📁 **Auto Playlist**: Creates Vimeo albums (playlists) for each folder  
🔗 **Link Generation**: Generates `links.txt` file with all video and playlist URLs  
📹 **Multi-Format Support**: Supports MP4, AVI, MOV, MKV, WebM, FLV, WMV  
⚡ **Progress Tracking**: Real-time upload progress and status  

## Setup

### 1. Install Dependencies

```bash
# Ubuntu/Debian
sudo apt install curl jq

# macOS
brew install curl jq
```

### 2. Get Vimeo API Access

1. Go to [Vimeo Developer Apps](https://developer.vimeo.com/apps)
2. Create a new app
3. Generate an access token with these scopes:
   - `upload` - Upload videos
   - `create` - Create albums/playlists
   - `edit` - Edit video details

### 3. Configure Plugin

The plugin will prompt you for your access token on first use. Alternatively, you can manually create the config file:

```bash
mkdir -p ~/.config/vyn
cat > ~/.config/vyn/vimeo.conf << EOF
VIMEO_ACCESS_TOKEN="your_access_token_here"
EOF
```

## Usage

### Upload a Video Folder

```bash
# Upload all videos in myvids/january/ to Vimeo
vyn --plugin vimeo-uploader myvids/january/

# Upload all videos in myvids/february/ to Vimeo  
vyn --plugin vimeo-uploader myvids/february/
```

### Folder Structure Example

```
myvids/
├── january/
│   ├── vacation.mp4
│   ├── birthday.mov
│   └── links.txt          # Generated after upload
└── february/
    ├── skiing.mp4
    ├── valentine.avi
    └── links.txt          # Generated after upload
```

### Generated Links File

After upload, each folder will contain a `links.txt` file:

```
🔗 Playlist URL: https://vimeo.com/album/123456789

Individual video links:
======================
vacation: https://vimeo.com/987654321
birthday: https://vimeo.com/987654322
```

## How It Works

1. **Scan Folder**: Finds all video files in the specified directory
2. **Create Album**: Creates a Vimeo album (playlist) with the folder name
3. **Upload Videos**: Uploads each video file using Vimeo's TUS protocol
4. **Generate Links**: Creates `links.txt` with playlist and individual video URLs
5. **Progress Report**: Shows upload status and summary

## Supported Video Formats

- MP4 (recommended)
- AVI
- MOV
- MKV
- WebM
- FLV
- WMV

## Configuration File

The plugin stores configuration in `~/.config/vyn/vimeo.conf`:

```bash
# Vimeo Configuration for Vyn
VIMEO_ACCESS_TOKEN="your_token_here"
```

## Error Handling

- **Missing Dependencies**: Checks for curl and jq
- **Invalid Token**: Validates API access before upload
- **Network Issues**: Graceful handling of upload failures
- **File Permissions**: Ensures proper access to video files

## Tips

- **Large Files**: Vimeo has upload limits based on your account type
- **Batch Processing**: Process folders separately for better organization
- **Backup Links**: The `links.txt` file serves as a backup of all URLs
- **Privacy Settings**: Videos inherit your Vimeo account's default privacy settings

## Troubleshooting

### "curl not found"
```bash
sudo apt install curl  # Ubuntu/Debian
brew install curl      # macOS
```

### "jq not found" 
```bash
sudo apt install jq    # Ubuntu/Debian
brew install jq        # macOS
```

### "Failed to connect to Vimeo API"
- Check your access token
- Verify token has required scopes
- Check internet connection

### "Upload failed"
- Check file permissions
- Verify video file is not corrupted
- Check Vimeo upload limits for your account

## Example Workflow

```bash
# 1. Organize your videos
mkdir -p myvids/{january,february,march}
# Add your video files to these directories

# 2. Upload each month's videos
vyn --plugin vimeo-uploader myvids/january/
vyn --plugin vimeo-uploader myvids/february/
vyn --plugin vimeo-uploader myvids/march/

# 3. Check the generated links
cat myvids/january/links.txt
cat myvids/february/links.txt
cat myvids/march/links.txt
```

## Version History

- **v1.4.0**: Initial release with folder upload and playlist generation
