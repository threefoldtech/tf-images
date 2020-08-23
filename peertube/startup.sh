#!/bin/bash
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

# enable ssh
chmod 600 /etc/ssh/*_key
service ssh start

cd /var/www/peertube/peertube-latest
sed -i "s/hostname: 'example.com'/hostname: '$1'/" /var/www/peertube/config/production.yaml

chown -R postgres:postgres /var/lib/postgresql /etc/postgresql/10 /run/postgresql /var/log/postgresql
chown -R root:ssl-cert /etc/ssl/private
chmod 0640 /etc/ssl/private/ssl-cert-snakeoil.key

service postgresql start
redis-server --daemonize yes
NODE_ENV=production NODE_CONFIG_DIR=/var/www/peertube/config NODE_OPTIONS="--max-old-space-size=4096" npm start

