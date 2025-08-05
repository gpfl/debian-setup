#!/usr/bin/env bash
set -euo pipefail

# Directory for marker files to track completed scripts
MARKER_DIR="$HOME/.setup-markers"
mkdir -p "$MARKER_DIR"

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
