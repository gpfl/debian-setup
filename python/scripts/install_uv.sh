#!/usr/bin/env bash
set -euo pipefail

# Directory of this script (parent to env/config.sh)
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/../env/config.sh"

# Marker file to avoid reinstall
MARKER_FILE="$MARKER_DIR/install_uv"

# Skip if already installed
if [[ -f "$MARKER_FILE" ]]; then
    echo "uv already installed. Skipping."
    exit 0
fi

# Get base Python version (default: latest stable)
BASE_PYTHON_VERSION="${1:-$(pyenv install --list | grep -E '^\s*[0-9]+\.[0-9]+\.[0-9]+$' | tail -1 | tr -d ' ')}"

echo "Installing uv in base pyenv Python: $BASE_PYTHON_VERSION"

# Ensure base Python is installed in pyenv
if ! pyenv versions --bare | grep -qx "$BASE_PYTHON_VERSION"; then
    echo "Installing Python $BASE_PYTHON_VERSION via pyenv..."
    pyenv install "$BASE_PYTHON_VERSION"
fi

# Set PYENV_VERSION so uv installs into base pyenv Python
export PYENV_VERSION="$BASE_PYTHON_VERSION"
eval "$(pyenv init -)"
eval "$(pyenv virtualenv-init -)"

# Install uv via official script
curl -LsSf https://astral.sh/uv/install.sh | sh

# Ensure uv bin dir in PATH
if ! grep -q "$HOME/.cargo/bin" "$HOME/.zshrc"; then
    echo 'export PATH="$HOME/.cargo/bin:$PATH"' >> "$HOME/.zshrc"
fi
if ! grep -q "$HOME/.cargo/bin" "$HOME/.zprofile"; then
    echo 'export PATH="$HOME/.cargo/bin:$PATH"' >> "$HOME/.zprofile"
fi

# Source to make uv available immediately
source "$HOME/.zshrc"

# Mark as installed
touch "$MARKER_FILE"

echo "uv installed globally in base pyenv Python ($BASE_PYTHON_VERSION)."