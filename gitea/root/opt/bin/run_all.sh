#!/usr/bin/env bash
chmod +x /opt/bin/*
mkdir -p /var/log/postgres
mkdir -p /var/log/gitea
mkdir -p /var/log/cron
echo "prepare postgres"
/bin/bash /opt/bin/postgres_entry.sh postgres

supervisord -c /etc/supervisor/supervisord.conf

exec "$@"
