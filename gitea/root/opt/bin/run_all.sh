#!/usr/bin/env bash
# prepare ssh
[ -d /etc/ssh/ ] && chmod 400 -R /etc/ssh/
mkdir -p /run/sshd
[ -d /root/.ssh/ ] || mkdir /root/.ssh

chmod +x /opt/bin/*
mkdir -p /var/log/postgres
mkdir -p /var/log/gitea
mkdir -p /var/log/cron
echo "prepare postgres"
/bin/bash /opt/bin/postgres_entry.sh postgres

supervisord -c /etc/supervisor/supervisord.conf

# take a public key from output
if [[ -z ${pub_key} ]] ; then

    echo pub_key does not set in env variables
else
  PUB_KEY=${pub_key}
  echo "$PUB_KEY" >> /data/git/.ssh/authorized_keys
fi

exec "$@"
