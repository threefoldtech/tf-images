#!/bin/sh
set -e



# enable ssh
# gosu root echo $PUB_KEY >> gosu root /root/.ssh/authorized_keys
#service ssh start

# start psql
# chown -R postgres:postgres /var/lib/postgresql

#service postgresql start

# start redis
#redis-server --daemonize yes
# ONly execute if root
if  [ `id -u` = 0 ]; then 
    service ssh start
    service postgresql start
    redis-server --daemonize yes
    echo $PUB_KEY
    if ! grep -q "$PUB_KEY" /root/.ssh/authorized_keys; then
    	echo $PUB_KEY >> /root/.ssh/authorized_keys
    fi
fi



if [ -z "$(ls -A /config)" ]; then
    cp /app/support/docker/production/config/* /config
fi

echo "entry1"
# Always copy default and custom env configuration file, in cases where new keys were added
cp /app/config/default.yaml /config
cp /app/support/docker/production/config/custom-environment-variables.yaml /config
find /config ! -user peertube -exec chown peertube:peertube {} \;
echo "entry2"
# first arg is `-f` or `--some-option`
# or first arg is `something.conf`
if [ "${1#-}" != "$1" ] || [ "${1%.conf}" != "$1" ]; then
    set -- npm "$@"
fi
echo "entry3"
# allow the container to be started with `--user`
if [ "$1" = 'npm' -a "$(id -u)" = '0' ]; then
    find /data ! -user peertube -exec  chown peertube:peertube {} \;
    exec gosu peertube "$0" "$@"
fi
echo "Params in enrtypoint is "
echo "$0"
echo "$@"
exec "$@"

