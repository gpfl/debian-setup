#!/bin/sh

# Ensure the script is run as root
if [ "$(id -u)" -ne 0 ]; then
    echo "This script must be run as root" >&2
    exit 1
fi

set -euo pipefail

# Define paths and configurations
ZRAM_CONFIG_PATH="/etc/systemd/zram-generator.conf"

# Install systemd-zram-generator
echo "Installing systemd-zram-generator."
apt update && apt install -y systemd-zram-generator

# Check if the zram config file already exists
if [ ! -f "$ZRAM_CONFIG_PATH" ]; then
    echo "Creating zram-generator configuration."
    # Create the zram config file
    tee "$ZRAM_CONFIG_PATH" > /dev/null <<EOF
[zram0]
zram-size = ram * 0.5
compression-algorithm = zstd
EOF
else
    echo "ZRAM config already exists. Skipping creation."
fi

# Reload systemd and start the zram swap device
echo "Reloading systemd and starting zram swap device."
systemctl daemon-reload
systemctl start dev-zram0.swap

echo "03 - ZRAM configured successfully."
