#!/bin/bash
set -ex
echo "checking env variables was set correctly "

# prepare ssh
[ -d /etc/ssh/ ] && chmod 400 -R /etc/ssh/
mkdir -p /run/sshd
[ -d /root/.ssh/ ] || mkdir /root/.ssh

mkdir -p /var/log/{ssh,postgres,redis,web,streaming,sidekiq,nginx,rabbitmq,cron}
# prepare postgres
chown -R postgres.postgres /var/lib/postgresql/
[[ -d /var/log/postgresql ]] || mkdir /var/log/postgresql
chown -R postgres.postgres /var/log/postgresql
gpasswd -a postgres ssl-cert
chown root:ssl-cert  /etc/ssl/private/ssl-cert-snakeoil.key
chmod 640 /etc/ssl/private/ssl-cert-snakeoil.key
chown postgres:ssl-cert /etc/ssl/private
chown -R postgres /var/run/postgresql
chown -R postgres.postgres /etc/postgresql
locale-gen en_US.UTF-8 || true
# just start postgres to create intial db
/etc/init.d/postgresql start
/usr/bin/redis-server  --daemonize yes
su postgres -c "psql -c 'CREATE USER $DB_USER CREATEDB;'" || true

cd /opt/mastodon
#export PATH=${PATH}:/opt/ruby/bin:/opt/node/bin;\
export SECRET_KEY_BASE=$(bundle exec rake secret) ; \
export OTP_SECRET=$(bundle exec rake secret);\
export PAPERCLIP_SECRET=$(bundle exec rake secret) ; \
TWO_VAPID_KEYS=$(bundle exec rake mastodon:webpush:generate_vapid_key); 
export `echo $TWO_VAPID_KEYS | awk ' {print $1}'`
export `echo $TWO_VAPID_KEYS | awk ' {print $2}'`
if ! [[ -f /opt/mastodon/.env.production ]];then
cat <<EOF > /opt/mastodon/.env.production
LOCAL_DOMAIN=$DOMAIN
SINGLE_USER_MODE=true
SECRET_KEY_BASE=$SECRET_KEY_BASE
OTP_SECRET=$OTP_SECRET
VAPID_PRIVATE_KEY=$VAPID_PRIVATE_KEY
VAPID_PUBLIC_KEY=$VAPID_PUBLIC_KEY
DB_HOST=/var/run/postgresql
DB_PORT=5432
DB_NAME=$DB_NAME
DB_USER=$DB_USER
DB_PASS=
REDIS_HOST=localhost
REDIS_PORT=6379
REDIS_PASSWORD=
SMTP_SERVER=$SMTP_SERVER
SMTP_PORT=$SMTP_PORT
SMTP_LOGIN=$SMTP_LOGIN
SMTP_PASSWORD=$SMTP_PASSWORD
SMTP_FROM_ADDRESS=$SMTP_FROM_ADDRESS
SMTP_AUTH_METHOD=none
EOF
fi

cat /opt/mastodon/.env.production
find /opt/mastodon ! -user mastodon -exec chown mastodon:mastodon {} \+ 
sudo -u mastodon  bash -c "export SAFETY_ASSURED=1; export PATH=${PATH}:/opt/ruby/bin:/opt/node/bin; RAILS_ENV=production bundle exec rails  db:setup ; RAILS_ENV=production bundle exec rails assets:precompile"

[[ -f /etc/nginx/sites-enabled/default ]] && rm /etc/nginx/sites-enabled/default

if ! [ -f /etc/nginx/conf.d/cert.pem ] &&  ! [ -f /etc/nginx/conf.d/key.pem ] ;then
	[ -d /etc/nginx/conf.d ] || mkdir /etc/nginx/conf.d
	cd /etc/nginx/conf.d
	openssl req -subj '/CN=localhost' -x509 -newkey rsa:4096 -nodes -keyout key.pem -out cert.pem -days 365

fi
sed -i "s/DOMAIN/$DOMAIN/g" /etc/nginx/sites-available/mastodon 

[[ -L /etc/nginx/sites-enabled/mastodon ]] || ln -s /etc/nginx/sites-available/mastodon /etc/nginx/sites-enabled/mastodon

[[ -d /var/cache/nginx ]] || mkdir /var/cache/nginx -p
sudo nginx -t

# stop postgres to start it using supervisord
/etc/init.d/postgresql stop
/usr/bin/redis-cli shutdown

supervisord -n -c /etc/supervisor/supervisord.conf
