#!/bin/sh

set -e

echo "Installing Zsh"
sudo apt update
sudo apt install -y zsh

# Set Zsh as default shell
if [ "$SHELL" != "$(which zsh)" ]; then
    echo "Setting Zsh as your default shell"
    chsh -s "$(which zsh)"
fi

# Backup existing .zshrc
if [ -f "$HOME/.zshrc" ]; then
    echo "Backing up existing .zshrc"
    cp "$HOME/.zshrc" "$HOME/.zshrc.backup.$(date +%s)"
fi

# Write minimal zshrc
tee "$HOME/.zshrc" <<'EOF'
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

echo "Zsh setup complete. Restart your terminal to start using it."
