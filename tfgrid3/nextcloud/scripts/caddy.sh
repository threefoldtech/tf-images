#!/bin/bash
export DOMAIN=$NEXTCLOUD_DOMAIN

if $IPV4 && ! $GATEWAY; then
  export PORT=443

  # Wait for DNS to propagate
  interface=$(ip route show default | cut -d " " -f 5)
  ipv4_address=$(ip a show $interface | grep -Po 'inet \K[\d.]+')
  while ! dig $DOMAIN | grep -q $ipv4_address; do
    sleep 5
  done
else
  export PORT=80
fi

caddy run --config /etc/caddy/Caddyfile
