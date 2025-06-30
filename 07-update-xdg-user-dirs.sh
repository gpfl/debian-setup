#!/bin/sh

set -euo pipefail

# Define the target configuration file path
CONFIG_FILE="$HOME/.config/user-dirs.dirs"

# Create the necessary directories if they don't exist
mkdir -p "$HOME/.config"
mkdir -p "$HOME/{desktop,documents,downloads,music,pictures,public,templates,videos}"

# Write the configuration to the file
cat > "$CONFIG_FILE" <<EOF
XDG_DESKTOP_DIR="$HOME/desktop"
XDG_DOCUMENTS_DIR="$HOME/documents"
XDG_DOWNLOAD_DIR="$HOME/downloads"
XDG_MUSIC_DIR="$HOME/music"
XDG_PICTURES_DIR="$HOME/pictures"
XDG_PUBLICSHARE_DIR="$HOME/public"
XDG_TEMPLATES_DIR="$HOME/templates"
XDG_VIDEOS_DIR="$HOME/videos"
EOF

# Update the XDG user directories
xdg-user-dirs-update

echo "07 - User directories have been updated to lowercase names."
