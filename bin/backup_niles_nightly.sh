#!/usr/bin/env bash

echo Backup boot
sudo tar zcfv /tmp/niles-boot.tar.gz /boot
scp /tmp/niles-boot.tar.gz frasier:/srv/sharing/backups/niles/system/
exit

echo Backup up config files

rsync --delete --recursive --archive --progress /etc/ fergalm@frasier://srv/sharing/backups/niles/system

rsync --delete --recursive --archive --progress \
    --exclude '*/.cache/*' \
    --exclude '*node_modules*' \
    --exclude '*/bin/*' \
    --exclude '*/obj/*' \
    --exclude '*/.debris/' \
    /home/fergalm/ \
    frasier:/srv/sharing/backups/niles/home


echo Backup Sonarr
curl 'https://sonarr.fergl.ie/api/v3/command' \
  -H 'content-type: application/json' \
  -H 'accept: application/json, text/javascript, */*; q=0.01' \
  -H 'x-api-key: fc453792ee1c4a51be871074e9c28d8c' \
  --data-raw '{"name":"Backup"}' \
  --compressed
ssh frasier 'find /srv/kubes/configs/sonarr/Backups/* -type f -mtime +7 -exec rm {} \;'

echo Backup Radarr
curl 'https://radarr.fergl.ie/api/v3/command' \
  -H 'X-Api-Key: 66c63ac0e5e5417eae975625d5b509d3' \
  --data-raw '{"name":"Backup"}' \
  --compressed
ssh frasier 'find /srv/kubes/configs/radarr/Backups/* -type f -mtime +7 -exec rm {} \;'

echo Backing up FRASIER niles home to BOX
ssh frasier 'sudo rclone copy -v --stats 5m --stats-log-level INFO /srv/sharing/backups/niles/home BOX:backups/niles_home'

echo Backing up FRASIER niles system to BOX
ssh frasier 'sudo rclone copy -v --stats 5m --stats-log-level INFO /srv/sharing/backups/niles/system BOX:backups/niles_system'

echo Backing up FRASIER kubes to BOX
ssh frasier 'sudo rclone copy -v --stats 5m --stats-log-level INFO /srv/kubes BOX:backups/kubes'

echo Backing up FRASIER kubes to BOX
ssh frasier 'sudo rclone copy -v --stats 5m --stats-log-level INFO /srv/kubes BOX:backups/kubes'

echo Backing up FRASIER audio to BOX
ssh frasier 'sudo rclone copy -v --stats 5m --stats-log-level INFO /srv/audio BOX:backups/audio'

echo Backing up FRASIER sharing to BOX
ssh frasier 'sudo rclone copy -v --stats 5m --stats-log-level INFO /srv/sharing BOX:backups/sharing'
