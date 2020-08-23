#!/usr/bin/env bash
set -ex
# fix /etc/hosts
if ! grep -q "localhost" /etc/hosts; then
	touch /etc/hosts
	chmod  644 /etc/hosts
	echo $HOSTNAME  localhost >> /etc/hosts
	echo "127.0.0.1 localhost" >> /etc/hosts
fi
#  check pub key
if [ -z ${pub_key+x} ]; then

        echo pub_key does not set in env variables
else

        [[ -d /root/.ssh ]] || mkdir -p /root/.ssh

				if ! grep -q "$pub_key" /root/.ssh/authorized_keys; then
					echo $pub_key >> /root/.ssh/authorized_keys
				fi
fi
# prepare for ssh service
chmod 400 -R /etc/ssh/
mkdir -p /run/sshd
[ -d /root/.ssh/ ] || mkdir /root/.ssh

# those export only for debug you can pass all through env variables for docker/container
export EXCLUDED_MIDDLEWARES=iyo
export FLASK_APP=app.py
export FLASK_DEBUG=0
export SQLALCHEMY_DATABASE_URI=postgresql://postgres:postgres@127.0.0.1:5432/crm
export LC_ALL=C.UTF-8
export CACHE_BACKEND_URI=redis://127.0.0.1:6379/0
export SUPPORT_EMAIL="${SUPPORT_EMAIL}"
export SENDGRID_API_KEY="${SENDGRID_API_KEY}"
export SUPPORT_EMAIL="${SUPPORT_EMAIL}"
export DOMAIN="${DOMAIN}"

cat << EOF > /root/boot.env
export AWS_ACCESS_KEY_ID=$AWS_ACCESS_KEY_ID
export AWS_SECRET_ACCESS_KEY=$AWS_SECRET_ACCESS_KEY
export RESTIC_REPOSITORY=$RESTIC_REPOSITORY
export RESTIC_PASSWORD=$RESTIC_PASSWORD
EOF

chown -R postgres.postgres /var/lib/postgresql/
chown -R postgres.postgres /var/log/postgresql
gpasswd -a postgres ssl-cert
chown root:ssl-cert  /etc/ssl/private/ssl-cert-snakeoil.key
chmod 640 /etc/ssl/private/ssl-cert-snakeoil.key
chown postgres:ssl-cert /etc/ssl/private
chown -R postgres /var/run/postgresql
chown -R postgres.postgres /etc/postgresql
find /var/lib/postgresql -maxdepth 0 -empty -exec sh -c 'pg_dropcluster 10 main && pg_createcluster 10 main' \;

# prepare for supervisor service

mkdir -p /var/log/{postgres,redis,mailer,rq_worker,syncdata,crm,caddy,cron}

supervisord -c /etc/supervisor/supervisord.conf
echo "wait a 2 seconds to let postgres started "
sleep 2
sudo -u postgres psql -c "create database crm;"
sudo -u postgres psql -c "ALTER USER postgres WITH PASSWORD 'postgres';"
sudo -u postgres psql -c "alter database crm owner to postgres ;"


exec "$@"
