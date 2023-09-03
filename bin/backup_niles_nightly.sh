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
function backup_noodles() {
    echo Backing up rocket chat
    docker --context noodles \
        run -it --rm \
        --net traefik_proxy \
        --link rocket-chat-mongodb-1 \
        -v /opt/ferglie-chat/backups:/backups \
        bitnami/mongodb:4.4 mongodump -h rocket-chat-mongodb-1 -o /backups/

    echo Rsyncing containers
    rsync --rsync-path="sudo rsync" \
        --delete \
        -auvh \
        noodles.fergl.ie:/opt /mnt/storage/backups/noodles
}
function backup_dev() {
    echo Backing up dev to storage
    rsync \
        --delete \
        --force \
        --delete-excluded \
        -auvh \
        --exclude=node_modules \
        --exclude=.next \
        --exclude=.yarn \
        --exclude=.pnpm-store \
        --exclude=bin \
        --exclude=obj \
        --exclude=packages \
        --exclude=.gradle \
        --exclude=.angular \
        --exclude=build \
        /srv/dev/ \
        storage.l.fergl.ie://srv/storage/backups/dev

    echo Backing up dev to box
    rclone sync --progress \
        --delete-excluded \
        --skip-links \
        --ignore-case-sync \
        --exclude=node_modules/ \
        --exclude=.next/ \
        --exclude=.krud/ \
        --exclude=.yarn/ \
        --exclude=.pnpm-store/ \
        --exclude=bin/ \
        --exclude=obj/ \
        --exclude=packages/ \
        --exclude=.gradle/ \
        --exclude=.angular/ \
        --exclude=build/ \
        /srv/dev box:/dev
}
function backup_git() {
    echo Mirroring github repos
    python /srv/dev/working/github-gitea-mirror/mirror.py
    echo Backup up git
    git-backup -backup.path /mnt/storage/backups/git/ -config.file /mnt/storage/backups/git/git-backup-config.yml
}

function backup_mail() {
    echo Cleaning up mail server
    ssh mail.fergl.ie "find /opt/backups/* -type f -mtime +7 -exec sudo rm {} \;"

    echo Backing up mail server
    ssh mail.fergl.ie sudo tar -zcvf "/opt/backups/mailcow-$(date '+%Y-%m-%d').tgz" /opt/mailcow/

    rsync --rsync-path="sudo rsync" \
        --delete \
        -auvh \
        mail.fergl.ie:/opt/backups/ /mnt/storage/backups/mail/
}

