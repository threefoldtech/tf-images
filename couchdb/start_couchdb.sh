#!/bin/sh
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

mkdir ~/.ssh
mkdir -p /var/run/sshd
chmod 600 ~/.ssh
touch ~/.ssh/authorized_keys
chmod 600 ~/.ssh/authorized_keys
echo $pub_key >> ~/.ssh/authorized_keys
chmod 600 /etc/ssh/ssh_host_*
export COUCHDB_USER=$db_admin
export COUCHDB_PASSWORD=$db_passwd
/bin/sh -c /docker-entrypoint.sh
chmod -R 777 /opt/couchdb
/etc/init.d/couchdb start
exec /usr/sbin/sshd -D
