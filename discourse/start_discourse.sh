#!/usr/bin/env bash
set -ex
echo "checking env variables was set correctly "

if [[ -z "$DISCOURSE_VERSION" ]] || [[ -z "$RAILS_ENV" ]] || [[ -z "$HOSTNAME" ]] || [[ -z "$DISCOURSE_HOSTNAME" ]] || [[ -z "$DISCOURSE_SMTP_USER_NAME" ]] || [[ -z "$DISCOURSE_SMTP_ADDRESS" ]] || [[ -z "$DISCOURSE_DEVELOPER_EMAILS" ]] || [[ -z "$DISCOURSE_SMTP_PORT" ]] || [[ -z "$LETSENCRYPT_ACCOUNT_EMAIL" ]] ; then
    echo " one of below variables are not set yet, Please set it in creating your container"
    echo "DISCOURSE_VERSION RAILS_ENV HOSTNAME DISCOURSE_HOSTNAME DISCOURSE_SMTP_USER_NAME DISCOURSE_SMTP_ADDRESS DISCOURSE_DEVELOPER_EMAILS DISCOURSE_SMTP_PORT LETSENCRYPT_ACCOUNT_EMAIL"
    exit 1
fi

if [[ ! "$HOSTNAME" == "$DISCOURSE_HOSTNAME" ]] ; then
	echo two varaibles HOSTNAME DISCOURSE_HOSTNAME are not the same 
	echo please set them equal
	exit 1
fi


# to start unicorn make sure you started postgres and redis and export  all envs
bash /.start_postgres.sh
bash /.prepare_database.sh
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

exec chpst -u redis -U redis /usr/bin/redis-server /etc/redis/redis.conf &

#nohup redis-server &

chown -R discourse /home/discourse
cat << EOF > /etc/cron.d/anacron

        SHELL=/bin/sh
        PATH=/usr/local/sbin:/usr/local/bin:/sbin:/bin:/usr/sbin:/usr/bin

        30 7    * * *   root	/usr/sbin/anacron -s >/dev/null

EOF

export RUBY_GC_HEAP_GROWTH_MAX_SLOTS=40000
export RUBY_GC_HEAP_INIT_SLOTS=400000
export RUBY_GC_HEAP_OLDOBJECT_LIMIT_FACTOR=1.5
export RUBY_GLOBAL_METHOD_CACHE_SIZE=131072
export PG_MAJOR=10
export SHLVL=3
export UNICORN_SIDEKIQS=1
export LC_ALL=en_US.UTF-8
export LANGUAGE=en_US.UTF-8
export LANG=en_US.UTF-8
export DISCOURSE_DB_SOCKET=/var/run/postgresql

export version=$DISCOURSE_VERSION
export home=/var/www/discourse
export upload_size=10m

export UNICORN_WORKERS=4
export LETSENCRYPT_DIR=/shared/letsencrypt
export DISCOURSE_DB_HOST=
export DISCOURSE_DB_PORT=
export DISCOURSE_SMTP_ENABLE_START_TLS=true
export HOME=/root

# verify contents of file /etc/nginx/conf.d/discourse.conf is exist and sed domain name by
sed -i "s/forum1.threefold.io/$DISCOURSE_HOSTNAME/g"  /etc/nginx/conf.d/discourse.conf

env > /root/boot_env

echo "################# all env should be exist from outside and from above ###################"
cat ~/boot_env
#git reset --hard
#git clean -f
#git remote set-branches --add origin master
#git pull
#git fetch origin $version
#git checkout $version
[[ -d $home ]] || mkdir $home
if [ "$(find $home -maxdepth 0 -empty)" ]; then
	fresh_install="yes"
	echo $home is empty, then clone repo
	git clone https://github.com/threefoldtech/threefold-forums -b $version $home
	cd $home
	mkdir -p tmp/pids
	mkdir -p tmp/sockets
	touch tmp/.gitkeep
#	mkdir -p                    /shared/log/rails
#	bash -c "touch -a           /shared/log/rails/{production,production_errors,unicorn.stdout,unicorn.stderr,sidekiq}.log"
#	bash -c "ln    -s           /shared/log/rails/{production,production_errors,unicorn.stdout,unicorn.stderr,sidekiq}.log $home/log"
#	bash -c "mkdir -p           /shared/{uploads,backups}"
#	bash -c "ln    -s           /shared/{uploads,backups} $home/public"
#	bash -c "mkdir -p           /shared/tmp/{backups,restores}"
#	bash -c "ln    -s           /shared/tmp/{backups,restores} $home/tmp"
else
        echo $home not empty so only update it
        cd $home
        git status
        git pull
fi

cat << EOF > /var/www/discourse/config/discourse.conf

