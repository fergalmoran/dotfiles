#!/usr/bin/env bash
xhost +
docker run -it \
    --device /dev/kvm \
    -p 50922:10022 \
    -v /tmp/.X11-unix:/tmp/.X11-unix \
    -v /opt/VM/OSX/ventura/mac_hdd_ng.img:/image \
    -e "DISPLAY=${DISPLAY:-:0.0}" \
    sickcodes/docker-osx:naked
