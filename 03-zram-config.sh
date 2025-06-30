#!/bin/sh

# Install systemd-zram-generator
sudo apt update
sudo apt install -y systemd-zram-generator

# if there's no config file, create the zram config
if [ ! -f /etc/systemd/zram-generator.conf ]; then
    echo "Creating zram-generator configuration..."
    sudo tee /etc/systemd/zram-generator.conf > /dev/null <<EOF
[zram0]
zram-size = ram * 0.5
compression-algorithm = zstd
EOF
else
    echo "ZRAM config already exists. Skipping creation."
fi

# Reload systemd and start the zram swap device
sudo systemctl daemon-reload
sudo systemctl start dev-zram0.swap
