#!/usr/bin/env bash
ENV=$HOME/.prv/env
if test -f "$ENV"; then
    echo Reading $ENV
    source $ENV
else
    echo "$ENV does not exist."
    exit
fi

echo Backup env
rclone copy -v --stats 10s --stats-log-level INFO $ENV box:backups/prv/

echo Backup Sonarr
curl 'https://sonarr.fergl.ie/api/v3/command' \
    -H 'content-type: application/json' \
    -H 'accept: application/json, text/javascript, */*; q=0.01' \
    -H "x-api-key: $SONARR_API_KEY" \
    --data-raw '{"name":"Backup"}' \
    --compressed
ssh frasier 'find /srv/kubes/configs/sonarr/Backups/* -type f -mtime +7 -exec rm {} \;'

echo Backup Radarr
curl 'https://radarr.fergl.ie/api/v3/command' \
    -H "X-Api-Key: $RADARR_API_KEY" \
    --data-raw '{"name":"Backup"}' \
    --compressed
ssh frasier 'find /srv/kubes/configs/radarr/Backups/* -type f -mtime +7 -exec rm {} \;'

echo Backup boot
sudo tar zcfv /tmp/niles-boot.tar.gz /boot
scp /tmp/niles-boot.tar.gz frasier:/srv/sharing/backups/niles/system/

echo Backup up config files

rsync --delete --recursive --archive --progress /etc/ fergalm@frasier://srv/sharing/backups/niles/system/etc/

rsync --delete --recursive --archive --progress \
    --exclude '.cache/' \
    --exclude '.config/Code - Insiders/Cache*' \
    --exclude '.config/Code/Cache*' \
    --exclude '.config/azuredatastudio/Cache*' \
    --exclude '.config/Slack/' \
    --exclude '.config/google-chrome*' \
    --exclude '.config/microsoft-edge*' \
    --exclude '.local/share/Google*' \
    --exclude '.local/share/JetBrains' \
    --exclude '.local/share/NuGet' \
    --exclude '.local/share/data/Mega Limited/' \
    --exclude '.megaCmd/' \
    --exclude '.nuget' \
    --exclude '.vscode*' \
    --exclude 'Downloads/' \
    --exclude '.gradle' \
    --exclude '*node_modules*' \
    --exclude '*/bin/*' \
    --exclude '*/obj/*' \
    --exclude '*/.debris/' \
    /home/fergalm/ \
    frasier:/srv/sharing/backups/niles/home

echo Backup up Downloads
rclone copy -v --stats 10s --stats-log-level INFO $HOME/Downloads box:downloads/

echo Backing up FRASIER niles home to BOX
ssh frasier 'sudo rclone sync -v --stats 10s --stats-log-level INFO /srv/sharing/backups/niles/home BOX:backups/niles_home'

echo Backing up FRASIER niles system to BOX
ssh frasier 'sudo rclone sync -v --stats 10s --stats-log-level INFO /srv/sharing/backups/niles/system BOX:backups/niles_system'

echo Backing up FRASIER kubes to BOX
ssh frasier 'sudo rclone sync -v --stats 10s --stats-log-level INFO /srv/kubes BOX:backups/kubes'

echo Backing up FRASIER audio to BOX
ssh frasier 'sudo rclone sync -v --stats 10s --stats-log-level INFO /srv/audio BOX:backups/audio'
