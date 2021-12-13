#!/bin/sh

# SSH server
if [ ! -f "/root/.ssh/authorized_keys" ]; then
    mkdir -p /root/.ssh/
    chmod 700 /root/.ssh
    touch /root/.ssh/authorized_keys
    chmod 600 /root/.ssh/authorized_keys
fi

if ! grep -q "$SSH_KEY" /root/.ssh/authorized_keys; then
    echo $SSH_KEY >> /root/.ssh/authorized_keys
fi

service ssh start


# Redis server
if [ ! -z $PEERTUBE_REDIS_HOSTNAME ]; then 
    if ! grep -q "bind $PEERTUBE_REDIS_HOSTNAME" /etc/redis/redis.conf; then
    echo "bind $PEERTUBE_REDIS_HOSTNAME" >> /etc/redis/redis.conf
    fi
fi

if [ ! -z $PEERTUBE_REDIS_HOSTNAME ]; then 
    if ! grep -q "port $PEERTUBE_REDIS_PORT" /etc/redis/redis.conf; then
    echo "port $PEERTUBE_REDIS_PORT" >> /etc/redis/redis.conf
    fi
fi

if [ ! -z $PEERTUBE_REDIS_HOSTNAME ]; then 
    if ! grep -q "requirepass $PEERTUBE_REDIS_AUTH" /etc/redis/redis.conf; then
    echo "requirepass $PEERTUBE_REDIS_AUTH" >> /etc/redis/redis.conf
    fi
fi

redis-server /etc/redis/redis.conf

# service postgresql start &&\
#     su postgres -c "psql --file=/tmp/setup_postgres.sql"



# export PATH=$PATH:/usr/local/bin
# chmod 0640 /etc/ssl/private/ssl-cert-snakeoil.key
# echo "127.0.0.1 localhost" >> /etc/hosts

# service postgresql start
# redis-server --daemonize yes

# if [ -z "$(ls -A /config)" ]; then
#     cp /app/support/docker/production/config/* /config
# fi

# # Always copy default and custom env configuration file, in cases where new keys were added
# cp /app/config/default.yaml /config
# cp /app/support/docker/production/config/custom-environment-variables.yaml /config

# cd /app
# NODE_CONFIG_DIR=/config NODE_ENV=production

sleep infinity