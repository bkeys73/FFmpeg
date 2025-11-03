# FFmpeg Video Expert - Claude Skill

A comprehensive Claude Code skill that transforms Claude into an expert FFmpeg video engineer, specializing in creating professional videos with advanced transitions, effects, and compositions.

## Features

- **48+ Transition Types**: Mastery of all xfade transitions including fades, wipes, slides, shapes, and custom expressions
- **40+ Blend Modes**: Advanced compositing with mathematical blend modes
- **Expression Language**: Dynamic effects using FFmpeg's powerful expression system
- **Complex Filter Chains**: Multi-input processing, overlay composition, and stream routing
- **GPU Acceleration**: Knowledge of CUDA, Vulkan, OpenCL implementations
- **Production-Ready**: Complete commands with encoding, audio handling, and quality optimization
- **Practical Examples**: Common workflows for montages, slideshows, split-screens, and more

## Installation

### Option 1: Install in Claude Code Skills Directory

1. **Locate your Claude Code skills directory:**
   ```bash
   # On macOS/Linux
   ~/.config/claude/skills/

   # On Windows
   %APPDATA%\claude\skills\
   ```

2. **Create the directory if it doesn't exist:**
   ```bash
   mkdir -p ~/.config/claude/skills/
   ```

3. **Copy the skill file:**
   ```bash
   cp claude-skills/ffmpeg-video-expert.md ~/.config/claude/skills/
   ```

4. **Restart Claude Code** (if running)

### Option 2: Install from this Repository

1. **Clone this repository:**
   ```bash
   git clone https://github.com/bkeys73/FFmpeg.git
   cd FFmpeg
   ```

2. **Copy the skill to your Claude Code skills directory:**
   ```bash
   # macOS/Linux
   cp claude-skills/ffmpeg-video-expert.md ~/.config/claude/skills/

   # Windows (PowerShell)
   Copy-Item claude-skills\ffmpeg-video-expert.md $env:APPDATA\claude\skills\
   ```

3. **Restart Claude Code**

### Option 3: Manual Installation

1. Download `ffmpeg-video-expert.md` from this repository
2. Navigate to your Claude Code skills directory
3. Place the file in the skills directory
4. Restart Claude Code

## Usage

Once installed, you can activate this skill in Claude Code by typing:

```
/skill ffmpeg-video-expert
```

Or simply ask Claude about FFmpeg video tasks, and the skill will be automatically activated when appropriate.

### Example Interactions

**Create a simple video montage:**
```
User: I need to create a video montage from 3 clips with smooth transitions

Claude: I'll help you create a montage with smooth transitions. First, let me know:
1. What are the durations of your clips?
2. What transition style would you prefer? (fade, dissolve, wipe, etc.)
3. What transition duration? (typically 1-2 seconds)
...
```

**Advanced custom transition:**
```
User: I want a circular reveal transition that starts from the center

Claude: I'll create a custom circular reveal using the xfade filter's expression mode:

ffmpeg -i video1.mp4 -i video2.mp4 -filter_complex "
[0:v][1:v]xfade=transition=custom:duration=2:offset=5:
expr='if(hypot(X-W/2,Y-H/2)<W*P/2,B,A)'
[v]
" -map "[v]" -c:v libx264 -crf 20 output.mp4
...
```

**Picture-in-picture effect:**
```
User: How do I add a small video overlay in the corner?

Claude: I'll create a picture-in-picture effect with the overlay filter...
```

## What This Skill Covers

### Transitions
- Crossfades (fade, fadeblack, fadewhite)
- Wipes (left, right, up, down, diagonal)
- Slides (directional movement)
- Shape-based (circle, rectangle)
- Directional (smooth, slice, wind)
- Cover/Reveal effects
- Custom expression-based transitions

### Compositions
- Multi-video layouts (split-screen, grid, tiles)
- Overlay and picture-in-picture
- Animated overlays with expressions
- Frame synchronization

