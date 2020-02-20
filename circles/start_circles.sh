#!/usr/bin/env bash
set -x

export DEBIAN_FRONTEND=noninteractive
# prepare ssh
chmod 400 -R /etc/ssh/
mkdir -p /run/sshd
[ -d /root/.ssh/ ] || mkdir /root/.ssh

# prepare postgres
mkdir -p /var/lib/postgresql
mkdir -p /var/log/postgresql
chown -R postgres.postgres /var/lib/postgresql/
chown -R postgres.postgres /var/log/postgresql
gpasswd -a postgres ssl-cert
chown root:ssl-cert  /etc/ssl/private/ssl-cert-snakeoil.key
chmod 640 /etc/ssl/private/ssl-cert-snakeoil.key
chown postgres:ssl-cert /etc/ssl/private
chown -R postgres:postgres  /var/run/postgresql
chown -R postgres:postgres /etc/postgresql
find /var/lib/postgresql -maxdepth 0 -empty -exec sh -c 'pg_dropcluster 10 main && pg_createcluster 10 main' \;


#echo "prepare postgres"
#/bin/bash /.postgres_entry.sh postgres

#
echo 'remove a record was added by zos that make our server slow, below is resolv.conf file contents'

if grep "10." /etc/resolv.conf ; then
  sed -i '/^nameserver 10./d' /etc/resolv.conf
fi

locale-gen en_US.UTF-8
export LC_ALL=en_US.UTF-8

# set threebot paramater from env varaibles
#echo "PRIVATE_KEY=$PRIVATE_KEY" >> /etc/environment
#echo "THREEBOT_URL=$THREEBOT_URL" >> /etc/environment
#echo "OPEN_KYC_URL=$OPEN_KYC_URL" >> /etc/environment

env | grep -v "PATH\=" | grep -v "HOME\=" | grep -v "PWD\=" | grep -v "SHLVL\=" >> /etc/environment

# prepare rabbitmq
chown -R rabbitmq:rabbitmq /etc/rabbitmq
chown -R rabbitmq:rabbitmq /var/lib/rabbitmq/
chown -R rabbitmq:rabbitmq /var/log/rabbitmq/

chown -R root:root /usr/bin/sudo
chmod 4755 /usr/bin/sudo

sed -i "s/listen 80 default_server/listen $HTTP_PORT default_server/g" /etc/nginx/conf.d/taiga.conf

# add logs dir for taiga logs
[[ -d  /home/taiga/logs ]] || mkdir -p /home/taiga/logs
sudo nginx -t
mkdir -p /var/log/{ssh,postgres,taiga-back,taiga-events,nginx,rabbitmq,cron}

if getent passwd taiga; then
    echo username taiga is already exist
else
    adduser taiga
    adduser taiga sudo
    passwd -d taiga
fi

# start supervisord
supervisord -c /etc/supervisor/supervisord.conf

echo wait 5 seconds postgres to start
sleep 5

# taiga setup script
echo starting taiga setup script
bash /.setup_taiga.sh
chown -R taiga:taiga /home/taiga

# taiga prepare script
echo  starting taiga prepare script
su taiga -c 'bash /.prepare_taiga.sh'

# Start rabbitmq-server and create user+vhost
rabbitmqctl add_user taiga $SECRET_KEY
rabbitmqctl add_vhost taiga
rabbitmqctl set_permissions -p taiga taiga '.*' '.*' '.*'

crontab /.all_cron

exec "$@"
