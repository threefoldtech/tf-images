#!/usr/bin/env bash
set -ex

export DEBIAN_FRONTEND=noninteractive

echo "checking env variables was set correctly "

for var in  SECRET_KEY EMAIL_HOST EMAIL_HOST_USER EMAIL_HOST_PASSWORD TAIGA_HOSTNAME HTTP_PORT PRIVATE_KEY  THREEBOT_URL OPEN_KYC_URL
    do
        if [ -z "${!var}" ]
        then
                 echo "$var not set, Please set it in creating your container"
                 exit 1
        fi
    done

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

# initialize postgres dir if it is empty
find /var/lib/postgresql -maxdepth 0 -empty -exec sh -c 'pg_dropcluster 10 main && pg_createcluster 10 main' \;

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

# add taiga user
if getent passwd taiga; then
    echo username taiga is already exist
else
    #adduser taiga
    #adduser taiga sudo
    useradd -d /home/taiga -G sudo -s /bin/bash taiga
    passwd -d taiga
fi

# start postgres by init only for preparing taiga 
/etc/init.d/postgresql start

# taiga setup script
echo starting taiga setup script
bash /.setup_taiga.sh
chown -R taiga:taiga /home/taiga

# taiga prepare script
echo  starting taiga prepare script
su taiga -c 'bash /.prepare_taiga.sh'

crontab /.all_cron

# add logs dir for taiga logs
[[ -d  /home/taiga/logs ]] || mkdir -p /home/taiga/logs
sudo nginx -t
mkdir -p /var/log/{ssh,postgres,rabbitmq,taiga-back,taiga-events,nginx,rabbitmq,cron}

# stop postgres to start it by supervisord
/etc/init.d/postgresql stop
# start supervisord
supervisord -c /etc/supervisor/supervisord.conf

echo wait 5 seconds for rabbitmq starting 
sleep 5
# Start rabbitmq-server and create user+vhost
if ! rabbitmqctl add_user taiga $SECRET_KEY ; then
	echo creating fail, try again 
	rabbitmqctl add_user taiga $SECRET_KEY
fi

rabbitmqctl add_vhost taiga
rabbitmqctl set_permissions -p taiga taiga '.*' '.*' '.*'

exec "$@"
