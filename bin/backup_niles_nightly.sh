#!/usr/bin/env bash
ENV=$HOME/.prv/env
RCACCOUNT=ferglieback
BOX=ferglieback

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

#sudo rsync --delete --recursive --archive --progress /etc/ fergalm@frasier://srv/sharing/backups/niles/system/etc/

echo Backup up home to NILES
rsync --delete --recursive --archive --progress --ignore-errors \
    --exclude '.cache/' \
    --exclude '.zoom/' \
    --exclude '.npm/' \
    --exclude '.android/' \
    --exclude '.gradle/' \
    --exclude '.wine32/' \
    --exclude '.config/Code**' \
    --exclude '.config/azuredatastudio/Cache*' \
    --exclude '.config/discord/' \
    --exclude '.config/Slack/' \
    --exclude '.config/google-chrome/' \
    --exclude '.config/microsoft-edge*' \
    --exclude '.local/share/Google*' \
    --exclude '.local/share/JetBrains*' \
    --exclude '.local/share/NuGet*' \
    --exclude '.local/share/data/Mega Limited/' \
    --exclude '.config/discord/' \
    --exclude '.config/yarn/' \
    --exclude '.megaCmd/' \
    --exclude '.java' \
    --exclude '.nuget' \
    --exclude '.vscode*' \
    --exclude 'Downloads/' \
    --exclude '.gradle' \
    --exclude '*node_modules*' \
    --exclude '*pg_data/**' \
    --exclude '*.next/**' \
    --exclude '*/bin/*' \
    --exclude '*/obj/*' \
    --exclude '*/.debris/' \
    /home/fergalm/ \
    frasier:/srv/sharing/backups/niles/home

echo Backing up ssh to box
rclone sync -v --ignore-errors --stats 10s --stats-log-level INFO \
    /home/fergalm/.ssh \
    $BOX:backups/ssh/niles

echo Backing up home config to box
rclone sync -v --ignore-errors --stats 10s --stats-log-level INFO \
    --fast-list \
    --exclude 'Code**' \
    --exclude 'azuredatastudio/Cached**' \
    --exclude 'azuredatastudio/logs/' \
    --exclude 'Postman/' \
    --exclude 'cache*/*' \
    --exclude 'Cache*/*' \
    --exclude 'Slack/' \
    --exclude 'Signal/' \
    --exclude 'discord/' \
    --exclude 'yarn/' \
    --exclude '/google-chrome**' \
    --exclude '/microsoft-edge**' \
    --exclude '/microsoft-edge**' \
    --exclude 'java/' \
    /home/fergalm/.config \
    $AZUREBLOB:nileshome/.config

echo Backing up home to azure
rclone sync -v --stats 10s --stats-log-level INFO \
    --exclude '.*/' \
    --exclude '.config/' \
    --exclude 'dotnet/' \
    --exclude 'dev/' \
    --exclude 'Downloads/' \
    --exclude '*node_modules/**' \
    --exclude '*pg_data/**' \
    --exclude '*bin/**' \
    --exclude '*obj/**' \
    /home/fergalm/ \
    $AZUREBLOB:nileshome

echo Backing up Downloads to box
rclone sync -v --stats 10s --stats-log-level INFO \
    /home/fergalm/Downloads \
    $BOX:backups/downloads

echo Backing up FRASIER kubes to BOX
ssh frasier 'sudo rclone sync -v --ignore-errors --stats 10s --stats-log-level INFO /srv/kubes BOX:backups/kubes'

echo Backing up FRASIER audio to BOX
ssh frasier 'sudo rclone sync -v --ignore-errors --stats 10s --stats-log-level INFO /srv/audio BOX:backups/audio'
