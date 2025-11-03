# FFmpeg Video Expert - Quick Reference

## Installation

```bash
# Copy skill to Claude Code skills directory
cp ffmpeg-video-expert.md ~/.config/claude/skills/

# Or use the install script
./install.sh
```

## Activation

In Claude Code, type:
```
/skill ffmpeg-video-expert
```

Or simply ask FFmpeg-related questions and the skill will activate automatically.

## Quick Commands Cheat Sheet

### Basic Transitions

```bash
# Simple crossfade
ffmpeg -i v1.mp4 -i v2.mp4 -filter_complex \
  "[0:v][1:v]xfade=transition=fade:duration=2:offset=5[v]" \
  -map "[v]" output.mp4

# Dissolve transition
xfade=transition=dissolve:duration=1.5:offset=4

# Circular wipe
xfade=transition=circlecrop:duration=2:offset=3

# Wipe left
xfade=transition=wipeleft:duration=1:offset=5
```

### Multiple Clips

```bash
# 3 clips with transitions
ffmpeg -i c1.mp4 -i c2.mp4 -i c3.mp4 -filter_complex "
  [0:v][1:v]xfade=transition=fade:duration=1:offset=4[v01];
  [v01][2:v]xfade=transition=dissolve:duration=1:offset=9[v]
" -map "[v]" output.mp4
```

### Picture-in-Picture

```bash
# PIP in bottom-right corner
ffmpeg -i main.mp4 -i pip.mp4 -filter_complex "
  [1:v]scale=480:270[pip];
  [0:v][pip]overlay=x=main_w-overlay_w-20:y=main_h-overlay_h-20
" output.mp4
```

### Split Screen

```bash
# Side-by-side
ffmpeg -i left.mp4 -i right.mp4 -filter_complex "
  [0:v]scale=960:1080[l];
  [1:v]scale=960:1080[r];
  [l][r]hstack
" output.mp4

# Top-bottom
[l][r]vstack
```

### Custom Transitions

```bash
# Circular reveal from center
xfade=transition=custom:duration=2:expr='if(hypot(X-W/2,Y-H/2)<W*P/2,B,A)'

# Diagonal wipe
xfade=transition=custom:duration=2:expr='if(gt(Y-X,W*P),A,B)'

# Wave transition
xfade=transition=custom:duration=3:expr='if(Y<H*(0.5+0.5*sin(2*PI*X/W-P*2*PI)),A,B)'
```

### Blend Modes

```bash
# Overlay with blend
ffmpeg -i bg.mp4 -i fg.mp4 -filter_complex "
  blend=all_mode=screen:all_opacity=0.5
" output.mp4

# Available modes:
# normal, multiply, screen, overlay, darken, lighten
# difference, exclusion, hardlight, softlight, etc.
```

### Audio Crossfade

```bash
# Video and audio crossfade
ffmpeg -i v1.mp4 -i v2.mp4 -filter_complex "
  [0:v][1:v]xfade=transition=fade:duration=2:offset=5[v];
  [0:a][1:a]acrossfade=d=2[a]
" -map "[v]" -map "[a]" output.mp4
```

### Fade In/Out

```bash
# Fade in first 2 seconds
ffmpeg -i input.mp4 -vf "fade=t=in:st=0:d=2" output.mp4

# Fade out last 2 seconds (for 10s video)
fade=t=out:st=8:d=2

# Both
fade=t=in:st=0:d=2,fade=t=out:st=8:d=2
```

### Encoding Presets

```bash
# High quality H.264
-c:v libx264 -preset slow -crf 18 -c:a aac -b:a 192k

# Fast encode
-c:v libx264 -preset veryfast -crf 23

# HEVC (smaller file)
-c:v libx265 -preset medium -crf 20

# GPU (NVIDIA)
-c:v h264_nvenc -preset p7 -crf 20
```

## Available Transitions (48+)

### Fade Family
`fade`, `fadeblack`, `fadewhite`, `fadefast`, `fadeslow`, `fadegrays`

### Wipes
`wipeleft`, `wiperight`, `wipeup`, `wipedown`, `wipetl`, `wipetr`, `wipebl`, `wipebr`

### Slides
`slideleft`, `slideright`, `slideup`, `slidedown`

### Directional
`smoothleft`, `smoothright`, `smoothup`, `smoothdown`

### Shapes
`circlecrop`, `circleopen`, `circleclose`, `rectcrop`
`vertopen`, `vertclose`, `horzopen`, `horzclose`

### Special
`dissolve`, `pixelize`, `radial`, `distance`, `zoomin`, `hblur`
`squeezeh`, `squeezev`

### Cover/Reveal
`coverleft`, `coverright`, `coverup`, `coverdown`
`revealleft`, `revealright`, `revealup`, `revealdown`

