#!/usr/bin/env bash
set -x

export PATH="/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin"

# prepare ssh
[ -d /etc/ssh/ ] && chmod 400 -R /etc/ssh/
mkdir -p /run/sshd
[ -d /root/.ssh/ ] || mkdir /root/.ssh

# check ssh key
if [ -z ${SSH_KEY+x} ]; then

        echo SSH_KEY does not set in env variables
else

        [[ -d /root/.ssh ]] || mkdir -p /root/.ssh

                                if ! grep -q "$SSH_KEY" /root/.ssh/authorized_keys; then
                                        echo $SSH_KEY >> /root/.ssh/authorized_keys
                                fi
fi


# fix /etc/hosts

if ! grep -q "localhost" /etc/hosts; then
        touch /etc/hosts
        chmod  644 /etc/hosts
        echo $HOSTNAME  localhost >> /etc/hosts
        echo "127.0.0.1 localhost" >> /etc/hosts
fi

for var in RAILS_ENV DISCOURSE_HOSTNAME DISCOURSE_SMTP_USER_NAME DISCOURSE_SMTP_ADDRESS DISCOURSE_DEVELOPER_EMAILS DISCOURSE_SMTP_PORT THREEBOT_PRIVATE_KEY FLASK_SECRET_KEY THREEBOT_URL OPEN_KYC_URL
    do
        if [ -z "${!var}" ]
        then
                 echo "$var not set, Please set it in creating your container"
        fi
    done

# prepare redis server
chmod 666 /etc/redis/redis.conf
[[ -d /etc/service/redis/log/ ]] || mkdir /etc/service/redis/log/ -p

cat << EOF > /etc/service/redis/log/run
#!/bin/sh
mkdir -p /var/log/redis
exec svlogd /var/log/redis
EOF

chmod +x /etc/service/redis/log/run

sed -i 's/^pidfile.*$//g' /etc/redis/redis.conf
install -d -m 0755 -o redis -g redis /shared/redis_data
sed -i 's/^bind .*$//g' /etc/redis/redis.conf
sed -i 's|^dir .*$|dir /shared/redis_data|g' /etc/redis/redis.conf
sed -i 's/^protected-mode yes/protected-mode no/g' /etc/redis/redis.conf

# prepare anacron
chown -R discourse /home/discourse
cat << EOF > /etc/cron.d/anacron
        SHELL=/bin/sh
        PATH=/usr/local/sbin:/usr/local/bin:/sbin:/bin:/usr/sbin:/usr/bin

        30 7    * * *   root    /usr/sbin/anacron -s >/dev/null

EOF

# export default values for env vars
[[ -z "${RUBY_GC_HEAP_GROWTH_MAX_SLOTS}" ]] && export RUBY_GC_HEAP_GROWTH_MAX_SLOTS=40000
[[ -z "${RUBY_GC_HEAP_INIT_SLOTS}" ]] &&  export RUBY_GC_HEAP_INIT_SLOTS=400000
[[ -z "${RUBY_GC_HEAP_OLDOBJECT_LIMIT_FACTOR}" ]] &&  export RUBY_GC_HEAP_OLDOBJECT_LIMIT_FACTOR=1.5
[[ -z "${RUBY_GLOBAL_METHOD_CACHE_SIZE}" ]] &&  export RUBY_GLOBAL_METHOD_CACHE_SIZE=131072
[[ -z "${PG_MAJOR}" ]] &&  export PG_MAJOR=10
[[ -z "${UNICORN_SIDEKIQS}" ]] &&  export UNICORN_SIDEKIQS=1
[[ -z "${DISCOURSE_DB_SOCKET}" ]] &&  export DISCOURSE_DB_SOCKET=/var/run/postgresql
[[ -z "${home}" ]] &&  export home=/var/www/discourse
[[ -z "${upload_size}" ]] &&  export upload_size=10m
[[ -z "${UNICORN_WORKERS}" ]] &&  export UNICORN_WORKERS=4
[[ -z "${DISCOURSE_SMTP_ENABLE_START_TLS}" ]] &&  export DISCOURSE_SMTP_ENABLE_START_TLS=true

export LC_ALL=en_US.UTF-8
export LANGUAGE=en_US.UTF-8
export LANG=en_US.UTF-8

export DISCOURSE_DB_HOST=
export DISCOURSE_DB_PORT=
export HOME=/root
export THREEBOT_PRIVATE_KEY=$THREEBOT_PRIVATE_KEY
export FLASK_SECRET_KEY=$FLASK_SECRET_KEY
export THREEBOT_URL=$THREEBOT_URL
export OPEN_KYC_URL=$OPEN_KYC_URL
export DISCOURSE_VERSION="staging"
export RAILS_ENV="production"
export THREEBOT_URL="https://login.threefold.me"
export OPEN_KYC_URL="https://openkyc.live/verification/verify-sei"

mkdir -p /var/nginx/cache

env | grep -v "PATH\=" | grep -v "HOME\=" | grep -v "PWD\=" | grep -v "SHLVL\="|grep -v "TERM\=" >> /etc/environment

# create discourse server conf

if [ ! -f /var/www/discourse/config/discourse.conf ]; then
mkdir /var/www/discourse/config/ -p
cat << EOF > /var/www/discourse/config/discourse.conf

hostname = '$DISCOURSE_HOSTNAME'
smtp_user_name = '$DISCOURSE_SMTP_USER_NAME'
smtp_address = '$DISCOURSE_SMTP_ADDRESS'
db_socket = '$DISCOURSE_DB_SOCKET'
developer_emails = '$DISCOURSE_DEVELOPER_EMAILS'
smtp_port = '$DISCOURSE_SMTP_PORT'
smtp_password = '$DISCOURSE_SMTP_PASSWORD'
db_host = ''
db_port = ''
smtp_enable_start_tls = '$DISCOURSE_SMTP_ENABLE_START_TLS'
force_https = 'true'
EOF

fi

[[ -f /etc/nginx/sites-enabled/default ]] && rm /etc/nginx/sites-enabled/default
mkdir -p /var/nginx/cache
sudo nginx -t

[[ -d /var/log/exim4 ]] || mkdir -p /var/log/exim4
[[ -f /var/log/exim4/mainlog ]] || touch /var/log/exim4/mainlog

# TBD checking redis and postgres, should be running before start rails 
cd $home
mkdir -p /var/log/{3bot,unicorn,nginx,cron}
nginx -t

# create restic backup
cat << EOF > /.backup.sh
set -x
app_directory="$home/public/backups/default"

export AWS_ACCESS_KEY_ID=$AWS_ACCESS_KEY_ID
export AWS_SECRET_ACCESS_KEY=$AWS_SECRET_ACCESS_KEY
export RESTIC_REPOSITORY=$RESTIC_REPOSITORY
export RESTIC_PASSWORD=$RESTIC_PASSWORD

EOF

cat /.restic_backup.sh >>  /.backup.sh
chmod +x /.backup.sh

# crom
cat << EOF > /.mycron
00 05 * * * /.backup.sh >> /var/log/cron/backup.log 2>&1
EOF

crontab /.mycron

# add firewall rules
ufw default allow outgoing
ufw default deny incoming
ufw allow ssh
ufw allow 'Nginx Full'
ufw enable

# start services
mkdir -p /var/run/postgresql/
chown -R postgres /var/run/postgresql/
su - postgres -c "/etc/init.d/postgresql start"

supervisord -n -c /etc/supervisor/supervisord.conf