#!/usr/bin/env bash
source $HOME/.prv/env
docker run -d \
    --name mongo \
    --restart always \
    -p 27017:27017 \
    -v /mnt/storage/hosts/api/mongo/data:/data/db \
    mongo
