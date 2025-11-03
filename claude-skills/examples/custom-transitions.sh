#!/bin/bash
# Custom Transition Effects using FFmpeg Expression Language
# Demonstrates advanced custom transitions beyond built-in types

INPUT1="${1:-video1.mp4}"
INPUT2="${2:-video2.mp4}"
OUTPUT="${3:-custom_transition.mp4}"
DURATION=3
OFFSET=5

# Example 1: Diagonal wipe with custom angle
diagonal_wipe() {
    ffmpeg -i "$INPUT1" -i "$INPUT2" -filter_complex "
      [0:v][1:v]xfade=transition=custom:duration=${DURATION}:offset=${OFFSET}:
      expr='if(gt(Y-X*tan(PI/4),W*P),A,B)'
      [v]
    " -map "[v]" -c:v libx264 -crf 20 diagonal_wipe.mp4

    echo "✓ Diagonal wipe created: diagonal_wipe.mp4"
}

# Example 2: Circular reveal from center
circular_reveal() {
    ffmpeg -i "$INPUT1" -i "$INPUT2" -filter_complex "
      [0:v][1:v]xfade=transition=custom:duration=${DURATION}:offset=${OFFSET}:
      expr='if(hypot(X-W/2,Y-H/2)<W*P/2,B,A)'
      [v]
    " -map "[v]" -c:v libx264 -crf 20 circular_reveal.mp4

    echo "✓ Circular reveal created: circular_reveal.mp4"
}

# Example 3: Wave transition
wave_transition() {
    ffmpeg -i "$INPUT1" -i "$INPUT2" -filter_complex "
      [0:v][1:v]xfade=transition=custom:duration=${DURATION}:offset=${OFFSET}:
      expr='if(Y<H*(0.5+0.5*sin(2*PI*X/W-P*2*PI)),A,B)'
      [v]
    " -map "[v]" -c:v libx264 -crf 20 wave_transition.mp4

    echo "✓ Wave transition created: wave_transition.mp4"
}

# Example 4: Checkerboard dissolve
checkerboard() {
    ffmpeg -i "$INPUT1" -i "$INPUT2" -filter_complex "
      [0:v][1:v]xfade=transition=custom:duration=${DURATION}:offset=${OFFSET}:
      expr='if(eq(mod(floor(X/20)+floor(Y/20),2),0),if(lt(P,0.5),A,B),if(lt(P,0.5),B,A))'
      [v]
    " -map "[v]" -c:v libx264 -crf 20 checkerboard.mp4

    echo "✓ Checkerboard transition created: checkerboard.mp4"
}

# Example 5: Radial wipe (clock-like)
radial_wipe() {
    ffmpeg -i "$INPUT1" -i "$INPUT2" -filter_complex "
      [0:v][1:v]xfade=transition=custom:duration=${DURATION}:offset=${OFFSET}:
      expr='if(atan2(Y-H/2,X-W/2)+PI<P*2*PI,B,A)'
      [v]
    " -map "[v]" -c:v libx264 -crf 20 radial_wipe.mp4

    echo "✓ Radial wipe created: radial_wipe.mp4"
}

# Example 6: Zoom transition (zoom out of first, into second)
zoom_transition() {
    ffmpeg -i "$INPUT1" -i "$INPUT2" -filter_complex "
      [0:v][1:v]xfade=transition=custom:duration=${DURATION}:offset=${OFFSET}:
      expr='st(0,hypot(X-W/2,Y-H/2));
            st(1,W/2);
            if(lt(ld(0),ld(1)*(1-P)),A,B)'
      [v]
    " -map "[v]" -c:v libx264 -crf 20 zoom_transition.mp4

    echo "✓ Zoom transition created: zoom_transition.mp4"
}

# Example 7: RGB split transition
rgb_split() {
    ffmpeg -i "$INPUT1" -i "$INPUT2" -filter_complex "
      [0:v][1:v]xfade=transition=custom:duration=${DURATION}:offset=${OFFSET}:
      expr='st(0,P*3);
            if(eq(PLANE,0),if(lt(X/W,ld(0)),B,A),
            if(eq(PLANE,1),if(lt(X/W,ld(0)-1),B,A),
            if(lt(X/W,ld(0)-2),B,A)))'
      [v]
    " -map "[v]" -c:v libx264 -crf 20 rgb_split.mp4

    echo "✓ RGB split transition created: rgb_split.mp4"
}

# Menu
echo "Custom FFmpeg Transition Examples"
echo "=================================="
echo "1. Diagonal wipe"
echo "2. Circular reveal"
echo "3. Wave transition"
echo "4. Checkerboard dissolve"
echo "5. Radial wipe (clock-like)"
echo "6. Zoom transition"
echo "7. RGB split transition"
echo "8. Create all"
echo ""
read -p "Select transition (1-8): " choice

case $choice in
    1) diagonal_wipe ;;
    2) circular_reveal ;;
    3) wave_transition ;;
    4) checkerboard ;;
    5) radial_wipe ;;
    6) zoom_transition ;;
    7) rgb_split ;;
    8)
        diagonal_wipe
        circular_reveal
        wave_transition
        checkerboard
        radial_wipe
        zoom_transition
        rgb_split
        echo "✓ All custom transitions created!"
        ;;
    *)
        echo "Invalid choice"
        exit 1
        ;;
esac
