#!/usr/bin/env bash

set -euo pipefail

# Ensure the script is run as a regular user
if [ "$(id -u)" -eq 0 ]; then
    echo "Do not run this script as root." >&2
    exit 1
fi

# Define variables
PYENV_ROOT="${HOME}/.pyenv"
PYENV_SHELL_CONFIG="${HOME}/.zshrc"
PYENV_PROFILE="${HOME}/.zprofile"

# Install pyenv and pyenv-virtualenv using pyenv.run
if ! command -v pyenv >/dev/null 2>&1; then
    echo "Installing pyenv and pyenv-virtualenv."
    curl https://pyenv.run | bash
else
    echo "pyenv is already installed."
fi

# Add pyenv init to zsh config
echo "Updating ${PYENV_SHELL_CONFIG} and ${PYENV_PROFILE}."

if ! grep -q 'pyenv init' "$PYENV_SHELL_CONFIG"; then
    cat <<'EOF' >> "$PYENV_SHELL_CONFIG"

# Pyenv configuration
export PYENV_ROOT="$HOME/.pyenv"
export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init --path)"
eval "$(pyenv init -)"
eval "$(pyenv virtualenv-init -)"
EOF
fi

if ! grep -q 'pyenv init' "$PYENV_PROFILE"; then
    cat <<'EOF' >> "$PYENV_PROFILE"

# Pyenv configuration (for login shells)
export PYENV_ROOT="$HOME/.pyenv"
export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init --path)"
EOF
fi

# Load pyenv into current shell session
export PYENV_ROOT="$HOME/.pyenv"
export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init --path)"
eval "$(pyenv init -)"
eval "$(pyenv virtualenv-init -)"

# Find and install the latest stable version of Python
echo "Finding latest stable Python version."
LATEST_STABLE=$(pyenv install --list | grep -E '^\s*[0-9]+\.[0-9]+\.[0-9]+$' | grep -v - | tail -1 | tr -d ' ')

echo "Installing Python $LATEST_STABLE."
pyenv install -s "$LATEST_STABLE"

echo "Pyenv and Python $LATEST_STABLE installed and configured successfully."
