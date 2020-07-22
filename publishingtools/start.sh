#!/bin/bash

ssh-keygen -A
echo "127.0.0.1       localhost" > /etc/hosts
echo "PermitRootLogin yes" >> /etc/ssh/sshd_config
echo "StrictHostKeyChecking no" >> /etc/ssh/ssh_config
chmod -R 500 /etc/ssh
service ssh restart
echo $SSHKEY > /root/.ssh/authorized_keys
cat > /config.toml << EOF
[server]
addr = "0.0.0.0" 
port = 3000

[[$TYPE]]
name = "entrypoint"
title = "$TITLE"
url = "$URL"
branch = "$BRANCH"
EOF
exec /usr/local/bin/tfweb -c /config.toml &> tfweb.log &
exec caddy reverse-proxy --from $DOMAIN --to 0.0.0.0:3000/entrypoint