#!/bin/sh

# Only execute if root ( start services )
export PATH=$PATH:/usr/local/bin
if  [ `id -u` = 0 ]; then 
    service ssh start
    chmod 0640 /etc/ssl/private/ssl-cert-snakeoil.key
    echo "127.0.0.1 localhost" >> /etc/hosts
    service postgresql start
    redis-server --daemonize yes
    if ! grep -q "$SSH_KEY" /root/.ssh/authorized_keys; then
    	echo $SSH_KEY >> /root/.ssh/authorized_keys
    fi
fi

# run peertube
if [ -z "$(ls -A /config)" ]; then
    cp /app/support/docker/production/config/* /config
fi

# Always copy default and custom env configuration file, in cases where new keys were added
cp /app/config/default.yaml /config
cp /app/support/docker/production/config/custom-environment-variables.yaml /config
#find /config ! -user peertube -exec chown peertube:peertube {} \;
# first arg is `-f` or `--some-option`
# or first arg is `something.conf`
#if [ "${1#-}" != "$1" ] || [ "${1%.conf}" != "$1" ]; then
#    set -- npm "$@"
#fi

# allow the container to be started with `--user`
#if [ "$1" = 'npm' -a "$(id -u)" = '0' ]; then
#    find /data ! -user peertube -exec  chown peertube:peertube {} \;
#    exec gosu peertube "$0" "$@"
#fi
#exec "$@"
cd /app
npm start