function backup_audio() {

   echo Backing up audio to box
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
    # Need to have $USER ssh keys in /root/.ssh/ for this to work :(

    rsync --rsync-path="sudo rsync" \
        -auvh \
        cluster-master:/srv/storage/configs /mnt/storage/backups/cluster-configs/
}
function backup_media_hosts() {
    echo Backup Sonarr
    curl 'https://sonarr.fergl.ie/api/v3/command' \
        -H 'content-type: application/json' \
        -H 'accept: application/json, text/javascript, */*; q=0.01' \
        -H "x-api-key: $SONARR_API_KEY" \
        --data-raw '{"name":"Backup"}' \
        --compressed
    echo Backup Radarr
    curl 'https://radarr.fergl.ie/api/v3/command' \
        -H 'content-type: application/json' \
        -H 'accept: application/json, text/javascript, */*; q=0.01' \
        -H "X-Api-Key: $RADARR_API_KEY" \
        --data-raw '{"name":"Backup"}' \
        --compressed

    echo Backup Lidarr
    curl 'https://lidarr.fergl.ie/api/v1/command' \
        -H "X-Api-Key: $LIDARR_API_KEY" \
        -H 'content-type: application/json' \
        --data-raw '{"name":"Backup"}' \
        --compressed
}
function backup_local() {

    echo Backup up system config and boot filesz
    sudo rsync -Pav --delete -e "sudo -u fergalm ssh -i $HOME/.ssh/id_rsa" /boot/ fergalm@storage.fergl.ie://srv/storage/backups/niles/system/boot/
    sudo rsync -Pav --delete -e "sudo -u fergalm ssh -i $HOME/.ssh/id_rsa" /etc/ fergalm@storage.fergl.ie://srv/storage/backups/niles/system/etc/
    sudo rsync -Pav --delete -e "sudo -u fergalm ssh -i $HOME/.ssh/id_rsa" /etc/ fergalm@storage.fergl.ie://srv/storage/backups/niles/system/etc/

    echo Backup dotfiles and scripts
    rsync -e 'ssh -p23' \
        -auvh \
        $HOME/dotfiles \
        $HETZNER_USER@$HETZNER_USER.your-storagebox.de:backups/dotfiles

    echo Backup local wallets
    rsync -e 'ssh -p23' \
        -auvh \
        $HOME/.electrum \
        $HETZNER_USER@$HETZNER_USER.your-storagebox.de:backups/prv/localwallets/

    echo Backup env
    rsync -e 'ssh -p23' \
        --delete \
        -auvh \    rclone sync --progress \
        --delete-excluded \
        --skip-links \
        --ignore-case-sync \
        $ENV \
        $HETZNER_USER@$HETZNER_USER.your-storagebox.de:backups/prv

    echo Backup desktop icons
    rsync -e 'ssh -p23' \
        --delete \
        -auvh \
        $HOME/.local/share/applications/ \
        $HETZNER_USER@$HETZNER_USER.your-storagebox.de:backups/nileshome/desktop-shortcuts/

    rsync -e 'ssh -p23' \
        --delete \
        -auvh \
        $HOME/.prv $HETZNER_USER@$HETZNER_USER.your-storagebox.de:backups/

    echo Backing up ssh keys to hetzner
    rsync -e 'ssh -p23' \
        --delete \
        -auvh \
        $HOME/.ssh $HETZNER_USER@$HETZNER_USER.your-storagebox.de:backups/ssh

    echo Backing up home config to hetzner
    rsync -e 'ssh -p23' \
        --delete \
        -auvh \
        --exclude='azuredatastudio/' \
        --exclude='Code' \
        --exclude='JetBrains' \
        --exclude='opera' \
        --exclude='Code - Insiders' \
        --exclude='Signal/' \
        --exclude='Slack/' \
        --exclude='discord/' \
        --exclude='yarn/' \
        --exclude='Postman/' \
        --exclude='Microsoft/' \
        --exclude='microsoft-edge-dev/' \
        --exclude='chromium/' \
        --exclude='google-chrome/' \
        --exclude='google-chrome-beta/' \
        --exclude='skypeforlinux/' \
        $HOME/.config $HETZNER_USER@$HETZNER_USER.your-storagebox.de:backups/nileshome
}

function tbd() {
    echo Backing up Documents to hetzner
    rsync -e 'ssh -p23' \
        --delete \
        -auvh \
        $HOME/Documents/ \
        $HETZNER_USER@$HETZNER_USER.your-storagebox.de:backups/documents/

    echo Backing up Documents to box
    rclone sync --progress \
        --delete-excluded \
        --skip-links \
        $HOME/Documents/ \
        box-backups:Documents
        
    echo Backing up Downloads to box
    rclone sync -v --stats 10s --stats-log-level INFO \
        $HOME/Downloads \
        box-backups:Downloads

    echo Backing up on site backups to box
    sudo mkdir -p /root/.config/rclone/
    sudo cp $RCLONE_CONFIG /root/.config/rclone/
    sudo rclone sync -v --stats 10s --stats-log-level INFO \
        --delete-excluded \
        --skip-links \
        /mnt/storage/backups \
        box-backups:onprem

    # echo Backing up VMs to box
    # sudo rclone sync -v --ignore-errors --stats 10s --stats-log-level INFO \
    #     /opt/VM/ \
    #     box-backups:vms

}
read_env
sudo mount /mnt/storage
sudo mount /mnt/kubes
sed -i /';yt-dlp/d' ~/.zsh_history
backup_dev
backup_git
backup_audio
tbd
exit
backup_mail
backup_kubes
backup_noodles
backup_media_hosts
backup_frasier
backup_router
backup_local
tbd
exit 0
