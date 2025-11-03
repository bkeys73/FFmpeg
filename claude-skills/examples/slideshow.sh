#!/bin/bash
# Image Slideshow with Ken Burns Effect
# Creates a video slideshow from images with zoom/pan animations and transitions

# Example usage:
# Place images as img001.jpg, img002.jpg, etc. in current directory
# ./slideshow.sh output.mp4

OUTPUT="${1:-slideshow.mp4}"
IMAGE_DURATION=3            # Duration per image in seconds
FADE_DURATION=0.5          # Fade in/out duration
FPS=25                     # Output framerate
RESOLUTION="1920:1080"     # Output resolution

# Create slideshow with Ken Burns effect (zoom and pan)
ffmpeg -framerate 1/${IMAGE_DURATION} -pattern_type glob -i "img*.jpg" \
  -filter_complex "
    scale=${RESOLUTION}:force_original_aspect_ratio=increase,
    crop=${RESOLUTION/:/x},
    zoompan=z='min(zoom+0.0015,1.5)':d=$((IMAGE_DURATION * FPS)):
            x='iw/2-(iw/zoom/2)':y='ih/2-(ih/zoom/2)':s=${RESOLUTION},
    fade=t=in:st=0:d=${FADE_DURATION},
    fade=t=out:st=$((IMAGE_DURATION - FADE_DURATION)):d=${FADE_DURATION},
    format=yuv420p[v]
  " \
  -map "[v]" \
  -r ${FPS} \
  -c:v libx264 -preset slow -crf 18 \
  "$OUTPUT"

echo "✓ Slideshow created: $OUTPUT"

# Alternative: Slideshow with xfade transitions between images
# Uncomment below for transition-based slideshow

: '
ffmpeg -loop 1 -t 3 -i img001.jpg \
       -loop 1 -t 3 -i img002.jpg \
       -loop 1 -t 3 -i img003.jpg \
  -filter_complex "
    [0:v]scale=1920:1080,setsar=1[v0];
    [1:v]scale=1920:1080,setsar=1[v1];
    [2:v]scale=1920:1080,setsar=1[v2];
    [v0][v1]xfade=transition=dissolve:duration=1:offset=2[v01];
    [v01][v2]xfade=transition=fade:duration=1:offset=4[v]
  " \
  -map "[v]" -r 25 -c:v libx264 -crf 20 slideshow-transitions.mp4
'
