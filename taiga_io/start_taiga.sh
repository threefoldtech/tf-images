#!/bin/bash
set -ex
export DEBIAN_FRONTEND=noninteractive

echo "checking env variables was set correctly "
for var in  SECRET_KEY EMAIL_HOST EMAIL_HOST_USER EMAIL_HOST_PASSWORD TAIGA_HOSTNAME HTTP_PORT PRIVATE_KEY  THREEBOT_URL OPEN_KYC_URL
    do
        if [ -z "${!var}" ]
        then
                 echo "$var not set, Please set it in creating your container"
        fi
    done

echo "checking and setting taiga version"
[[ -z "${TAIGA_VERSION}" ]] &&  export TAIGA_VERSION=production
export version=${TAIGA_VERSION}

# prepare ssh
chmod 400 -R /etc/ssh/
chmod 777 /etc/hosts
mkdir -p /run/sshd
[ -d /root/.ssh/ ] || mkdir /root/.ssh
# fix /etc/hosts
if ! grep -q "localhost" /etc/hosts; then
	echo "127.0.0.1 localhost" >> /etc/hosts
    echo "127.0.0.1 `hostname`" >> /etc/hosts
fi

echo "preparing postgresql environment"
su taiga -c 'bash /.postgres_entry.sh'
mkdir -p /home/taiga/logs && mkdir -p /var/log/{ssh,postgresql,rabbitmq,taiga-back,taiga-events,nginx,rabbitmq,cron}
mkdir -p /var/lib/postgresql
chown -R postgres.postgres /var/lib/postgresql/
chown -R postgres.postgres /var/log/postgresql
gpasswd -a postgres ssl-cert
chown root:ssl-cert  /etc/ssl/private/ssl-cert-snakeoil.key
chmod 640 /etc/ssl/private/ssl-cert-snakeoil.key
chown postgres:ssl-cert /etc/ssl/private
chown -R postgres:postgres  /var/run/postgresql
chown -R postgres:postgres /etc/postgresql
chown -R taiga:taiga /home/taiga
chown -R taiga:taiga /var/log/taiga-back
chown -R taiga:taiga /var/log/taiga-events


find /var/lib/postgresql -maxdepth 0 -empty -exec sh -c 'pg_dropcluster 10 main && pg_createcluster 10 main' {} \;

echo "configuring locals"
locale-gen en_US.UTF-8
export LC_ALL=en_US.UTF-8

env | grep -v "PATH\=" | grep -v "HOME\=" | grep -v "PWD\=" | grep -v "SHLVL\=" >> /etc/environment

echo "preparing rabbitmq environment"
chown -R rabbitmq:rabbitmq /etc/rabbitmq
chown -R rabbitmq:rabbitmq /var/lib/rabbitmq/
chown -R rabbitmq:rabbitmq /var/log/rabbitmq/

echo "configuring nginx"
sed -i "s/listen 80 default_server/listen $HTTP_PORT default_server/g" /etc/nginx/conf.d/taiga.conf

echo "Configuring postgres"
/etc/init.d/postgresql start

su - postgres -c "psql -t -c '\du' | cut -d \| -f 1 | grep -qw taiga && echo taiga user already exist || createuser taiga"
su - postgres -c "psql -lqt | cut -d \| -f 1 | grep -qw  taiga && echo taiga database is already exist || createdb taiga -O taiga --encoding='utf-8' --locale=en_US.utf8 --template=template0"
chmod +x /backup_init.sh
bash /backup_init.sh
su taiga -c 'bash /.prepare_taiga.sh'

/etc/init.d/postgresql stop
echo "Run supervisord"
supervisord -c /etc/supervisor/supervisord.conf

echo "wait 10 seconds for rabbitmq starting"
sleep 10
rabbitmqctl add_user taiga $SECRET_KEY
rabbitmqctl add_vhost taiga
rabbitmqctl set_permissions -p taiga taiga '.*' '.*' '.*'


if ! [ -f /etc/nginx/conf.d/taiga.conf ] ; then
	cp /tmp/taiga.conf /etc/nginx/conf.d/taiga.conf && rm /tmp/taiga.conf
fi

sed -i "s/TAIGA_HOSTNAME/$TAIGA_HOSTNAME/g" /etc/nginx/conf.d/taiga.conf
nginx -t
supervisorctl restart nginx
tail -f /dev/null
