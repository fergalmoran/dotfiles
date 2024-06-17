#!/usr/bin/env bash

is_mounted() {
  mount | awk -v DIR="$1" '{if ($3 == DIR) { exit 0}} ENDFILE{exit -1}'
}
source $HOME/.prv/env
sudo chown fergalm /home/fergalm/.config/rclone/rclone.conf

if ! is_mounted "/mnt/storage"; then
 sudo mount /mnt/storage
fi

if ! is_mounted "/mnt/storage"; then
  echo Backup drive is not mounted
  exit 0
fi
export RCLONE_CHUNKER_CHUNK_SIZE=5Gi
echo "Drive mounted... let's go"


echo "Syncing tv shows"
rclone sync -v \
	--ignore-errors \
	--stats 10s \
	--stats-log-level INFO \
    /mnt/storage/media/tv/ \
    box-media:/tv/

echo "Syncing movies"
rclone sync -v \
	--ignore-errors \
	--stats 10s \
	--stats-log-level INFO \
    /mnt/storage/media/movies/ \
    box-media:/movies/

echo Updating Jellyfin Library
curl -v -d "" -H "X-MediaBrowser-Token: $JELLYFIN_API_KEY" https://tv.ferg.al/library/refresh
