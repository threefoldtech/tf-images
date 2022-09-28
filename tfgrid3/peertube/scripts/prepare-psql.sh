#!/bin/sh

set -x

export PEERTUBE_DB_HOSTNAME=127.0.0.1
export PEERTUBE_DB_PORT=5432

chmod 0640 /etc/ssl/private/ssl-cert-snakeoil.key
export PATH=$PATH:/usr/local/bin
echo "127.0.0.1 localhost" >> /etc/hosts
