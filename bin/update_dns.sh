#!/usr/bin/env bash

WAN_IP=$(dig +short txt ch whoami.cloudflare @1.0.0.1 | sed 's/"//g')
echo Home IP is $WAN_IP

dnscontrol push \
  --config /srv/dev/sites/dns/dnsconfig.js \
  --creds /srv/dev/sites/dns/creds.json \
  -v WAN_IP=$WAN_IP
