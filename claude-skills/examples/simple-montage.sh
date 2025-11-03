#!/bin/bash
# Simple Video Montage with Transitions
# Creates a video from multiple clips with smooth transitions between them

# Example usage:
# ./simple-montage.sh clip1.mp4 clip2.mp4 clip3.mp4 output.mp4

# Configuration
TRANSITION_TYPE="fade"      # Options: fade, dissolve, circlecrop, wipeleft, etc.
TRANSITION_DURATION=1.5     # Duration in seconds
CLIP1_DURATION=5            # Adjust based on actual clip length
CLIP2_DURATION=6            # Adjust based on actual clip length

# Input files
CLIP1="${1:-clip1.mp4}"
CLIP2="${2:-clip2.mp4}"
CLIP3="${3:-clip3.mp4}"
OUTPUT="${4:-output.mp4}"

# Calculate offsets (start of transition = duration - transition_duration)
OFFSET1=$(echo "$CLIP1_DURATION - $TRANSITION_DURATION" | bc)
OFFSET2=$(echo "$CLIP1_DURATION + $CLIP2_DURATION - $TRANSITION_DURATION" | bc)

# FFmpeg command for 3-clip montage
ffmpeg -i "$CLIP1" -i "$CLIP2" -i "$CLIP3" -filter_complex "
[0:v][1:v]xfade=transition=${TRANSITION_TYPE}:duration=${TRANSITION_DURATION}:offset=${OFFSET1}[v01];
[v01][2:v]xfade=transition=${TRANSITION_TYPE}:duration=${TRANSITION_DURATION}:offset=${OFFSET2}[v];
[0:a][1:a]acrossfade=d=${TRANSITION_DURATION}:c1=tri:c2=tri[a01];
[a01][2:a]acrossfade=d=${TRANSITION_DURATION}:c1=tri:c2=tri[a]
" -map "[v]" -map "[a]" \
  -c:v libx264 -preset medium -crf 20 \
  -c:a aac -b:a 192k \
  "$OUTPUT"

echo "✓ Montage created: $OUTPUT"
