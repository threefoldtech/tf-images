#!/usr/bin/env bash
set -ex

chmod +x /opt/bin/*

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