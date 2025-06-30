#!/bin/sh

set -e

# Check for Nix installation
if ! command -v nix-env &>/dev/null; then
    echo "Nix is not installed. Please install Nix before running this script."
    exit 1
else
	echo "Installing ranger, eza, and zoxide with Nix"
	nix-env -iA nixpkgs.ranger
	nix-env -iA nixpkgs.eza
	nix-env -iA nixpkgs.zoxide
fi

# Backup existing .zshrc
if [ -f "$HOME/.zshrc" ]; then
    echo "Backing up existing .zshrc"
    cp "$HOME/.zshrc" "$HOME/.zshrc.backup.$(date +%s)"
fi

# Write minimal zshrc with alias and zoxide setup
tee -a "$HOME/.zshrc" <<'EOF'
# Aliases
alias a='sudo apt update && sudo apt install'
alias sysctl='sudo systemctl'
alias ls='eza -al --long --header --color=always --group-directories-first'

# Load zoxide if available
if command -v zoxide &> /dev/null; then
    eval "$(zoxide init zsh)"
fi

# Load Nix environment if available (for global installation)
if [ -f /etc/profile.d/nix.sh ]; then
    source /etc/profile.d/nix.sh
fi

EOF

echo "Zsh setup complete. Restart your terminal to start using it."
