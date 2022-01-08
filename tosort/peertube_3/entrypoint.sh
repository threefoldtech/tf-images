#!/bin/sh


if ! grep -q "$SSH_KEY" /root/.ssh/authorized_keys; then
    echo $SSH_KEY >> /root/.ssh/authorized_keys
fi

service ssh start


export PATH=$PATH:/usr/local/bin
chmod 0640 /etc/ssl/private/ssl-cert-snakeoil.key
echo "127.0.0.1 localhost" >> /etc/hosts

service postgresql start
redis-server --daemonize yes

if [ -z "$(ls -A /config)" ]; then
    cp /app/support/docker/production/config/* /config
fi

# Always copy default and custom env configuration file, in cases where new keys were added
cp /app/config/default.yaml /config
cp /app/support/docker/production/config/custom-environment-variables.yaml /config

cd /app
NODE_CONFIG_DIR=/config NODE_ENV=production npm start

