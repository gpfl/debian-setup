#!/usr/bin/env bash

set -euo pipefail

# Import shared config and marker logic
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/env/config.sh"
source "$SCRIPT_DIR/env/common.sh"

# Exit if this script has already run
check_marker

# Ensure running as root
require_root

# Clean up cloned repo directory on exit
trap "cleanup_repo_dir '$GRUB_BTRFS_REPO_NAME'" EXIT


# Install required dependencies
echo "Installing dependencies."
install_packages curl git build-essential inotify-tools

# Clone the repository if it doesn't exist
if [ ! -d "$GRUB_BTRFS_REPO_NAME" ]; then
    echo "Cloning repo $GRUB_BTRFS_REPO_URL."
    git clone "$GRUB_BTRFS_REPO_URL"
fi

# Navigate to the repository directory
cd "./$GRUB_BTRFS_REPO_NAME"

# Compile and install
echo "Installing grub-btrfs."
make install
grub-mkconfig -o /boot/grub/grub.cfg

# Check if the edited service file already exists
if [ ! -f "$GRUB_BTRFS_SERVICE_PATH" ]; then
    echo "Editing snapshot path in the service file."
    systemctl edit --full "$GRUB_BTRFS_SERVICE_NAME"
    
    # Replace /.snapshots with /snapshots in the service file
    sed -i 's|/\.snapshots|/snapshots|g' "$GRUB_BTRFS_SERVICE_PATH"
fi

# Reload systemd manager configuration
systemctl daemon-reexec
systemctl daemon-reload
systemctl restart "$GRUB_BTRFS_SERVICE_NAME"

# Wait for the service to restart
sleep 5

# Enable the service on boot
systemctl enable "$GRUB_BTRFS_SERVICE_NAME"

# Create marker file indicating this script ran successfully
touch "$MARKER_FILE"

echo "02 - $GRUB_BTRFS_REPO_NAME configured successfully."
