#!/bin/sh

set -euo pipefail

# Define paths and configurations
ZSHRC_PATH="$HOME/.zshrc"
ZSHRC_BACKUP_PATH="$HOME/.zshrc.backup.$(date +%s)"

# Function to check and install packages using Nix
install_packages_with_nix() {
    echo "Checking for Nix installation."
    if ! command -v nix-env >/dev/null; then
        echo "Nix is not installed. Please install Nix before running this script."
        exit 1
    fi

    echo "Installing packages with Nix."
    nix-env -iA nixpkgs.ranger
    nix-env -iA nixpkgs.eza
    nix-env -iA nixpkgs.zoxide
}

# Function to backup existing .zshrc
backup_zshrc() {
    if [ -f "$ZSHRC_PATH" ]; then
        echo "Backing up existing .zshrc."
        cp "$ZSHRC_PATH" "$ZSHRC_BACKUP_PATH"
    fi
}

# Function to append configurations to .zshrc
append_to_zshrc() {
    echo "Appending configurations to .zshrc."
    tee -a "$ZSHRC_PATH" <<EOF
# Aliases
alias a="sudo apt update && sudo apt install"
alias sysctl="sudo systemctl"
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

# Main script execution
install_packages_with_nix
backup_zshrc
append_to_zshrc

echo "06 - Cli tools configured to zsh. Restart your terminal to start using it."
