#!/bin/sh

curl -L https://nixos.org/nix/install | sh -s -- --daemon

sudo systemctl enable --now nix-daemon.service

# Check if 'nix-users' group exists
if ! getent group nix-users > /dev/null 2>&1; then
  echo "'nix-users' group does not exist, so will be created."
  sudo groupadd nix-users
else
  echo "'nix-users' group already exists."
fi

# Determine the current user.
CURRENT_USER=$(whoami)

# Add the current user to the 'nix-users' group
sudo usermod -aG nix-users "$CURRENT_USER"
echo "User $CURRENT_USER has been added to the 'nix-users' group."

# Prompt the user to log out and log back in, or run 'newgrp' to apply the group change
echo "Please log out and log back in, or run 'newgrp nix-users' to apply the group change immediately."
