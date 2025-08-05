#!/usr/bin/env bash
set -e

# Default marker directory, can be overridden by Makefile or config.sh
: "${MARKER_DIR:=/var/log/debian-setup}"

check_marker() {
  local script_name
  script_name="$(basename "$0")"
  local marker_file="${MARKER_DIR}/${script_name}.done"

  if [ -f "$marker_file" ]; then
    echo "[SKIP] $script_name already completed. Skipping."
    exit 0
  fi

  mkdir -p "$MARKER_DIR"
  trap "touch '$marker_file'" EXIT
}

require_root() {
    if [ "$(id -u)" -ne 0 ]; then
        echo "This script must be run as root" >&2
        exit 1
    fi
}

install_packages() {
    echo "Installing packages: $*"
    apt update && apt install -y "$@"
}

cleanup_repo_dir() {
    local repo_dir="$1"
    if [ -d "$repo_dir" ]; then
        rm -rf "$repo_dir"
    fi
}

