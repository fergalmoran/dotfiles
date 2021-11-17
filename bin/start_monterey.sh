#!/usr/bin/env bash
docker run -it \
    --device /dev/kvm \
    -p 50922:10022 \
    -v "/opt/VM/OSX-Monterey/mac_hdd_ng.img:/image" \
    -v /tmp/.X11-unix:/tmp/.X11-unix \
    -e "DISPLAY=${DISPLAY:-:0.0}" \
    sickcodes/docker-osx:naked
