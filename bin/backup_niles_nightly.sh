#!/usr/bin/env bash
ENV=$HOME/.prv/env
RCACCOUNT=ferglieback
BOX=ferglieback

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
        noodles.fergl.ie:/opt /mnt/frasier/backups/noodles
}
function backup_dev() {
    echo Backing up dev to frasier
    rsync \
        --delete \
        --force \
        --delete-excluded \
        -auvh \
        --exclude=node_modules \
        --exclude=bin \
        --exclude=obj \
        --exclude=packages \
        --exclude=.env \
        --exclude=.gradle \
        --exclude=.next \
        --exclude=.angular \
        --exclude=build \
        /srv/dev/ \
        fergalm@frasier:/srv/dev

    echo Backing up dev to hetzner
    rsync -e 'ssh -p23' \
        --delete \
        -auvh \
        --exclude=node_modules \
        --exclude=bin \
        --exclude=obj \
        --exclude=packages \
        --exclude=.gradle \
        --exclude=.next \
        --exclude=.angular \
        --exclude=build \
        /srv/dev $HETZNER_USER@$HETZNER_USER.your-storagebox.de:backups/
}
function backup_git() {
    echo Mirroring github repos
    python /srv/dev/working/github-gitea-mirror/mirror.py
    echo Backup up git
    git-backup -backup.path /mnt/frasier/backups/git/ -config.file /mnt/frasier/backups/git/git-backup-config.yml
}

function backup_mail() {
    echo Cleaning up mail server
    ssh mail.fergl.ie "find /opt/backups/* -type f -mtime +7 -exec sudo rm {} \;"

    echo Backing up mail server
    ssh mail.fergl.ie sudo tar -zcvf "/opt/backups/mailcow-$(date '+%Y-%m-%d').tgz" /opt/mailcow/

    rsync --rsync-path="sudo rsync" \
        --delete \
        -auvh \
        mail.fergl.ie:/opt/backups/ /mnt/frasier/backups/mail/
}

function backup_audio() {
    echo Backing up audio to hetzner
    rsync -e 'ssh -p23' \
        --delete \
        -auvh \
        /mnt/frasier/audio $HETZNER_USER@$HETZNER_USER.your-storagebox.de:backups/
}
function backup_kubes() {
    # Need to have $USER ssh keys in /root/.ssh/ for this to work :(

    rsync --rsync-path="sudo rsync" \
        -auvh \
        cluster-master:/srv/storage/configs /mnt/frasier/backups/kubes/
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

    echo Backup up system config and boot files
    sudo rsync -Pav --delete -e "ssh -i $HOME/.ssh/id_rsa" /boot/ fergalm@frasier://srv/backups/niles/system/boot/
    sudo rsync -Pav --delete -e "ssh -i $HOME/.ssh/id_rsa" /etc/ fergalm@frasier://srv/backups/niles/system/etc/
    sudo rsync -Pav --delete -e "ssh -i $HOME/.id_rsa" /etc/ fergalm@frasier://srv/backups/niles/system/etc/

    echo Backup local wallets
    rsync -e 'ssh -p23' \
        -auvh \
        $HOME/.electrum \
        $HETZNER_USER@$HETZNER_USER.your-storagebox.de:backups/prv/localwallets/

    echo Backup env
    rsync -e 'ssh -p23' \
        --delete \
        -auvh \
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
function backup_router() {
    echo Backing up router
    rsync root@10.1.1.254:/etc /mnt/frasier/backups/router
}
function backup_frasier() {
    echo Backing up backups to hetzner
    rsync -e 'ssh -p23' \
        --delete \
        -auvh \
        /mnt/frasier/backups/ $HETZNER_USER@$HETZNER_USER.your-storagebox.de:backups/frasier/

    echo Backing up frasier keys to hetzner
    rsync -e 'ssh -p23' \
        --delete \
        -auvh \
        /mnt/frasier/sharing/ $HETZNER_USER@$HETZNER_USER.your-storagebox.de:backups/frasier/sharing
}
function tbd() {
    echo Backing up Documents to hetzner
    rsync -e 'ssh -p23' \
        --delete \
        -auvh \
        $HOME/Documents/ \
        $HETZNER_USER@$HETZNER_USER.your-storagebox.de:backups/documents/

    echo Backing up VMs to box
    rclone sync -v --ignore-errors --stats 10s --stats-log-level INFO \
        /opt/VM/ \
        box_large_file:vms

    echo Backing up Downloads to box
    rclone sync -v --stats 10s --stats-log-level INFO \
        $HOME/Downloads \
        box_large_file:backups/downloads

}
read_env
sudo mount /mnt/frasier
sudo mount /mnt/kubes

backup_dev
backup_git
backup_mail
backup_audio
backup_kubes
backup_noodles
backup_media_hosts
backup_frasier
backup_router
backup_local
tbd
exit 0
