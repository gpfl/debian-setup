#!/bin/sh

# Ensure the script is run as root
if [ "$(id -u)" -ne 0 ]; then
    echo "This script must be run as root" >&2
    exit 1
fi

set -euo pipefail

# Define paths and names
REPO_NAME="grub-btrfs"
REPO_URL="https://github.com/Antynea/grub-btrfs.git"
SERVICE_NAME="grub-btrfsd"
EDITED_PATH="/etc/systemd/system/${SERVICE_NAME}.service"

# Function to clean up the cloned repository
cleanup() {
    if [ -d "$REPO_NAME" ]; then
        rm -rf "$REPO_NAME"
    fi
}

# Trap to ensure cleanup on script exit
trap cleanup EXIT

# Install necessary packages
echo "Installing dependencies."
apt update && apt install -y curl git build-essential inotify-tools

# Clone the repository if it doesn't exist
if [ ! -d "$REPO_NAME" ]; then
    echo "Cloning repo $REPO_URL."
    git clone "$REPO_URL"
fi

# Navigate to the repository directory
cd "./$REPO_NAME"

# Compile and install
echo "Installing grub-btrfs."
make install
grub-mkconfig -o /boot/grub/grub.cfg

# Check if the edited service file already exists
if [ ! -f "$EDITED_PATH" ]; then
    echo "Editing snapshot path in the service file."
    systemctl edit --full "$SERVICE_NAME"
    
    # Replace /.snapshots with /snapshots in the service file
sed -i 's|/\.snapshots|/snapshots|g' "$EDITED_PATH"
fi

# Reload systemd manager configuration
systemctl daemon-reexec
systemctl daemon-reload

# Restart the service
systemctl restart "$SERVICE_NAME"

echo "02 - $REPO_NAME configured successfully."
