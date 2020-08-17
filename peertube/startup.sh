#!/bin/bash

# enable ssh
chmod 600 /etc/ssh/*_key
echo $pub_key > ~/.ssh/authorized_keys
service ssh start

echo "127.0.0.1 localhost" > /etc/hosts
chmod 777 /etc/hosts

cd /var/www/peertube/peertube-latest
sed -i "s/hostname: 'example.com'/hostname: '$1'/" /var/www/peertube/config/production.yaml

chown -R postgres:postgres /var/lib/postgresql /etc/postgresql/10 /run/postgresql /var/log/postgresql
chown -R root:ssl-cert /etc/ssl/private
chmod 0640 /etc/ssl/private/ssl-cert-snakeoil.key

service postgresql start
redis-server --daemonize yes
NODE_ENV=production NODE_CONFIG_DIR=/var/www/peertube/config NODE_OPTIONS="--max-old-space-size=4096" npm start

