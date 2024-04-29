#!/usr/bin/env bash

DOMAIN=${1:-win11} 
BACKUP_CONFIG=/home/fergalm/dotfiles/virsh-win11-backup.xml
BACKUP_PATH=/mnt/storage/backups/vms/libvirt/$DOMAIN
XML_BACKUP=$BACKUP_PATH/$DOMAIN.xml
BACKUP_IMAGE=$BACKUP_PATH/$DOMAIN.disk
OLD_BACKUP_IMAGE=$BACKUP_PATH/$DOMAIN.disk.$(date "+%Y.%m.%d-%H.%M.%S")

function backup_to_box (){
  sudo rclone sync \
    /mnt/storage/backups/vms/libvirt/win11/ \
    box-backups:/vms/win11/
}
echo BACKUP_IMAGE $BACKUP_IMAGE
echo OLD_BACKUP_IMAGE $OLD_BACKUP_IMAGE
if [[ -f $BACKUP_IMAGE ]]; then
  echo Moving old image
  sudo mv $BACKUP_IMAGE $OLD_BACKUP_IMAGE
fi

echo Starting VM
# start VM if not running
virsh domstate $DOMAIN | grep running
if [ $? -ne 0 ] ; then
  echo "Starting VM"
  virsh start $DOMAIN
else
  echo "Connecting to VM"
fi 

# start the actual backup
echo Dumping XML
virsh dumpxml $DOMAIN > $XML_BACKUP

echo Backing up disk file
virsh backup-begin $DOMAIN --backupxml $BACKUP_CONFIG

echo Waiting for job exit
virsh event $DOMAIN --event block-job
echo Deleting previous image
sudo rm $OLD_BACKUP_IMAGE

if [ "$2" == "remote" ]; then
  backup_to_box
fi
