#!/bin/bash
# Installation script for FFmpeg Video Expert Claude Skill

set -e

echo "FFmpeg Video Expert - Claude Skill Installer"
echo "============================================="
echo ""

# Detect OS
if [[ "$OSTYPE" == "linux-gnu"* ]] || [[ "$OSTYPE" == "darwin"* ]]; then
    SKILLS_DIR="$HOME/.config/claude/skills"
elif [[ "$OSTYPE" == "msys" ]] || [[ "$OSTYPE" == "win32" ]]; then
    SKILLS_DIR="$APPDATA/claude/skills"
else
    echo "⚠ Unsupported OS: $OSTYPE"
    echo "Please manually copy ffmpeg-video-expert.md to your Claude skills directory"
    exit 1
fi

echo "Target directory: $SKILLS_DIR"
echo ""

# Create directory if it doesn't exist
if [ ! -d "$SKILLS_DIR" ]; then
    echo "Creating skills directory..."
    mkdir -p "$SKILLS_DIR"
    echo "✓ Directory created"
else
    echo "✓ Skills directory exists"
fi

# Copy skill file
SKILL_FILE="ffmpeg-video-expert.md"
if [ -f "$SKILL_FILE" ]; then
    echo "Installing skill..."
    cp "$SKILL_FILE" "$SKILLS_DIR/"
    echo "✓ Skill installed: $SKILLS_DIR/$SKILL_FILE"
else
    echo "✗ Error: $SKILL_FILE not found in current directory"
    echo "Please run this script from the claude-skills directory"
    exit 1
fi

# Check if examples should be copied
read -p "Copy example scripts to home directory? (y/n) " -n 1 -r
echo ""
if [[ $REPLY =~ ^[Yy]$ ]]; then
    EXAMPLES_DIR="$HOME/ffmpeg-examples"
    if [ ! -d "$EXAMPLES_DIR" ]; then
        mkdir -p "$EXAMPLES_DIR"
    fi
    cp examples/*.sh "$EXAMPLES_DIR/"
    chmod +x "$EXAMPLES_DIR"/*.sh
    echo "✓ Examples copied to: $EXAMPLES_DIR"
fi

# Check if FFmpeg is installed
echo ""
echo "Checking FFmpeg installation..."
if command -v ffmpeg &> /dev/null; then
    FFMPEG_VERSION=$(ffmpeg -version | head -n 1)
    echo "✓ FFmpeg found: $FFMPEG_VERSION"
else
    echo "⚠ FFmpeg not found!"
    echo ""
    echo "Please install FFmpeg:"
    echo "  macOS:        brew install ffmpeg"
    echo "  Ubuntu/Debian: sudo apt install ffmpeg"
    echo "  Windows:      choco install ffmpeg  (or download from ffmpeg.org)"
fi

echo ""
echo "================================="
echo "✓ Installation Complete!"
echo "================================="
echo ""
echo "Next steps:"
echo "1. Restart Claude Code (if running)"
echo "2. Activate the skill: /skill ffmpeg-video-expert"
echo "3. Or just ask FFmpeg questions!"
echo ""
echo "Quick start:"
echo "  Ask: 'Create a video montage from 3 clips with fade transitions'"
echo ""
echo "Documentation:"
echo "  README.md - Full documentation"
echo "  QUICK_REFERENCE.md - Command cheat sheet"
if [[ $REPLY =~ ^[Yy]$ ]]; then
    echo "  $EXAMPLES_DIR/ - Example scripts"
fi
echo ""
echo "Happy video editing with FFmpeg! 🎬"
