#!/usr/bin/env bash
ENV=$HOME/.prv/env
RCLONE_CONFIG=/home/fergalm/.config/rclone/rclone.conf

function read_env() {
  if test -f "$ENV"; then
    echo Reading $ENV
    source $ENV
  else
    echo "$ENV does not exist."
    exit
  fi
}
function backup_postgres() {
  echo Backing up postgres on noodles
  /home/fergalm/dotfiles/bin/backup_pg.sh \
    -h noodles.ferg.al \
    -u postgres \
    -p $NOODLES_PGPWD \
    -d /mnt/storage/backups/postgres/noodles/

  echo Backing up postgres on kubes
  /home/fergalm/dotfiles/bin/backup_pg.sh \
    -h daphne.l.fergl.ie \
    -u postgres \
    -p $CLUSTER_MASTER_PGPWD \
    -d /mnt/storage/backups/postgres/kubes/
}
function backup_noodles() {
  echo Rsyncing noodles
  rsync --rsync-path="sudo rsync" \
    --delete \
    -auvh \
    --exclude-from=$HOME/dotfiles/bin/backup_excludes_noodles.txt \
    noodles.ferg.al:/opt /mnt/storage/backups/noodles
}
function backup_tiny() {
  echo Rsyncing tiny
  rsync --rsync-path="sudo rsync" \
    --delete \
    -auvh \
    --exclude-from=$HOME/dotfiles/bin/backup_excludes_noodles.txt \
    tiny.ferg.al:/opt /mnt/storage/backups/tiny
}
function backup_dev() {
  echo Backing up dev to storage
  rsync \
    --delete \
    --force \
    --delete-excluded \
    -auvh \
    --exclude-from=$HOME/dotfiles/bin/backup_excludes_dev.txt \
    /srv/dev/ \
    martin.l.fergl.ie://srv/storage/backups/dev

  echo Backing up dev to box
  rclone sync --progress \
    --delete-excluded \
    --skip-links \
    --ignore-case-sync \
    --exclude-from=$HOME/dotfiles/bin/backup_excludes_dev.txt \
    /srv/dev box:/dev
}
function backup_git() {
  return
  echo Mirroring github repos
  # python /srv/dev/working/github-gitea-mirror/mirror.py
  # echo Backup up git
  # docker run -v /mnt/storage/backups/github:/backups ghcr.io/chappio/git-backup
}

function backup_audio() {
  echo Backing up audio to storage
  rclone sync --progress \
    --delete-excluded \
    --skip-links \
    --ignore-case-sync \
    /mnt/storage/audio/ /mnt/storage/backups/audio

  echo Backing up audio to box
  rclone sync --progress \
    --delete-excluded \
    --skip-links \
    --ignore-case-sync \
    /mnt/storage/audio/ box-audio:
}
function backup_kubes() {
  echo Backing up Technitium
  wget -O /mnt/storage/backups/technitium/$(date -d "today" +"%Y%m%d%H%M")_technitium.tar.gz \
    http://10.1.1.253:5380/api/settings/backup\?token\=$TECHNITIUM_TOKEN\&blockLists\=true\&logs\=true\&scopes\=true\&stats\=true\&zones\=true\&allowedZones\=true\&blockedZones\=true\&dnsSettings\=true\&logSettings\=true\&authConfig\=true
}
function backup_media_hosts() {
  echo Backup Sonarr
  curl 'https://sonarr.ferg.al/api/v3/command' \
    -H 'content-type: application/json' \
    -H 'accept: application/json, text/javascript, */*; q=0.01' \
    -H "x-api-key: $SONARR_API_KEY" \
    --data-raw '{"name":"Backup"}' \
    --compressed
  echo Backup Radarr
  curl 'https://radarr.ferg.al/api/v3/command' \
    -H 'content-type: application/json' \
    -H 'accept: application/json, text/javascript, */*; q=0.01' \
    -H "X-Api-Key: $RADARR_API_KEY" \
    --data-raw '{"name":"Backup"}' \
    --compressed
}
function backup_local() {

  echo Backup up system config and boot files
  sudo rsync -Pav --delete -e "sudo -u fergalm ssh -i $HOME/.ssh/id_rsa" \  /boot/ /mnt/storage/backups/niles/system/boot
  sudo rsync -Pav --delete -e "sudo -u fergalm ssh -i $HOME/.ssh/id_rsa" \
    /etc/ /mnt/storage/backups/niles/system/etc
  #Not the prettiest but it makes it so much easier to rsync this way
  sudo chown fergalm:fergalm /mnt/storage/backups/niles/system -R

  echo Backing up ssh key
  rsync -e 'ssh -p23' \
    --delete \
    -auvh \
    $HOME/.ssh /mnt/storage/backups/niles/ssh/

  echo Backing up home config
  rsync -e 'ssh -p23' \
    --delete \
    --delete-excluded \
    -auvh \
    --exclude-from=$HOME/dotfiles/bin/backup_excludes_config.txt \
    $HOME/.config /mnt/storage/backups/niles/home/

  echo Backing up home documents
  rsync -e 'ssh -p23' \
    --delete \
    --delete-excluded \
    -auvh \
    $HOME/Documents /mnt/storage/backups/niles/Documents/

  rsync -e 'ssh -p23' \
    --delete \
    --delete-excluded \
    -auvh \
    $HOME/Downloads /mnt/storage/backups/niles/Downloads/
}

function backup_onsite() {

  echo Backing up on site backups to box
  sudo rclone sync \
    --delete-excluded \
    --exclude=.krud/ \
    --exclude=audio/ \
    --exclude=dev/ \
    --exclude=vms/ \
    --config $RCLONE_CONFIG \
    -v --stats 10s --stats-log-level INFO \
    --skip-links \
    /mnt/storage/backups \
    box-backups:onprem
  sudo chown fergalm /home/fergalm/.config/rclone/rclone.conf

  echo Backing up on-site to Hetzner
  rsync --stats -avi -e 'ssh -p23' --recursive \
    /mnt/storage/backups/ $HETZNER_USER@$HETZNER_USER.your-storagebox.de:backups
}
read_env

echo "Mounting required filesystems"
sudo mount /mnt/storage
sudo mount /mnt/kubes
echo "Filesystems mounted - let's go..."
sed -i /';yt-dlp/d' ~/.zsh_history
sed -i /';gocryptfs/d' ~/.zsh_history

sudo chown fergalm /home/fergalm/.config/rclone/rclone.conf

backup_postgres

backup_dev
backup_noodles
backup_tiny
backup_local

backup_kubes
backup_git
backup_audio
backup_media_hosts
backup_onsite
