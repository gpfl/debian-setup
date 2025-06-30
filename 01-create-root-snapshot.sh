#!/bin/sh

# Ensure the script is run as root
if [ "$(id -u)" -ne 0 ]; then
    echo "This script must be run as root" >&2
    exit 1
fi

set -euo pipefail

# Define paths and variables
BTRFS_VOLUME="/dev/sda3"  # Default volume, can be overridden by passing an argument
BTRFS_ROOT="/mnt/btrfs-root"
SNAPSHOTS_DIR="$BTRFS_ROOT/snapshots/root"
SNAP_NAME="root-snapshot-$(date +%Y-%m-%d)"

# Use the first argument as the volume if provided
if [ $# -ge 1 ]; then
    BTRFS_VOLUME="$1"
fi

# Function to clean up mounts
cleanup() {
    if mount | grep -q "$BTRFS_ROOT"; then
        umount "$BTRFS_ROOT"
    fi
}

# Trap to ensure cleanup on script exit
trap cleanup EXIT

# Create directory and mount the btrfs root
mkdir -p "$BTRFS_ROOT"
mount -o subvolid=5 "$BTRFS_VOLUME" "$BTRFS_ROOT"

# Create snapshots directory and take snapshot
mkdir -p "$SNAPSHOTS_DIR"
btrfs subvolume snapshot "$BTRFS_ROOT/@" "$SNAPSHOTS_DIR/$SNAP_NAME"

echo "01 - Snapshot created: $SNAP_NAME"
