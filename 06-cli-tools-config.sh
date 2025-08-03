#!/usr/bin/env bash

set -euo pipefail

# Determine the original user and their home directory
USER_NAME="${SUDO_USER:-$USER}"
USER_HOME=$(eval echo "~$USER_NAME")
ZSHRC_PATH="$USER_HOME/.zshrc"
ZSHRC_BACKUP_PATH="$USER_HOME/.zshrc.backup.$(date +%s)"
PACKAGES=("eza" "zoxide" "fd")

# Load Nix environment if available (multi-user install)
load_nix_env() {
    if [ -f /etc/profile.d/nix.sh ]; then
        . /etc/profile.d/nix.sh
    fi
}

# Check and install packages using nix
install_packages_with_nix() {
    echo "Checking for Nix installation."
    load_nix_env

    if ! command -v nix-env >/dev/null; then
        echo "Nix is not installed. Please install Nix before running this script."
        exit 1
    fi

    echo "Installing packages with Nix if not already present."

    for pkg in "${PACKAGES[@]}"; do
        if nix-env -q "$pkg" >/dev/null 2>&1; then
            echo "✓ $pkg is already installed."
        else
            echo "→ Installing $pkg."
            nix-env -iA "nixpkgs.$pkg"
        fi
    done
}


# Backup .zshrc (run as original user)
backup_zshrc() {
    if sudo -u "$USER_NAME" [ -f "$ZSHRC_PATH" ]; then
        echo "Backing up existing .zshrc."
        sudo -u "$USER_NAME" cp "$ZSHRC_PATH" "$ZSHRC_BACKUP_PATH"
    fi
}

# Append settings to .zshrc (run as original user)
append_to_zshrc() {
    echo "Appending configurations to .zshrc."
    sudo -u "$USER_NAME" bash -c "cat >> '$ZSHRC_PATH'" <<'EOF'
# Aliases
alias a="sudo apt update && sudo apt install"
alias sc="sudo systemctl"
alias ls="eza -al --long --header --color=always --group-directories-first"

# Load zoxide if available
if command -v zoxide &> /dev/null; then
    eval "$(zoxide init zsh)"
fi

# Load Nix environment if available (for global installation)
if [ -f /etc/profile.d/nix.sh ]; then
    source /etc/profile.d/nix.sh
fi

EOF
}

# Main
install_packages_with_nix
backup_zshrc
append_to_zshrc

echo "06 - CLI tools configured and .zshrc updated. Restart your terminal to apply changes."
