# restic-backup-explorer

Simple Docker container to view Restic backups

## Getting Started

To support Restic's fuse capabilities, you need to pass the `--privileged` flag. Restic is mounting the repo set `RESTIC_REPO`.

```bash
docker run \
  --privileged \
  --device /dev/fuse \
  -p 8080:8080 \
  -e RESTIC_REPO \
  -e RESTIC_PASSWORD \
  justmiles/restic-backup-explorer:latest
```
