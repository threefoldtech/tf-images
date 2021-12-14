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
export PEERTUBE_REDIS_HOSTNAME=127.0.0.1
export PEERTUBE_REDIS_PORT=6379

if [ ! -z $PEERTUBE_REDIS_AUTH ]; then 
    echo "requirepass $PEERTUBE_REDIS_AUTH" >> /etc/redis/redis.conf
fi
echo "Starting Redis Server."
redis-server /etc/redis/redis.conf

# PSQL server
export PEERTUBE_DB_HOSTNAME=127.0.0.1
export PEERTUBE_DB_PORT=5432

chmod 0640 /etc/ssl/private/ssl-cert-snakeoil.key
export PATH=$PATH:/usr/local/bin
echo "127.0.0.1 localhost" >> /etc/hosts

service postgresql start

touch /tmp/init_postgres.sql

cat <<EOF > /tmp/init_postgres.sql
create database peertube$PEERTUBE_DB_SUFFIX;
create user $PEERTUBE_DB_USERNAME password '$PEERTUBE_DB_PASSWORD';
grant all privileges on database peertube$PEERTUBE_DB_SUFFIX to $PEERTUBE_DB_USERNAME;
\c peertube$PEERTUBE_DB_SUFFIX
CREATE EXTENSION pg_trgm;
CREATE EXTENSION unaccent;
EOF

su postgres -c "psql --file=/tmp/init_postgres.sql"

# Peertube server

# default configs
cp /app/config/default.yaml /config

# overriden by productions configs
cp /app/support/docker/production/config/production.yaml /config

# schema to overriden by environment variables
cp /app/support/docker/production/config/custom-environment-variables.yaml /config

# allow peertube to run on IPv4 or IPv6 interface according to BIND var
sed -i "0,/hostname: '0.0.0.0'/ s//hostname: '$PEERTUBE_BIND_ADDRESS'/" /config/production.yaml

# Start peertube server
cd /app
NODE_CONFIG_DIR=/config NODE_ENV=production npm start
# sleep infinity
