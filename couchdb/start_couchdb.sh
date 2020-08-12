#!/bin/sh

mkdir ~/.ssh
mkdir -p /var/run/sshd
chmod 600 ~/.ssh
touch ~/.ssh/authorized_keys
chmod 600 ~/.ssh/authorized_keys
echo $pub_key >> ~/.ssh/authorized_keys
chmod 600 /etc/ssh/ssh_host_*
export COUCHDB_USER=$db_admin
export COUCHDB_PASSWORD=$db_passwd
/bin/sh -c /docker-entrypoint.sh
chmod -R 777 /opt/couchdb
/etc/init.d/couchdb start
exec /usr/sbin/sshd -D
