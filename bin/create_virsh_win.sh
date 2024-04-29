#!/usr/bin/env bash

[[ -z "$1" ]] && { echo "Please supply VM name" ; exit 1; }

virt-install --name $1 \
  --cdrom /home/fergalm/Downloads/en-gb_windows_11_business_editions_version_23h2_x64_dvd_2eed2cb1.iso \
  --os-variant=win11 \
  --network network=default,model=virtio \
  --disk size=150,cache=none,bus=virtio \
  --disk path=/home/fergalm/Downloads/virtio-win-0.1.240.iso,device=cdrom \
  --memory 16384 \
  --sound none \
  --graphics spice,listen=0.0.0.0 \
  --vcpu 8 \
  --video qxl \
  --noautoconsole \
  --features kvm_hidden=on,smm=on \
  --tpm backend.type=emulator,backend.version=2.0,model=tpm-tis
