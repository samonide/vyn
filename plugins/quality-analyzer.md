# Quality Analyzer Plugin

Analyze video quality metrics and generate comprehensive optimization reports for your video files.

## Overview

The Quality Analyzer plugin provides detailed analysis of video files including quality metrics, compression efficiency, and optimization suggestions. It supports both single file analysis and batch folder processing.

## Features

- **Comprehensive Quality Metrics**: Resolution, bitrate, codec analysis, frame rate
- **Quality Scoring**: 0-100 quality score based on industry standards
- **Compression Efficiency**: Assessment of encoding efficiency
- **Optimization Suggestions**: Specific recommendations for improving video quality/size
- **Batch Processing**: Analyze entire folders of videos
- **Detailed Reports**: Generated in easy-to-read text format
- **vyn Integration**: Provides specific vyn commands for optimization

## Requirements

- `ffprobe` (included with FFmpeg)
- `bc` (calculator package)
- `jq` (JSON processor, optional but recommended)

### Installing Requirements

**Ubuntu/Debian:**
```bash
sudo apt install bc
```

**macOS:**
```bash
brew install bc
```

**CentOS/RHEL:**
```bash
sudo yum install bc
```

## Usage

### Analyze Single Video File
```bash
vyn --plugin quality-analyzer /path/to/video.mp4
```

### Analyze Folder of Videos
```bash
vyn --plugin quality-analyzer /path/to/video/folder
```

### Installation via Plugin Manager
```bash
# Install the plugin
vyn --add-plugins quality-analyzer

# List installed plugins to verify
vyn --list-plugins

# Use the plugin
vyn --plugin quality-analyzer ~/Videos/
```

## Analysis Metrics

### Video Quality Metrics
- **Resolution**: Width x Height analysis
- **Codec**: Video codec type and efficiency
- **Bitrate**: Data rate in Mbps
- **Frame Rate**: Frames per second
- **Pixel Format**: Color space information
- **Profile/Level**: Codec profile details

### Quality Assessment
- **Quality Score**: 0-100 rating based on multiple factors
- **Compression Efficiency**: Rating from Poor to Excellent
- **Bitrate per Pixel**: Compression density analysis
- **File Size Analysis**: Storage efficiency evaluation

### Scoring System
- **90-100**: Excellent quality
- **80-89**: Very Good quality  
- **70-79**: Good quality
- **60-69**: Fair quality
- **Below 60**: Poor quality (needs optimization)

## Output Reports

### Individual Video Reports
Each video gets a detailed analysis report containing:
- Basic file information
- Video quality metrics
- Quality assessment and scoring
- Specific optimization suggestions
- Recommended vyn commands

### Folder Summary Report
When analyzing folders, you get:
- Overall statistics for all videos
- Average quality scores
- Batch optimization recommendations
- List of individual reports generated

## Optimization Suggestions

The plugin provides specific recommendations based on analysis:

### Codec Recommendations
- Upgrade to HEVC (H.265) for better compression
- Consider AV1 for future-proof encoding
- Optimize encoder settings for target quality

### Bitrate Optimization
- **4K Videos**: 15-25 Mbps recommended
- **1080p Videos**: 8-12 Mbps recommended  
- **720p Videos**: 4-6 Mbps recommended
- **480p Videos**: 2-4 Mbps recommended

### Quality Improvements
- Two-pass encoding for better compression
- Profile and level optimization
- Frame rate optimization suggestions

## Example Output

```
📊 Quality Analysis Report
==========================
📄 File: sample_video.mp4
📅 Date: 2024-01-15 10:30:00

📋 Basic Information:
-------------------
Format: mp4
Duration: 120.50s
File Size: 45.2MB

🎬 Video Quality Metrics:
------------------------
Resolution: 1920x1080
Codec: h264
Profile: High
Pixel Format: yuv420p
Frame Rate: 29.97 fps
Bitrate: 3.2Mbps
Bitrate per Pixel: 0.001562 bpp

🎯 Quality Assessment:
---------------------
Overall Quality Score: 72/100
Quality Rating: Good
Compression Efficiency: Good

💡 Optimization Suggestions:
=============================
🎯 Consider upgrading to HEVC (H.265) for better compression efficiency
📉 Could increase bitrate to 5-8Mbps for better 1080p quality

🎛️  Recommended vyn commands:
----------------------------
vyn input.mp4 output.mp4 --preset broadcast  # Professional quality
vyn input.mp4 output.mp4 --video-codec hevc  # Better compression
```

## Integration with vyn

The Quality Analyzer seamlessly integrates with vyn's plugin system:

1. **Plugin Detection**: Automatically detected when installed in `~/.config/vyn/plugins/`
2. **Folder Processing**: Works with vyn's folder input system
3. **Command Generation**: Provides specific vyn commands for optimization
4. **Batch Workflow**: Complements vyn's batch processing capabilities

## Advanced Usage

### Custom Analysis Scripts
The plugin can be called directly for custom workflows:
```bash
# Direct plugin execution
./plugins/quality-analyzer.sh /path/to/videos/

# Integration in shell scripts
source ~/.config/vyn/plugins/quality-analyzer.sh
analyze_folder_quality "/path/to/videos"
```

### Report Processing
Quality reports are saved as plain text files and can be processed with standard tools:
```bash
# Search for low-quality videos
grep -l "Quality Score: [0-5][0-9]" quality_reports/*.txt

# Find videos needing codec upgrades
grep -l "Consider upgrading to HEVC" quality_reports/*.txt

# Extract average quality scores
grep "Average Quality Score" quality_reports/summary_report.txt
```

## Troubleshooting

### Common Issues

**"ffprobe command not found"**
- Install FFmpeg: `sudo apt install ffmpeg` (Ubuntu) or `brew install ffmpeg` (macOS)

**"bc command not found"**  
- Install calculator package: `sudo apt install bc` (Ubuntu) or `brew install bc` (macOS)

**"No video files found"**
- Ensure folder contains supported video formats (mp4, avi, mov, mkv, webm, flv, wmv, m4v, 3gp, ts)
- Check file permissions and accessibility

**Analysis fails for specific videos**
- Video file may be corrupted
- Unsupported codec or container format
- Check ffprobe compatibility: `ffprobe -i video.mp4`

### Performance Notes

- Analysis time scales with video file size and duration
- Large folders may take several minutes to process
- Reports are generated incrementally for progress tracking
- Plugin uses temporary files which are automatically cleaned up

## Contributing

To contribute improvements to the Quality Analyzer plugin:

1. Fork the repository
2. Create a feature branch
3. Make your changes to `plugins/quality-analyzer.sh`
4. Update this documentation if needed
5. Submit a pull request

## License

This plugin is part of the vyn project and follows the same license terms.
