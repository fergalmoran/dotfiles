#!/usr/bin/env bash

if [ "$#" -eq "azure" ]
then
  sudo certbot certonly \
      --dns-azure \
      --dns-azure-credentials /home/fergalm/.prv/azure.ini \
      -d $1 \
      --preferred-challenges dns-01
else
  sudo certbot certonly \
      --dns-cloudflare \
      --dns-cloudflare-credentials /home/fergalm/.prv/cloudflare.ini \
      -d $1 \
      --preferred-challenges dns-01
fi
