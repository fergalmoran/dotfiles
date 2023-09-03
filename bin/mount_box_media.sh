#!/usr/bin/env bash
export RCLONE_CHUNKER_CHUNK_SIZE=5Gi

rclone mount \
    --vfs-read-chunk-size=64M \
    --vfs-read-chunk-size-limit=$RCLONE_CHUNKER_CHUNK_SIZE \
    --vfs-cache-max-size=500G \
    --vfs-read-ahead=256M \
    --vfs-cache-mode=full \
    --vfs-cache-max-age=720h \
    --buffer-size=64M \
    --dir-cache-time=168h \
    --use-mmap \
    --async-read=true \
    box-media-large: /mnt/misc &
