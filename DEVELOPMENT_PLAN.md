# Vyn v1.4.0 Development Plan

## Current Status ✅
- [x] Created next-dev branch
- [x] Updated version to 1.4.0-dev
- [x] Verified all existing arguments work properly
- [x] Created argument testing script

## Completed: Vimeo Integration via Plugin System ✅

### 1. Vimeo Upload Features - COMPLETED AS PLUGIN
- [x] ✅ **Plugin-based approach**: Implemented as `vimeo-uploader` plugin
- [x] ✅ **Vimeo API integration**: Full API v3.4 integration with TUS uploads
- [x] ✅ **Folder-based uploads**: Support for entire directory uploads (myvids/january/, myvids/february/)
- [x] ✅ **Automatic playlist creation**: Creates Vimeo albums for each folder
- [x] ✅ **Links.txt generation**: Generates comprehensive link files
- [x] ✅ **Progress tracking**: Real-time upload progress and status
- [x] ✅ **Error handling**: Comprehensive error checking and recovery
- [x] ✅ **Multi-format support**: MP4, AVI, MOV, MKV, WebM, FLV, WMV
- [x] ✅ **Configuration management**: Secure token storage and validation

### 2. Plugin Usage (Replaces Direct Integration)
```bash
# List available plugins
vyn --list-plugins

# Upload entire folder to Vimeo with auto-playlist creation
vyn --plugin vimeo-uploader myvids/january/
vyn --plugin vimeo-uploader myvids/february/

# Plugin handles everything:
# - Creates Vimeo album (playlist) for the folder
# - Uploads all videos in the folder
# - Generates links.txt with playlist and individual video URLs
```

### 3. Plugin Architecture Benefits ✅
- **Modular Design**: Vimeo functionality is completely separate from core vyn
- **Clean Core**: No bloat in the main vyn script
- **Extensible**: Easy to add more upload service plugins (YouTube, etc.)
- **Optional**: Users only install/use what they need
- **Maintainable**: Plugin code is isolated and easier to update

### 4. Actual Usage Examples (Working Now!)
```bash
# Upload entire folder structure to Vimeo
vyn --plugin vimeo-uploader myvids/january/
vyn --plugin vimeo-uploader myvids/february/

# The plugin automatically:
# 1. Creates a Vimeo album named "january" or "february"
# 2. Uploads all videos in the folder to that album
# 3. Generates links.txt with playlist URL and individual video URLs
# 4. Provides progress tracking and error handling
```

### 5. Fun Feature Ideas 🚀
- [ ] **Smart batch conversion + upload**: Convert unsupported formats and upload
- [ ] **Progress dashboard**: Real-time progress for multiple uploads
- [ ] **Thumbnail extraction**: Auto-generate thumbnails from videos
- [ ] **Duplicate detection**: Avoid uploading same video twice
- [ ] **Upload scheduling**: Queue uploads for later
- [ ] **Bandwidth management**: Limit upload speed
- [ ] **Auto-retry**: Retry failed uploads with exponential backoff
- [ ] **Webhook notifications**: Notify when uploads complete
- [ ] **Metadata extraction**: Auto-fill titles/descriptions from file metadata
- [ ] **Subtitle upload**: Upload SRT files as captions
- [ ] **Chapter markers**: Add chapter information to videos
- [ ] **Custom thumbnails**: Upload custom thumbnail images
- [ ] **Video tags**: Auto-tag videos based on content/filename
- [ ] **Upload templates**: Save common upload configurations
- [ ] **Compression optimization**: Optimize videos for streaming before upload

### 6. Technical Requirements
- Vimeo API access token
- curl or httpie for API requests
- JSON parsing (jq)
- Progress tracking
- Error handling and retries
- Concurrent upload support

### 7. File Structure for Folder Upload
```
myvids/
├── january/
│   ├── video1.mp4
│   ├── video2.mkv
│   └── video3.avi
├── february/
│   ├── video4.mp4
│   └── video5.mov
└── links.txt (generated)
```

### 8. Generated Links.txt Format ✅ (Implemented)
```
🔗 Playlist URL: https://vimeo.com/album/123456789

Individual video links:
======================
video1: https://vimeo.com/987654321
video2: https://vimeo.com/987654322
video3: https://vimeo.com/987654323
```

## Next Development Priorities

### Phase 1: Core Testing and Validation 🔧
- [ ] Complete argument validation testing with test-arguments.sh
- [ ] Test all existing vyn functions thoroughly  
- [ ] Fix any discovered issues
- [ ] Improve error messages and help text

### Phase 2: Additional Upload Service Plugins 🌐
- [ ] **YouTube Plugin**: Similar to Vimeo but for YouTube
- [ ] **Google Drive Plugin**: Upload to Google Drive with sharing links
- [ ] **Dropbox Plugin**: Upload to Dropbox with public links
- [ ] **AWS S3 Plugin**: Upload to S3 buckets with CDN links

### Phase 3: Enhanced Features 🚀
