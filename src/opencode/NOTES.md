## Database storage

This feature sets `OPENCODE_DB` to `/opencode-storage/opencode.db` and prepares `/opencode-storage` with write permissions for the remote user. It does not mount a volume. Without a mount, the database is stored in the container filesystem and will not persist when the container is recreated.

To persist the database, add a volume mount to your `devcontainer.json`:

```json
"mounts": [
  "source=${localWorkspaceFolderBasename}-opencode,target=/opencode-storage,type=volume"
]
```

The mount target must be `/opencode-storage` to match `OPENCODE_DB`.

The CLI installation requires npm, for example from the `ghcr.io/devcontainers/features/node` feature.
