#!/usr/bin/env bash
source ~/.prv/env
ip=$(curl -s -X GET https://checkip.amazonaws.com)
zone="ferg.al"
dnsrecord="home.$zone"

echo "Current IP is $ip"

cloudflare_auth_email=$CLOUDFLARE_EMAIL
cloudflare_auth_key=$CLOUDFLARE_KEY

zoneid=$(curl -s -X GET "https://api.cloudflare.com/client/v4/zones?name=$zone&status=active" \
    -H "X-Auth-Email: $cloudflare_auth_email" \
    -H "X-Auth-Key: $cloudflare_auth_key" \
    -H "Content-Type: application/json" | jq -r '{"result"}[] | .[0] | .id')

echo "Zoneid for $zone is $zoneid"

dnsrecordid=$(curl -s -X GET "https://api.cloudflare.com/client/v4/zones/$zoneid/dns_records?type=A&name=$dnsrecord" \
    -H "X-Auth-Email: $cloudflare_auth_email" \
    -H "X-Auth-Key: $cloudflare_auth_key" \
    -H "Content-Type: application/json" | jq -r '{"result"}[] | .[0] | .id')

echo "DNSrecordid for $dnsrecord is $dnsrecordid"

curl -s -X PUT "https://api.cloudflare.com/client/v4/zones/$zoneid/dns_records/$dnsrecordid" \
    -H "X-Auth-Email: $cloudflare_auth_email" \
    -H "X-Auth-Key: $cloudflare_auth_key" \
    -H "Content-Type: application/json" \
    --data "{\"type\":\"A\",\"name\":\"$dnsrecord\",\"content\":\"$ip\",\"ttl\":1,\"proxied\":false}" | jq