hostname = '$HOSTNAME'
smtp_user_name = '$DISCOURSE_SMTP_USER_NAME'
smtp_address = '$DISCOURSE_SMTP_ADDRESS'
db_socket = '$DISCOURSE_DB_SOCKET'
developer_emails = '$DISCOURSE_DEVELOPER_EMAILS'
smtp_port = '$DISCOURSE_SMTP_PORT'
smtp_password = '$DISCOURSE_SMTP_PASSWORD'
db_host = ''
db_port = ''
smtp_enable_start_tls = 'true'
force_https = 'true'

EOF

#chown -R discourse:www-data /shared/log/rails /shared/uploads /shared/backups /shared/tmp
rm /etc/nginx/sites-enabled/default
mkdir -p /var/nginx/cache
sed -i "s#pid /run/nginx.pid#daemon off#g" /etc/nginx/nginx.conf

#  ensure we are on latest bundler
cd $home
gem update bundler
find $home ! -user discourse -exec chown discourse {} \+
cd $home

if [[ "$fresh_install" == "yes" ]];then
	su discourse -c 'bundle install --deployment --retry 3 --jobs 4 --verbose --without test development'
	DEV_RAKE='/var/www/discourse/vendor/bundle/ruby/2.6.0/gems/railties-6.0.1/lib/rails/tasks/dev.rake'
	if [[ -f $DEV_RAKE ]] ;then
	        echo " $DEV_RAKE file is exist "
	else
        	echo " $DEV_RAKE file does not exist "
        	cp /.dev.rake $DEV_RAKE
        	chown discourse:discourse $DEV_RAKE
	fi
	su discourse -c 'bundle exec rake db:migrate'
	su discourse -c 'bundle exec rake assets:precompile'
fi

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
chmod +x /etc/service/3bot_tmux/run
chmod +x /etc/service/cron/run
chmod +x /etc/service/nginx/run
chmod +x /etc/service/unicorn/run

## ssl enabling
mkdir -p /shared/ssl/

if [ -z "$LETSENCRYPT_ACCOUNT_EMAIL" ]; then echo "LETSENCRYPT_ACCOUNT_EMAIL ENV variable is required and has not been set."; exit 1; fi
/bin/bash -c "if [[ ! \"$LETSENCRYPT_ACCOUNT_EMAIL\" =~ ([^@]+)@([^\.]+) ]]; then echo \"LETSENCRYPT_ACCOUNT_EMAIL is not a valid email address\"; exit 1; fi"
cd /root && git clone --branch 2.8.2 --depth 1 https://github.com/Neilpang/acme.sh.git && cd /root/acme.sh
touch /var/spool/cron/crontabs/root
install -d -m 0755 -g root -o root $LETSENCRYPT_DIR
cd /root/acme.sh && LE_WORKING_DIR="${LETSENCRYPT_DIR}" ./acme.sh --install --log "${LETSENCRYPT_DIR}/acme.sh.log"
cd /root/acme.sh && LE_WORKING_DIR="${LETSENCRYPT_DIR}" ./acme.sh --upgrade --auto-upgrade

cat << EOF > /etc/nginx/letsencrypt.conf
user www-data;
worker_processes auto;
daemon on;

events {
  worker_connections 768;
  # multi_accept on;
}

http {
  sendfile on;
  tcp_nopush on;
  tcp_nodelay on;
  keepalive_timeout 65;
  types_hash_max_size 2048;

  access_log /var/log/nginx/access.letsencrypt.log;
  error_log /var/log/nginx/error.letsencrypt.log;

  server {
    listen 80;
    listen [::]:80;

    location ~ /.well-known {
      root /var/www/discourse/public;
      allow all;
    }
  }
}

EOF

# need to add it im image /etc/runit/1.d/letsencrypt
[[ -d /var/log/nginx ]] || mkdir /var/log/nginx

chmod +x /etc/runit/1.d/letsencrypt
if [[ -f /shared/ssl/${DISCOURSE_HOSTNAME}_ecc.key ]]; then 
	echo certificate already exist no need to generate it
else
	echo start nginx with this config so we can generate keys form letsencrypt
	/usr/sbin/nginx -c /etc/nginx/letsencrypt.conf
	echo fix script before use it 
	sed -i "s|\$DISCOURSE_HOSTNAME_ecc|\${DISCOURSE_HOSTNAME}_ecc|g" /etc/runit/1.d/letsencrypt
	/etc/runit/1.d/letsencrypt
	echo stop nginx that started by letsencrypt configuration
	pkill -9 nginx
fi
# to test add export args then run  /etc/runit/1.d/letsencrypt then run /sbin/boot
[[ -d /var/log/cron/ ]] || mkdir /var/log/cron

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
00 05 * * * /.backup.sh >> /var/log/cron/backup.log
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

/etc/service/3bot_tmux/run
/etc/service/cron/run &
nginx -t
/etc/service/nginx/run & 

# TBD checking redis and postgres, should be running before start rails 

cd $home
/etc/service/unicorn/run &
