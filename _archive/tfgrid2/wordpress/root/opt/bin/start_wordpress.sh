#!/usr/bin/env bash
chmod +x /opt/bin/*
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
# prepare ssh
[ -d /etc/ssh/ ] && chmod 400 -R /etc/ssh/
mkdir -p /run/sshd
[ -d /root/.ssh/ ] || mkdir /root/.ssh

echo "runing mariadb"
/bin/bash /opt/bin/mariadb_entry.sh mysqld  #--character-set-server=utf8mb4 --collation-server=utf8mb4_unicode_ci& #--user=root&

mysqld &
mysql_pid="$!"

while ! ss -ntlp | grep -q '3306'; do
 ss -ntlp
 echo "waiting for mariab"
 sleep 2;
done
ps aux | grep mysql

echo "mariaserver running"
echo "running wordpress entry"

source /etc/apache2/envvars
/bin/bash /opt/bin/wordpress_entry.sh apache2&
ps aux | grep "wordpress_entry.sh"

# wait till wordpress finished
wordpress_pid="$!"
while ! ps aux | grep -v "wordpress_entry.sh"
do
  echo $wordpress_pid still running, waiting till finished
  sleep 2
done
ps aux | grep wordpress
echo it is looks like process is done.
wait $wordpress_pid
wordpress_status=$?
echo The exit status of the process was $wordpress_status

# stop mysql to start with supervisord
if ! kill -s TERM "$mysql_pid" || ! wait "$mysql_pid"; then
  echo >&2 'can not stop MySQL.'
  exit 1
fi

mkdir -p /var/log/{mysql,apache2,cron}

supervisord -c /etc/supervisor/supervisord.conf

exec "$@"