### Slices/Wind
`hlslice`, `hrslice`, `vuslice`, `vdslice`
`hlwind`, `hrwind`, `vuwind`, `vdwind`

### Diagonal
`diagtl`, `diagtr`, `diagbl`, `diagbr`

### Custom
`custom` - Use with `expr=` parameter

## Expression Language Variables

### Coordinates & Dimensions
- `X`, `Y` - Current pixel coordinates
- `W`, `H` - Frame width/height
- `SW`, `SH` - Chroma subsampling scale

### Time & Progress
- `T` - Time in seconds
- `N` - Frame number
- `P` - Progress (0.0 to 1.0)

### Pixel Values
- `A`, `B` - Pixel from input A and B
- `a0(x,y)`, `a1(x,y)` - Get pixel at coordinates
- `PLANE` - Current plane number

### Functions
- Math: `abs()`, `sin()`, `cos()`, `sqrt()`, `pow()`, `hypot()`
- Logic: `if()`, `eq()`, `gt()`, `lt()`, `gte()`, `lte()`
- Constants: `PI`, `E`

## Filter Chain Syntax

```bash
# Sequential filters (comma)
filter1,filter2,filter3

# Parallel chains (semicolon)
[in]filter1[tmp]; [tmp]filter2[out]

# Multiple inputs
[0:v][1:v]xfade[out]

# Labels
[label_name]
```

## Common Patterns

### Calculate Offset
```
offset = clip1_duration - transition_duration
```
For 5-second clip with 2-second transition:
```
offset = 5 - 2 = 3
```

### Scale to Resolution
```bash
scale=1920:1080:force_original_aspect_ratio=decrease,
pad=1920:1080:(ow-iw)/2:(oh-ih)/2
```

### Maintain Aspect Ratio
```bash
scale=1920:-2  # -2 ensures even height
```

### Get Video Duration
```bash
ffprobe -v error -show_entries format=duration \
  -of default=noprint_wrappers=1:nokey=1 input.mp4
```

## Example Workflows

### 1. Quick Montage
```bash
./examples/simple-montage.sh clip1.mp4 clip2.mp4 clip3.mp4 output.mp4
```

### 2. Slideshow
```bash
./examples/slideshow.sh slideshow.mp4
```

### 3. Split Screen
```bash
./examples/split-screen.sh left.mp4 right.mp4 output.mp4 horizontal
```

### 4. Picture-in-Picture
```bash
./examples/picture-in-picture.sh main.mp4 pip.mp4 output.mp4 bottom-right
```

### 5. Custom Transitions
```bash
./examples/custom-transitions.sh video1.mp4 video2.mp4 output.mp4
```

### 6. GPU Accelerated
```bash
./examples/gpu-accelerated.sh
```

## Troubleshooting

### "Offset is outside video duration"
- Check clip duration: `ffprobe -v error -show_entries format=duration input.mp4`
- Ensure: `offset < clip1_duration - transition_duration`

### "Unrecognized option 'xfade'"
- Update FFmpeg: `ffmpeg -version` (need 4.3+)

### "No such filter: 'xfade_cuda'"
- FFmpeg not compiled with CUDA support
- Use CPU version or recompile with `--enable-cuda`

### Poor Quality Output
- Lower CRF value: `-crf 18` (lower = better quality)
- Use slower preset: `-preset slow`
- Increase bitrate: `-b:v 5M`

### Slow Processing
- Use GPU acceleration
- Use faster preset: `-preset ultrafast`
- Lower resolution during testing

## Resources

- FFmpeg Filters: https://ffmpeg.org/ffmpeg-filters.html
- xfade Documentation: https://ffmpeg.org/ffmpeg-filters.html#xfade
- FFmpeg Wiki: https://trac.ffmpeg.org/wiki
- Expression Evaluation: https://ffmpeg.org/ffmpeg-utils.html#Expression-Evaluation

## Tips

1. **Test first**: Use short clips to test transitions
2. **Calculate offsets**: offset = duration - transition_duration
3. **Check durations**: Use `ffprobe` to get exact durations
4. **Quality vs Speed**: Balance CRF and preset for your needs
5. **Audio matters**: Don't forget audio crossfades
6. **GPU when possible**: Speeds up processing significantly
7. **Backup originals**: Always keep source files
8. **Use labels**: Named streams make complex chains easier

## Getting Help

With the FFmpeg Video Expert skill active in Claude Code:

```
"How do I create a circular wipe transition?"
"Show me a 4-way split screen layout"
"I need a custom diagonal transition"
"How do I add a watermark that fades in?"
```

Claude will provide complete, working commands with explanations!
