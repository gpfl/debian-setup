#! /bin/sh
sudo apt install -y curl git build-essential inotify-tools

if [ ! -d "grub-btrfs" ]; then
	git clone https://github.com/Antynea/grub-btrfs.git
fi

cd ./grub-btrfs
sudo make install
sudo grub-mkconfig

# Define the path for the edited systemd service file
SERVICE_NAME="grub-btrfsd"
EDITED_PATH="/etc/systemd/system/${SERVICE_NAME}.service"

# Check if the edited service file already exists
if [ ! -f "$EDITED_PATH" ]; then
    # Create a full copy of the original service
    systemctl edit --full "$SERVICE_NAME"
fi

# Replace /.snapshots with /snapshots
sed -i 's|/\.snapshots|/snapshots|g' "$EDITED_PATH"

# Reload systemd manager configuration
systemctl daemon-reexec
systemctl daemon-reload

# Restart the service if needed
systemctl restart "$SERVICE_NAME"
