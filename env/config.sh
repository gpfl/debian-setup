#!/usr/bin/env bash
set -euo pipefail

# Directory for marker files to track completed scripts
# Define marker directory
MARKER_DIR="/var/log/debian-setup"

# Check if the directory exists and is writable
if [ -d "$MARKER_DIR" ] && [ -w "$MARKER_DIR" ]; then
    echo "Marker directory already exists and is writable: $MARKER_DIR"
else
    if [ "$EUID" -ne 0 ]; then
        echo "Marker directory does not exist or is not writable: $MARKER_DIR"
        echo "Please run this script once with sudo to set up permissions:"
        echo "  sudo $0"
        exit 1
    else
        echo "Creating and setting permissions for $MARKER_DIR"
        mkdir -p "$MARKER_DIR"
        chown "$SUDO_USER:$SUDO_USER" "$MARKER_DIR"
        chmod 755 "$MARKER_DIR"
        echo "Directory created and permissions set."
    fi
fi

# Variables for grub-btrfs setup script (02-grub-btrfs-setup.sh)
GRUB_BTRFS_REPO_NAME="grub-btrfs"
GRUB_BTRFS_REPO_URL="https://github.com/Antynea/grub-btrfs.git"
GRUB_BTRFS_SERVICE_NAME="grub-btrfsd"
GRUB_BTRFS_SERVICE_PATH="/etc/systemd/system/${GRUB_BTRFS_SERVICE_NAME}.service"

# Default BTRFS volume device
export BTRFS_VOLUME="/dev/sda2"

# Where to mount the btrfs root
export BTRFS_ROOT="/mnt/btrfs-root"

# Where to save root snapshots
export SNAPSHOTS_DIR="$BTRFS_ROOT/@snapshots/root"
