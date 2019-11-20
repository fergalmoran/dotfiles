#! /usr/bin/env bash

sudo chown fergalm /home/fergalm/.config/rclone/rclone.conf
rclone copy \
	/home/fergalm/dev BOX:backups/frasier/dev \
	--exclude="**/node_modules/**" \
	--exclude="**/bin/**" \
	--exclude="**/obj/**" \
	-v --stats 5m --stats-log-level INFO
