#!/usr/bin/env bash

docker run -d \
 --name jellyfin \
 --restart always \
 --user 1000:1000 \
 --net=host \
 -p 8096:8096 \
 -v /srv/jellyfin/config:/config \
 -v /srv/jellyfin/cache:/cache \
 -v /mnt/storage/media:/media \
 --restart=unless-stopped \
 jellyfin/jellyfin


