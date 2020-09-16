#!/usr/bin/env bash

echo Backup boot
tar zcfv /tmp/frasier-boot.tar.gz /boot
scp /tmp/frasier-boot.tar.gz niles:/srv/sharing/backups/frasier/system

echo Backup up config files
scp /etc/hosts niles:/srv/sharing/backups/frasier/system
scp /etc/fstab niles:/srv/sharing/backups/frasier/system
scp /home/fergalm/.zsh_history niles:/srv/sharing/backups/frasier/home

rsync --delete --recursive --archive --progress /home/fergalm/.ssh niles:/srv/sharing/backups/frasier/home
rsync --delete --recursive --archive --progress /home/fergalm/.docker niles:/srv/sharing/backups/frasier/home
rsync --delete --recursive --archive --progress /home/fergalm/.kube niles:/srv/sharing/backups/frasier/home

echo Backing up config to NILES
rsync --archive \
    --delete \
    --progress \
    --human-readable \
    --exclude google-chrome-unstable \
    --exclude google-chrome \
    --exclude "Code - Insiders" \
    ~/.config niles:/srv/sharing/backups/frasier/system/.config

echo Backing up dev to NILES
if [1=0]
then
    rsync --archive \
        --delete \
        --progress \
        --human-readable \
        --exclude '*node_modules*' \
        --exclude '*/.debris/' \
        ~/dev niles:/srv/dev
fi
echo Housekeeping
ssh niles 'find /srv/kubes/configs/sonarr/Backups/* -type f -mtime +7 -exec rm {} \;'
ssh niles 'find /srv/kubes/configs/radarr/Backups/* -type f -mtime +7 -exec rm {} \;'

echo Backing up NILES kubes to BOX
ssh niles 'rclone copy --copy-links -v --stats 5m --stats-log-level INFO /srv/kubes BOX:backups/kubes'

echo Backing up NILES audio to BOX
ssh niles 'rclone copy --copy-links -v --stats 5m --stats-log-level INFO /srv/audio BOX:backups/audio'

echo Backing up NILES dev to BOX
# ssh niles 'rclone copy --copy-links -v --stats 5m --stats-log-level INFO /srv/dev BOX:backups/dev'

echo Backing up NILES sharing to BOX
ssh niles 'rclone copy --copy-links -v --stats 5m --stats-log-level INFO /srv/sharing BOX:backups/sharing'
