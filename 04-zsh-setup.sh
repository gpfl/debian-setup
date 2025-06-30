#!/bin/sh

# Ensure the script is run as root
if [ "$(id -u)" -ne 0 ]; then
    echo "This script must be run as root" >&2
    exit 1
fi

set -euo pipefail

# Define paths and configurations
ZSHRC_PATH="$HOME/.zshrc"
ZSHRC_BACKUP_PATH="$HOME/.zshrc.backup.$(date +%s)"

# Install Zsh
echo "Installing Zsh."
apt update && apt install -y zsh

# Set Zsh as default shell
if [ "$SHELL" != "$(which zsh)" ]; then
    echo "Setting Zsh as your default shell."
    chsh -s "$(which zsh)"
fi

# Backup existing .zshrc
if [ -f "$ZSHRC_PATH" ]; then
    echo "Backing up existing .zshrc."
    cp "$ZSHRC_PATH" "$ZSHRC_BACKUP_PATH"
fi

# Write minimal zshrc
echo "Writing minimal zshrc."
tee "$ZSHRC_PATH" <<EOF
# ~/.zshrc - Minimal Zsh Setup

# History settings
HISTSIZE=5000
SAVEHIST=5000
HISTFILE=~/.zsh_history

# Prompt
export PROMPT='%n@%m:%~ %# '

# Completion
autoload -Uz compinit
compinit

EOF

echo "04 - Zsh setup complete. Restart your terminal to start using it."

