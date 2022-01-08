#!/bin/bash

# enable ssh
chmod 600 /etc/ssh/*_key
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

service ssh start

rm -rf /var/lib/mysql
chmod 777 /var/run/mysqld

echo "Starting MySQL"
/entrypoint.sh mysqld &

until mysqladmin -hlocalhost -P3306 -u"$MYSQL_USER" -p"$MYSQL_PASSWORD" processlist &> /dev/null; do
	echo "MySQL still not ready, sleeping"
	sleep 5
done

echo "Updating CA certificates"
update-ca-certificates --fresh >/dev/null

echo "Starting platform"
cd mattermost
chmod 777 /etc/hosts
echo "127.0.0.1 localhost" > /etc/hosts
exec ./bin/mattermost --config=config/config_docker.json
