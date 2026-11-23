#!/usr/bin/env bash

set -e

SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
INSTALL_DIR="/usr/local/share/devcontainer-ssh-setup"

mkdir -p "$INSTALL_DIR"
cp "$SCRIPT_DIR/setup-ssh.sh" "$INSTALL_DIR/setup-ssh.sh"
chmod 755 "$INSTALL_DIR/setup-ssh.sh"
ln -sf "$INSTALL_DIR/setup-ssh.sh" /usr/local/bin/devcontainer-ssh-setup

echo 'Done!'
