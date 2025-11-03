#!/bin/bash
# Picture-in-Picture (PIP) Video Overlay
# Overlays a small video on top of a main video

# Example usage:
# ./picture-in-picture.sh main.mp4 overlay.mp4 output.mp4 bottom-right

MAIN="${1:-main.mp4}"
OVERLAY="${2:-pip.mp4}"
OUTPUT="${3:-pip_output.mp4}"
POSITION="${4:-bottom-right}"  # Options: top-left, top-right, bottom-left, bottom-right, center

# Overlay size (width:height)
PIP_SIZE="480:270"  # 480x270 for 1080p main video
MARGIN=20           # Margin from edges in pixels

# Calculate position based on parameter
case "$POSITION" in
    "top-left")
        X="$MARGIN"
        Y="$MARGIN"
        ;;
    "top-right")
        X="main_w-overlay_w-$MARGIN"
        Y="$MARGIN"
        ;;
    "bottom-left")
        X="$MARGIN"
        Y="main_h-overlay_h-$MARGIN"
        ;;
    "bottom-right")
        X="main_w-overlay_w-$MARGIN"
        Y="main_h-overlay_h-$MARGIN"
        ;;
    "center")
        X="(main_w-overlay_w)/2"
        Y="(main_h-overlay_h)/2"
        ;;
    *)
        echo "Invalid position. Use: top-left, top-right, bottom-left, bottom-right, center"
        exit 1
        ;;
esac

# Create PIP video
ffmpeg -i "$MAIN" -i "$OVERLAY" -filter_complex "
  [1:v]scale=${PIP_SIZE}[pip];
  [0:v][pip]overlay=x=${X}:y=${Y}:shortest=1[v]
" \
-map "[v]" -map "0:a?" \
-c:v libx264 -preset medium -crf 20 \
-c:a copy \
"$OUTPUT"

echo "✓ Picture-in-picture video created: $OUTPUT"

# Advanced: Animated PIP (slides in from right)
# Uncomment for sliding animation

: '
ffmpeg -i main.mp4 -i overlay.mp4 -filter_complex "
  [1:v]scale=480:270[pip];
  [0:v][pip]overlay=x='"'"'if(lt(t,2),W,W-(t-2)*100)'"'"':y=H-overlay_h-20:
  shortest=1[v]
" -map "[v]" -c:v libx264 -crf 20 animated_pip.mp4
'

# Advanced: Multiple PIP overlays
# Uncomment for multiple overlays

: '
ffmpeg -i main.mp4 -i pip1.mp4 -i pip2.mp4 -filter_complex "
  [1:v]scale=320:180[pip1];
  [2:v]scale=320:180[pip2];
  [0:v][pip1]overlay=x=20:y=20[tmp];
  [tmp][pip2]overlay=x=W-overlay_w-20:y=20[v]
" -map "[v]" -c:v libx264 -crf 20 multi_pip.mp4
'
