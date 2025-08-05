#!/usr/bin/env bash

set -euo pipefail

# Import shared config and marker logic
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/env/config.sh"
source "$SCRIPT_DIR/env/common.sh"

check_marker

# Ensure the script is run as root
require_root

# Override BTRFS_VOLUME if passed as an argument
BTRFS_VOLUME="${1:-$BTRFS_VOLUME}"

# Name for the snapshot
SNAP_NAME="root-snapshot-$(date +%Y-%m-%d)"

# Function to clean up mounts
cleanup() {
    if mount | grep -q "$BTRFS_ROOT"; then
        umount "$BTRFS_ROOT"
    fi
}
trap cleanup EXIT

# Create directory and mount the btrfs root
mkdir -p "$BTRFS_ROOT"
mount -o subvolid=5 "$BTRFS_VOLUME" "$BTRFS_ROOT"

# Create snapshots directory and take snapshot
mkdir -p "$SNAPSHOTS_DIR"
btrfs subvolume snapshot "$BTRFS_ROOT/@" "$SNAPSHOTS_DIR/$SNAP_NAME"


touch "$MARKER_FILE"
echo "01 - Snapshot created: $SNAP_NAME"
