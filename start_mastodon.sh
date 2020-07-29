set -ex
echo "checking env variables was set correctly "

# prepare ssh
[ -d /etc/ssh/ ] && chmod 400 -R /etc/ssh/
mkdir -p /run/sshd
[ -d /root/.ssh/ ] || mkdir /root/.ssh

for var in DISCOURSE_VERSION RAILS_ENV DISCOURSE_HOSTNAME DISCOURSE_SMTP_USER_NAME DISCOURSE_SMTP_ADDRESS DISCOURSE_DEVELOPER_EMAILS DISCOURSE_SMTP_PORT THREEBOT_PRIVATE_KEY FLASK_SECRET_KEY THREEBOT_URL OPEN_KYC_URL
    do
        if [ -z "${!var}" ]
        then
                 echo "$var not set, Please set it in creating your container"
        fi
    done

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
su postgres -c 'psql -c "CREATE USER $DB_USER CREATEDB;"' || true
su - mastodon -c "PATH="${PATH}:/opt/ruby/bin:/opt/node/bin"; RAILS_ENV=production bundle exec rails  db:setup ;RAILS_ENV=production bundle exec rails assets:precompile"

[[ -f /etc/nginx/sites-enabled/default ]] && rm /etc/nginx/sites-enabled/default

if ! [ -f /etc/nginx/conf.d/cert.pem ] &&  ! [ -f /etc/nginx/conf.d/key.pem ] ;then
	[ -d /etc/nginx/conf.d ] || mkdir /etc/nginx/conf.d
	cd /etc/nginx/conf.d
	openssl req -subj '/CN=localhost' -x509 -newkey rsa:4096 -nodes -keyout key.pem -out cert.pem -days 365

fi
sed -i "s/DOMAIN/$LOCAL_DOMAIN/g" /etc/nginx/sites-available/mastodon
sudo nginx -t

# stop postgres to start it using supervisord
/etc/init.d/postgresql stop
/usr/bin/redis-cli shutdown

supervisord -n -c /etc/supervisor/supervisord.conf
