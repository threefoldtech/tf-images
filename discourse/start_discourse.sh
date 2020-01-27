#!/usr/bin/env bash
set -ex

# to start unicorn make sure you started postgres and redis and export  all envs


nohup redis-server &

apt install -y net-tools
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

export version=tests-passed
export home=/var/www/discourse
export upload_size=10m


export RAILS_ENV=production
export HOSTNAME=discurse-staging-mydiscourse
export UNICORN_WORKERS=4
export DISCOURSE_HOSTNAME=forum6.threefold.io
export DISCOURSE_SMTP_USER_NAME=apikey
export DISCOURSE_SMTP_ADDRESS=smtp.sendgrid.net
export DISCOURSE_DEVELOPER_EMAILS=bishoy@incubaid.com
export DISCOURSE_SMTP_PORT=587
export DISCOURSE_SMTP_PASSWORD=${DISCOURSE_SMTP_PASSWORD}
echo ${DISCOURSE_SMTP_PASSWORD}
export LETSENCRYPT_DIR=/shared/letsencrypt
export LETSENCRYPT_ACCOUNT_EMAIL=bishoy@incubaid.com

echo '######################## all env ################### '
env

# verify contents of file /etc/nginx/conf.d/discourse.conf is exist and sed domain name by
sed -i "s/forum1.threefold.io/$DISCOURSE_HOSTNAME/g"  /etc/nginx/conf.d/discourse.conf

#env > ~/boot_env
cd $home
git reset --hard
git clean -f
git remote set-branches --add origin master
git pull
git fetch origin $version
git checkout $version
mkdir -p tmp/pids
mkdir -p tmp/sockets
touch tmp/.gitkeep
mkdir -p                    /shared/log/rails
bash -c "touch -a           /shared/log/rails/{production,production_errors,unicorn.stdout,unicorn.stderr,sidekiq}.log"
bash -c "ln    -s           /shared/log/rails/{production,production_errors,unicorn.stdout,unicorn.stderr,sidekiq}.log $home/log"
bash -c "mkdir -p           /shared/{uploads,backups}"
bash -c "ln    -s           /shared/{uploads,backups} $home/public"
bash -c "mkdir -p           /shared/tmp/{backups,restores}"
bash -c "ln    -s           /shared/tmp/{backups,restores} $home/tmp"
chown -R discourse:www-data /shared/log/rails /shared/uploads /shared/backups /shared/tmp

rm /etc/nginx/sites-enabled/default
mkdir -p /var/nginx/cache
sed -i "s#pid /run/nginx.pid#daemon off#g" /etc/nginx/nginx.conf

#  ensure we are on latest bundler
cd $home
gem update bundler
find $home ! -user discourse -exec chown discourse {} \+
cd $home
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
