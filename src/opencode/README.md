
# OpenCode (with writable storage) (opencode)

Installs the OpenCode CLI and prepares a writable storage directory for its database

## Example Usage

```json
"features": {
    "ghcr.io/ksachdeva/devcontainer-features/opencode:1": {}
}
```

## Options

| Options Id | Description | Type | Default Value |
|-----|-----|-----|-----|
| version | opencode-ai npm version to install. | string | latest |
| install | Install the CLI. Set to false to only prepare the storage directory. | boolean | true |

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


---

_Note: This file was auto-generated from the [devcontainer-feature.json](https://github.com/ksachdeva/devcontainer-features/blob/main/src/opencode/devcontainer-feature.json).  Add additional notes to a `NOTES.md`._
