#!/bin/sh

set -x 

export PEERTUBE_REDIS_HOSTNAME=127.0.0.1
export PEERTUBE_REDIS_PORT=6379

if [ ! -z $PEERTUBE_REDIS_AUTH ]; then 
    echo "requirepass $PEERTUBE_REDIS_AUTH" >> /etc/redis/redis.conf
fi