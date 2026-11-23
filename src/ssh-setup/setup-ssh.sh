#!/usr/bin/env bash
set -euo pipefail

KEY="${HOST_SSH_PUBLIC_KEY:-}"

# SSH integration is completely optional.
if [[ -z "$KEY" ]]; then
    printf '%s\n' 'Skipping SSH setup: HOST_SSH_PUBLIC_KEY is unset or empty.'
    exit 0
fi

mkdir -p "$HOME/.ssh"
chmod 700 "$HOME/.ssh"

AUTHORIZED_KEYS="$HOME/.ssh/authorized_keys"

touch "$AUTHORIZED_KEYS"
chmod 600 "$AUTHORIZED_KEYS"

grep -qxF "$KEY" "$AUTHORIZED_KEYS" ||
    printf '%s\n' "$KEY" >> "$AUTHORIZED_KEYS"

SSH_HOST_KEY_DIR="/ssh-host-keys"
SSH_HOST_KEY="$SSH_HOST_KEY_DIR/ssh_host_ed25519_key"

sudo mkdir -p "$SSH_HOST_KEY_DIR"

if [[ ! -f "$SSH_HOST_KEY" ]]; then
    sudo ssh-keygen \
        -q \
        -t ed25519 \
        -f "$SSH_HOST_KEY" \
        -N ''
fi

sudo chmod 600 "$SSH_HOST_KEY"
sudo chmod 644 "$SSH_HOST_KEY.pub"

sudo mkdir -p /etc/ssh/sshd_config.d

printf '%s\n' \
    "HostKey $SSH_HOST_KEY" |
    sudo tee /etc/ssh/sshd_config.d/99-devcontainer-hostkey.conf >/dev/null

ZSHENV="$HOME/.zshenv"
touch "$ZSHENV"

ZSH_PATH_INIT='export PATH="$HOME/.local/bin:$PATH"'

grep -qxF "$ZSH_PATH_INIT" "$ZSHENV" ||
    printf '\n%s\n' "$ZSH_PATH_INIT" >> "$ZSHENV"

ZSH_SSH_INIT='[[ -n "${SSH_CONNECTION:-}" && -d "${SSH_WORKSPACE:-}" ]] && cd "$SSH_WORKSPACE"'

grep -qxF "$ZSH_SSH_INIT" "$ZSHENV" ||
    printf '%s\n' "$ZSH_SSH_INIT" >> "$ZSHENV"

# sshd starts before postCreateCommand, so restart it to load the persistent host key.
sudo /etc/init.d/ssh restart
