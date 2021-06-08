#!/usr/bin/env bash
echo "127.0.0.1 localhost" >> /etc/hosts
if [ -z "${rpcuser}" ]; then rpcuser="tfnow"; fi
if [ -z "${rpcpasswd}" ]; then rpcpasswd="tf2020"; fi
if [ -z "${node_ingress_ip}" ]; then node_ingress_ip="VDC_IP"; fi
echo $node_ingress_ip > /tmp/checkip
sed -i "s/.*rpcuser=.*/rpcuser=$rpcuser/" /opt/digibyte.conf
sed -i "s/.*rpcpassword=.*/rpcpassword=$rpcpasswd/" /opt/digibyte.conf
mv /opt/digibyte.conf /dgb
cat /opt/cronjobs | crontab -
rm -f /var/www/html/index.html 
/etc/init.d/cron start
curl -ks https://dgb1.trezor.io/api/sync | jq .blockbook.bestHeight > /tmp/checkheaders
/opt/dgb/bin/digibyted -conf=/dgb/digibyte.conf > /dev/null 2>&1
ln -s /dgb/debug.log /var/www/html/node.log && chmod 777 /var/www/html/node.log
exec apache2ctl -D "FOREGROUND"
