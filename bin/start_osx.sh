#!/usr/bin/env bash
xhost +
docker run -it \
    --device /dev/kvm \
    -p 50922:10022 \
    -v /tmp/.X11-unix:/tmp/.X11-unix \
    -v /opt/vms/osx-docker/sonoma/mac_hdd_ng_auto.img:/image \
    -e "DISPLAY=${DISPLAY:-:0.0}" \
    -e GENERATE_UNIQUE=true \
    sickcodes/docker-osx:sonoma
