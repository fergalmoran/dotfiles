#!/usr/bin/env bash
virsh domstate win11 | grep running
if [ $? -ne 0 ] ; then
  echo "Starting VM"
  virsh start win11
else
  echo "Connecting to VM"
fi 

virt-viewer -f \
  --hotkeys=toggle-fullscreen=ctrl+f11,release-cursor=ctrl+alt \
  win11 &
