#!/usr/bin/env bash
source $HOME/.prv/env
docker run -d \
    --name postgres \
    --restart always \
    -e POSTGRES_PASSWORD=$PGPASSWORD \
    -p 5432:5432 \
    -e PGDATA=/var/lib/postgresql/data/pgdata \
    -v /opt/pg-data:/var/lib/postgresql/data \
    postgres:15 -c log_statement=all
