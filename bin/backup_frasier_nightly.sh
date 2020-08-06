#!/usr/bin/env bash

mkdir -p /mnt/niles/sharing/backups/frasier_nightly/system/

echo Backup up config files
cp /etc/hosts /etc/fstab ~/.zsh_history /mnt/niles/sharing/backups/frasier_nightly/system
cp -rf ~/.zsh_history /mnt/niles/sharing/backups/frasier_nightly/system
cp -rf ~/.ssh /mnt/niles/sharing/backups/frasier_nightly/system
cp -rf ~/.docker /mnt/niles/sharing/backups/frasier_nightly/system
cp -rf ~/.kube /mnt/niles/sharing/backups/frasier_nightly/system

echo Backing up dev to NILES
rsync --archive \
    --delete \
    --progress \
    --human-readable \
    --exclude '*node_modules*' \
    --exclude '*/.debris/' \
    ~/dev /mnt/niles/sharing/backups/frasier_nightly/

echo Backing up config to NILES
rsync --archive \
    --delete \
    --progress \
    --human-readable \
    --exclude google-chrome-unstable \
    --exclude google-chrome \
    --exclude "Code - Insiders" \
    ~/.config /mnt/niles/sharing/backups/frasier_nightly/system/.config

echo Backing up dev to BOX
sudo chown fergalm /home/fergalm/.config/rclone/rclone.conf
rclone copy \
    /home/fergalm/dev BOX:backups/frasier/dev \
    --exclude="**/node_modules/**" \
    --exclude=".debris/**" \
    --exclude="**/bin/**" \
    --exclude="**/obj/**" \
    -v --stats 5m --stats-log-level INFO