### Effects
- Blend modes (40+ types)
- Fade in/out
- Ken Burns (zoom/pan)
- Custom effects via expressions

### Advanced Topics
- Complex filter chains
- GPU hardware acceleration
- Audio crossfading
- Quality optimization
- Performance tuning

## Requirements

This skill provides guidance for using FFmpeg. You need FFmpeg installed on your system:

### Install FFmpeg

**macOS:**
```bash
brew install ffmpeg
```

**Ubuntu/Debian:**
```bash
sudo apt update
sudo apt install ffmpeg
```

**Windows:**
- Download from [ffmpeg.org](https://ffmpeg.org/download.html)
- Or use: `choco install ffmpeg` (with Chocolatey)
- Or use: `winget install ffmpeg` (Windows 10+)

### Verify Installation
```bash
ffmpeg -version
```

## Examples Directory

The `examples/` directory contains practical, ready-to-use FFmpeg commands for common scenarios:

- `simple-montage.sh` - Basic multi-clip video with transitions
- `slideshow.sh` - Image slideshow with Ken Burns effect
- `split-screen.sh` - Side-by-side video comparison
- `pip.sh` - Picture-in-picture overlay
- `custom-transitions.sh` - Advanced custom transition examples
- `gpu-accelerated.sh` - Hardware-accelerated processing

## Skill Capabilities

When you activate this skill, Claude becomes an expert in:

1. **Understanding your requirements** - Asks clarifying questions about inputs, outputs, and desired effects
2. **Providing complete solutions** - Full FFmpeg commands, not just fragments
3. **Explaining the approach** - Breaks down complex filter chains
4. **Optimizing for quality** - Suggests appropriate encoding settings
5. **Troubleshooting** - Helps debug errors and performance issues
6. **Iterating on solutions** - Adjusts based on your feedback

## Tips for Best Results

1. **Provide input details**: Number of clips, durations, resolutions
2. **Specify transition preferences**: Type, duration, timing
3. **Mention output requirements**: Resolution, codec, file size constraints
4. **Test with short clips first**: Verify before processing full videos
5. **Ask for explanations**: Claude will explain any part of the command

## Troubleshooting

**Skill not loading?**
- Ensure the file is in the correct skills directory
- Check that the file is named correctly: `ffmpeg-video-expert.md`
- Restart Claude Code
- Verify file permissions (should be readable)

**FFmpeg errors?**
- Make sure FFmpeg is installed: `ffmpeg -version`
- Check input file paths are correct
- Verify sufficient disk space for output
- Review error messages - Claude can help debug

## Advanced Usage

### Combine with Other Skills
This skill works well alongside:
- File management skills
- Batch processing skills
- Automation/scripting skills

### Custom Modifications
You can modify the skill file to:
- Add your preferred encoding defaults
- Include company-specific presets
- Add custom transition templates
- Include project-specific workflows

## Contributing

Found an issue or want to improve this skill?
- Report issues on GitHub
- Submit pull requests with improvements
- Share your custom transition expressions

## License

This skill is based on FFmpeg documentation and is provided as-is for use with Claude Code.

## Resources

- [FFmpeg Official Documentation](https://ffmpeg.org/documentation.html)
- [FFmpeg Filters Documentation](https://ffmpeg.org/ffmpeg-filters.html)
- [FFmpeg Wiki](https://trac.ffmpeg.org/wiki)
- [xfade Filter Reference](https://ffmpeg.org/ffmpeg-filters.html#xfade)

## Version

**Version:** 1.0.0
**Last Updated:** 2025-11-03
**Compatible with:** Claude Code (all versions)
**FFmpeg Version:** 4.0+

---

## Quick Start Example

After installation, try this:

```bash
# Activate the skill
/skill ffmpeg-video-expert

# Then ask:
"Create a video from clip1.mp4 and clip2.mp4 with a 2-second dissolve transition between them"
```

Claude will provide a complete, working FFmpeg command with explanations!
