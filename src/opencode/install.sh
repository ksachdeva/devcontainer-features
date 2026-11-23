#!/usr/bin/env bash

set -e

VERSION="${VERSION:-latest}"
INSTALL="${INSTALL:-true}"
STORAGEDIR="/opencode-storage"

if [ -z "${_REMOTE_USER:-}" ]; then
    echo "_REMOTE_USER is not set; cannot prepare writable OpenCode storage for the remote user." >&2
    exit 1
fi

# A volume mounted here inherits this ownership on first use
mkdir -p "$STORAGEDIR"
chown -R "$_REMOTE_USER" "$STORAGEDIR"

if [ "$INSTALL" = "true" ]; then
    if ! command -v npm >/dev/null 2>&1; then
        echo "npm not found: add the node feature (installsAfter handles ordering) or set install=false." >&2
        exit 1
    fi
    npm install -g "opencode-ai@${VERSION}"
fi

echo 'Done!'
