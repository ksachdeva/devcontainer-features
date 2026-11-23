## Usage

This feature depends on the Dev Containers `sshd` and `common-utils` features. It runs the SSH setup after container creation. If `HOST_SSH_PUBLIC_KEY` is unset or empty, setup is skipped.

Add the feature and provide the host public key and workspace path in your `devcontainer.json`:

```json
"features": {
  "ghcr.io/ksachdeva/devcontainer-features/ssh-setup:1": {}
},
"containerEnv": {
  "HOST_SSH_PUBLIC_KEY": "${localEnv:DEVCONTAINER_SSH_PUBLIC_KEY}",
  "SSH_WORKSPACE": "${containerWorkspaceFolder}"
}
```

Set `DEVCONTAINER_SSH_PUBLIC_KEY` in the host environment to the public key to authorize.

The SSH server listens on port `2222` by default. Expose it with `forwardPorts`:

```json
"forwardPorts": [2222]
```

Alternatively, map a specific host port with `appPort`, for example host port `2223` to container port `2222`:

```json
"appPort": "2223:2222"
```

The setup generates an SSH host key under `/ssh-host-keys`. To preserve the server identity across container rebuilds, optionally mount a volume there:

```json
"mounts": [
  "source=${localWorkspaceFolderBasename}-ssh-host-keys,target=/ssh-host-keys,type=volume"
]
```

Without this mount, the key remains in the container filesystem and is not preserved across rebuilds.
