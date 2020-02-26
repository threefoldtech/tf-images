#!/usr/bin/env bash
set -ex
echo "checking env variables was set correctly "

for var in DISCOURSE_VERSION RAILS_ENV DISCOURSE_HOSTNAME DISCOURSE_SMTP_USER_NAME DISCOURSE_SMTP_ADDRESS DISCOURSE_DEVELOPER_EMAILS DISCOURSE_SMTP_PORT THREEBOT_PRIVATE_KEY FLASK_SECRET_KEY THREEBOT_URL OPEN_KYC_URL 
    do
        if [ -z "${!var}" ]
        then
                 echo "$var not set, Please set it in creating your container"
                 exit 1
        fi
    done

# prepare redis server
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

chown -R discourse /home/discourse
cat << EOF > /etc/cron.d/anacron

        SHELL=/bin/sh
        PATH=/usr/local/sbin:/usr/local/bin:/sbin:/bin:/usr/sbin:/usr/bin

        30 7    * * *   root	/usr/sbin/anacron -s >/dev/null

EOF

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
# TOBD DISCOURSE_CDN_URL

export LC_ALL=en_US.UTF-8
export LANGUAGE=en_US.UTF-8
export LANG=en_US.UTF-8

export version=$DISCOURSE_VERSION
export DISCOURSE_DB_HOST=
export DISCOURSE_DB_PORT=
export HOME=/root
export THREEBOT_PRIVATE_KEY=$THREEBOT_PRIVATE_KEY
export FLASK_SECRET_KEY=$FLASK_SECRET_KEY
export THREEBOT_URL=$THREEBOT_URL
export OPEN_KYC_URL=$OPEN_KYC_URL

mkdir -p /var/nginx/cache

env | grep -v "PATH\=" | grep -v "HOME\=" | grep -v "PWD\=" | grep -v "SHLVL\="|grep -v "TERM\=" >> /etc/environment

[[ -d $home ]] || mkdir $home
if [ "$(find $home -maxdepth 0 -empty)" ]; then
	export fresh_install="yes"
	echo $home is empty, then clone repo
	git clone https://github.com/threefoldtech/threefold-forums -b $version $home
	cd $home
	mkdir -p tmp/pids
	mkdir -p tmp/sockets
	touch tmp/.gitkeep

else
        echo $home not empty so only update it
        cd $home
        git status
	    git stash
        git pull
fi

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

#chown -R discourse:www-data /shared/log/rails /shared/uploads /shared/backups /shared/tmp
[[ -f /etc/nginx/sites-enabled/default ]] && rm /etc/nginx/sites-enabled/default
mkdir -p /var/nginx/cache
sed -i "s#pid /run/nginx.pid#daemon off#g" /etc/nginx/nginx.conf

#  ensure we are on latest bundler
cd $home
#gem update bundler
find $home ! -user discourse -exec chown discourse {} \+

chmod +x /etc/runit/1.d/copy-env
chmod +x /etc/service/unicorn/run
chmod +x /etc/service/nginx/run
chmod +x /etc/runit/3.d/01-nginx
chmod +x /etc/runit/3.d/02-unicorn
chmod +x /usr/local/bin/discourse
chmod +x /usr/local/bin/rails
chmod +x /usr/local/bin/rake
chmod +x /usr/local/bin/rbtrace
chmod +x /usr/local/bin/stackprof
chmod +x /etc/update-motd.d/10-web
chmod +x /etc/runit/1.d/00-ensure-links
chmod +x /etc/service/cron/run
chmod +x /etc/service/nginx/run


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

cat << EOF > /.mycron
00 05 * * * /.backup.sh >> /var/log/cron/backup.log 2>&1
EOF


crontab /.mycron

echo checking postgres and redis are running and export
mkdir -p /shared/log/rails
[[ -d /var/log/exim4 ]] || mkdir -p /var/log/exim4
[[ -f /var/log/exim4/mainlog ]] || touch /var/log/exim4/mainlog
chmod -R u+rwx /var/log/exim4 /var/spool/exim4/
chown -R Debian-exim:mail /var/log/exim4
chown -R Debian-exim:Debian-exim /var/spool/exim4/
chown root:Debian-exim  /etc/exim4/passwd.client

# TBD checking redis and postgres, should be running before start rails 

cd $home
# remove pid file unicron before start
#[[ -f $home/tmp/pids/unicorn.pid ]] && rm $home/tmp/pids/unicorn.pid
chown -R discourse:www-data /shared/log/rails

mkdir -p /var/log/{ssh,postgres,redis,3bot,unicorn,nginx,cron}

nginx -t

# to start unicorn make sure you started postgres and redis and export  all envs
bash /.prepare_postgres.sh

# just start postgres to create intial db
/etc/init.d/postgresql start
/usr/bin/redis-server  --daemonize yes

bash /.prepare_database.sh

cd $home

if [[ "$fresh_install" == "yes" ]];then
	su discourse -c 'bundle install --deployment --retry 3 --jobs 4 --verbose --without test development'
	su discourse -c 'bundle exec rake db:migrate'
	su discourse -c 'bundle exec rake assets:precompile' 
fi

DEV_RAKE='/var/www/discourse/vendor/bundle/ruby/2.6.0/gems/railties-6.0.1/lib/rails/tasks/dev.rake'
if [[ -f $DEV_RAKE ]] ;then
        echo " $DEV_RAKE file is exist , so this mean bundle installation seems completed successfully "
else
        echo " $DEV_RAKE file does not exist, Please check seems bundle installation does not completed successfully "
        exit 1
fi

# stop postgres to start it using supervisord
/etc/init.d/postgresql stop
/usr/bin/redis-cli shutdown
supervisord -c /etc/supervisor/supervisord.conf

exec "$@"
