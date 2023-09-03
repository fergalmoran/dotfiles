#!/usr/bin/env bash

sudo certbot certonly \
    --dns-cloudflare \
    --dns-cloudflare-credentials /home/fergalm/.prv/cloudflare.ini \
    -d $1 \
    --preferred-challenges dns-01
