#!/bin/bash
# Split-Screen Video Comparison
# Creates side-by-side or stacked video comparisons

# Example usage:
# ./split-screen.sh left.mp4 right.mp4 output.mp4 horizontal

INPUT1="${1:-video1.mp4}"
INPUT2="${2:-video2.mp4}"
OUTPUT="${3:-comparison.mp4}"
LAYOUT="${4:-horizontal}"  # Options: horizontal, vertical

if [ "$LAYOUT" == "horizontal" ]; then
    # Horizontal split (side-by-side)
    echo "Creating horizontal split-screen..."

    ffmpeg -i "$INPUT1" -i "$INPUT2" -filter_complex "
      [0:v]scale=960:1080:force_original_aspect_ratio=increase,crop=960:1080,setsar=1[left];
      [1:v]scale=960:1080:force_original_aspect_ratio=increase,crop=960:1080,setsar=1[right];
      color=c=white:s=4x1080:r=25[line];
      [left][line]hstack[left_line];
      [left_line][right]hstack[v]
    " \
    -map "[v]" \
    -c:v libx264 -preset medium -crf 20 \
    -t 10 \
    "$OUTPUT"

elif [ "$LAYOUT" == "vertical" ]; then
    # Vertical split (stacked)
    echo "Creating vertical split-screen..."

    ffmpeg -i "$INPUT1" -i "$INPUT2" -filter_complex "
      [0:v]scale=1920:540:force_original_aspect_ratio=increase,crop=1920:540,setsar=1[top];
      [1:v]scale=1920:540:force_original_aspect_ratio=increase,crop=1920:540,setsar=1[bottom];
      color=c=white:s=1920x4:r=25[line];
      [top][line]vstack[top_line];
      [top_line][bottom]vstack[v]
    " \
    -map "[v]" \
    -c:v libx264 -preset medium -crf 20 \
    -t 10 \
    "$OUTPUT"
else
    echo "Invalid layout. Use 'horizontal' or 'vertical'"
    exit 1
fi

echo "✓ Split-screen video created: $OUTPUT"

# Advanced: 4-way split (2x2 grid)
# Uncomment to create a 2x2 grid of 4 videos

: '
ffmpeg -i v1.mp4 -i v2.mp4 -i v3.mp4 -i v4.mp4 -filter_complex "
  [0:v]scale=960:540[v0];
  [1:v]scale=960:540[v1];
  [2:v]scale=960:540[v2];
  [3:v]scale=960:540[v3];
  [v0][v1]hstack[top];
  [v2][v3]hstack[bottom];
  [top][bottom]vstack[v]
" -map "[v]" -c:v libx264 -crf 20 grid_2x2.mp4
'
