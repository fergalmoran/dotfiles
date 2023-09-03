#!/usr/bin/env bash
source $HOME/.prv/env

docker stop mssql
docker rm mssql

docker run \
    --name mssql \
    --restart always \
    -e "ACCEPT_EULA=Y" \
    -e "SA_PASSWORD=$MSSQLPASSWORD" \
    -v /home/fergalm/working/backups:/backups \
    -v /opt/mssql:/var/opt/mssql \
    -p 1433:1433 \
    -d mcr.microsoft.com/mssql/server
