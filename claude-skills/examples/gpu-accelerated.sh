#!/bin/bash
# GPU-Accelerated Video Processing with FFmpeg
# Demonstrates hardware acceleration using CUDA, Vulkan, and other APIs

INPUT1="${1:-video1.mp4}"
INPUT2="${2:-video2.mp4}"
OUTPUT="${3:-output.mp4}"

# Check available hardware encoders
check_encoders() {
    echo "Checking available hardware encoders..."
    echo ""

    if ffmpeg -hide_banner -encoders 2>/dev/null | grep -q "h264_nvenc"; then
        echo "✓ NVIDIA NVENC (CUDA) available"
    fi

    if ffmpeg -hide_banner -encoders 2>/dev/null | grep -q "hevc_nvenc"; then
        echo "✓ NVIDIA NVENC HEVC available"
    fi

    if ffmpeg -hide_banner -encoders 2>/dev/null | grep -q "h264_vaapi"; then
        echo "✓ VAAPI (Intel/AMD) available"
    fi

    if ffmpeg -hide_banner -encoders 2>/dev/null | grep -q "h264_videotoolbox"; then
        echo "✓ VideoToolbox (macOS) available"
    fi

    if ffmpeg -hide_banner -encoders 2>/dev/null | grep -q "h264_qsv"; then
        echo "✓ Intel Quick Sync Video available"
    fi

    echo ""
}

# CUDA-accelerated transition
cuda_transition() {
    echo "Creating CUDA-accelerated transition..."

    ffmpeg -hwaccel cuda -hwaccel_output_format cuda \
        -i "$INPUT1" -i "$INPUT2" -filter_complex "
      [0:v]scale_cuda=1920:1080[v0];
      [1:v]scale_cuda=1920:1080[v1];
      [v0][v1]xfade_cuda=transition=fade:duration=2:offset=5[v]
    " \
    -map "[v]" \
    -c:v h264_nvenc -preset fast -crf 20 \
    cuda_output.mp4

    echo "✓ CUDA-accelerated video created: cuda_output.mp4"
}

# VAAPI-accelerated processing (Intel/AMD GPUs on Linux)
vaapi_processing() {
    echo "Creating VAAPI-accelerated video..."

    ffmpeg -hwaccel vaapi -hwaccel_device /dev/dri/renderD128 \
        -hwaccel_output_format vaapi \
        -i "$INPUT1" -filter_complex "
      scale_vaapi=1920:1080,hwdownload,format=nv12[v]
    " \
    -map "[v]" \
    -c:v h264_vaapi -qp 20 \
    vaapi_output.mp4

    echo "✓ VAAPI-accelerated video created: vaapi_output.mp4"
}

# VideoToolbox (macOS hardware acceleration)
videotoolbox_processing() {
    echo "Creating VideoToolbox-accelerated video..."

    ffmpeg -hwaccel videotoolbox \
        -i "$INPUT1" -filter_complex "
      scale=1920:1080[v]
    " \
    -map "[v]" \
    -c:v h264_videotoolbox -b:v 5M \
    videotoolbox_output.mp4

    echo "✓ VideoToolbox-accelerated video created: videotoolbox_output.mp4"
}

# Quick Sync Video (Intel)
qsv_processing() {
    echo "Creating QSV-accelerated video..."

    ffmpeg -hwaccel qsv -c:v h264_qsv \
        -i "$INPUT1" -filter_complex "
      scale_qsv=1920:1080[v]
    " \
    -map "[v]" \
    -c:v h264_qsv -preset medium -global_quality 20 \
    qsv_output.mp4

    echo "✓ QSV-accelerated video created: qsv_output.mp4"
}

# Vulkan-accelerated processing (cross-platform)
vulkan_processing() {
    echo "Creating Vulkan-accelerated video..."

    ffmpeg -i "$INPUT1" -i "$INPUT2" -filter_complex "
      [0:v]hwupload[v0];
      [1:v]hwupload[v1];
      [v0][v1]xfade_vulkan=transition=fade:duration=2:offset=5[v];
      [v]hwdownload,format=yuv420p
    " \
    -map "[v]" \
    -c:v libx264 -crf 20 \
    vulkan_output.mp4

    echo "✓ Vulkan-accelerated video created: vulkan_output.mp4"
}

# Optimal NVENC settings for quality
nvenc_high_quality() {
    echo "Creating high-quality NVENC encode..."

    ffmpeg -i "$INPUT1" \
        -c:v h264_nvenc \
        -preset p7 \
        -tune hq \
        -rc vbr \
        -cq 19 \
        -b:v 0 \
        -multipass 2 \
        -spatial-aq 1 \
        -temporal-aq 1 \
        -rc-lookahead 32 \
        nvenc_hq.mp4

    echo "✓ High-quality NVENC video created: nvenc_hq.mp4"
}

# Menu
echo "GPU-Accelerated FFmpeg Processing"
echo "=================================="
check_encoders
echo "1. CUDA (NVIDIA)"
echo "2. VAAPI (Intel/AMD Linux)"
echo "3. VideoToolbox (macOS)"
echo "4. Quick Sync Video (Intel)"
echo "5. Vulkan (cross-platform)"
echo "6. High-quality NVENC"
echo "7. Check encoders only"
echo ""
read -p "Select hardware acceleration (1-7): " choice

case $choice in
    1) cuda_transition ;;
    2) vaapi_processing ;;
    3) videotoolbox_processing ;;
    4) qsv_processing ;;
    5) vulkan_processing ;;
    6) nvenc_high_quality ;;
    7) check_encoders ;;
    *)
        echo "Invalid choice"
        exit 1
        ;;
esac

# Notes on hardware acceleration:
#
# CUDA (NVIDIA):
#   - Fastest on NVIDIA GPUs
#   - Requires NVIDIA drivers and CUDA toolkit
#   - Filters: scale_cuda, overlay_cuda, xfade_cuda
#   - Encoder: h264_nvenc, hevc_nvenc
#
# VAAPI (Intel/AMD):
#   - Linux only
#   - Good quality/performance balance
#   - Filters: scale_vaapi, overlay_vaapi
#   - Encoder: h264_vaapi, hevc_vaapi
#
# VideoToolbox (Apple):
#   - macOS/iOS only
#   - Hardware H.264/HEVC encoding
#   - Encoder: h264_videotoolbox, hevc_videotoolbox
#
# QSV (Intel):
#   - Intel integrated/discrete GPUs
#   - Cross-platform (Windows, Linux, macOS)
#   - Filters: scale_qsv, overlay_qsv
#   - Encoder: h264_qsv, hevc_qsv
#
# Vulkan:
#   - Cross-platform GPU compute
#   - Filters: scale_vulkan, overlay_vulkan, xfade_vulkan
#   - Good for filters, use CPU/other encoder for output
