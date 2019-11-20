#!/usr/bin/env bash

chmod +x /opt/bin/*

echo "runing mariadb"
/bin/bash /opt/bin/mariadb_entry.sh
su mysql -c "mysqld &"  #--character-set-server=utf8mb4 --collation-server=utf8mb4_unicode_ci& #--user=root&


while ! ss -ntlp | grep -q '3306'; do
 ss -ntlp
 echo "waiting for mariab"
 sleep 10;
done

echo "mariaserver running"
echo "running faveo server"
chown -R www-data:www-data /var/run/php

# prepare for ssh service
chmod 400 -R /etc/ssh/
mkdir -p /run/sshd
[ -d /root/.ssh/ ] || mkdir /root/.ssh

# prepare for supervisor service

[ -d /var/log/php-fpm ] || mkdir -p /var/log/php-fpm

chown -R www-data:www-data /var/log/supervisor
chmod -R 0777 /usr/share/nginx/storage
echo '* * * * * php /usr/share/nginx/artisan schedule:run > /dev/null 2>&1' > /etc/cron.d/faveo-cron
chmod 0644 /etc/cron.d/faveo-cron
crontab /etc/cron.d/faveo-cron

# use supervisord to start ssh, mysql and nginx and php-fpm

supervisord -c /etc/supervisor/supervisord.conf

exec "$@"