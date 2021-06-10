#!/usr/bin/env bash
echo "127.0.0.1 localhost" >> /etc/hosts
if [ -z "${rpcuser}" ]; then rpcuser="tfnow"; fi
if [ -z "${rpcpasswd}" ]; then rpcpasswd="tfdash2020"; fi
sed -i "s/.*rpcuser=.*/rpcuser=$rpcuser/" /opt/dash.conf
sed -i "s/.*rpcpassword=.*/rpcpassword=$rpcpasswd/" /opt/dash.conf
mv /opt/dash.conf /dash
cat /opt/cronjobs | crontab -
rm -f /var/www/html/index.html 
/etc/init.d/cron start
/opt/dash/bin/dashd -conf=/dash/dash.conf > /dev/null 2>&1
ln -s /dash/debug.log /var/www/html/node.log && chmod 777 /var/www/html/node.log
exec apache2ctl -D "FOREGROUND"
