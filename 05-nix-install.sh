#!/bin/sh

# Ensure the script is run as root
if [ "$(id -u)" -ne 0 ]; then
    echo "This script must be run as root" >&2
    exit 1
fi

set -euo pipefail

# Define variables
NIX_INSTALL_SCRIPT_URL="https://nixos.org/nix/install"
NIX_SERVICE_NAME="nix-daemon.service"
GROUP_NAME="nix-users"
CURRENT_USER=$(whoami)

# Function to install Nix
install_nix() {
    echo "Installing Nix..."
    curl -L "$NIX_INSTALL_SCRIPT_URL" | sh -s -- --daemon
    systemctl enable --now "$NIX_SERVICE_NAME"
}

# Function to ensure the 'nix-users' group exists
ensure_nix_users_group() {
    if ! getent group "$GROUP_NAME" > /dev/null; then
        echo "'$GROUP_NAME' group does not exist, so it will be created."
        groupadd "$GROUP_NAME"
    else
        echo "'$GROUP_NAME' group already exists."
    fi
}

# Function to add the current user to the 'nix-users' group
add_user_to_nix_users_group() {
    echo "Adding user $CURRENT_USER to the '$GROUP_NAME' group."
    usermod -aG "$GROUP_NAME" "$CURRENT_USER"
    echo "User $CURRENT_USER has been added to the '$GROUP_NAME' group."
}

# Main script execution
install_nix
ensure_nix_users_group
add_user_to_nix_users_group

# Prompt the user to log out and log back in, or run 'newgrp' to apply the group change
echo "05 - Nix setup complete. Please log out and log back in to apply changes."
