#!/usr/bin/env bash

create_initial_image() {
    docker run -it \
        --device /dev/kvm \
        -p 50922:10022 \
        -e RAM=16 \
        -e SMP=4 \
        -e CORES=4 \
        -e DEVICE_MODEL="iMacPro1,1" \
        -e WIDTH=3840 \
        -e HEIGHT=2160 \
        -v /tmp/.X11-unix:/tmp/.X11-unix \
        -e "DISPLAY=${DISPLAY:-:0.0}" \
        -e GENERATE_UNIQUE=true \
        -e MASTER_PLIST_URL=https://raw.githubusercontent.com/sickcodes/osx-serial-generator/master/config-custom.plist \
        sickcodes/docker-osx:big-sur
}

boot_existing_image() {
    docker run -it \
        --device /dev/kvm \
        -p 50922:10022 \
        -e RAM=16 \
        -e SMP=4 \
        -e CORES=4 \
        -e DEVICE_MODEL="iMacPro1,1" \
        -e WIDTH=1920 \
        -e HEIGHT=1080 \
        -v /tmp/.X11-unix:/tmp/.X11-unix \
        -v /opt/VM/OSX-BigSurDocker/mac_hdd_ng.img:/image \
        -e "DISPLAY=${DISPLAY:-:0.0}" \
        -e GENERATE_UNIQUE=true \
        -e MASTER_PLIST_URL=https://raw.githubusercontent.com/sickcodes/osx-serial-generator/master/config-custom.plist \
        sickcodes/docker-osx:naked
}
boot_existing_image
