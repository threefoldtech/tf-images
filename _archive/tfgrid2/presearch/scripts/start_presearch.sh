#!/bin/bash
REGISTRATION_CODE=`echo $REGISTRATION_CODE | tr -d '"'`
echo $REGISTRATION_CODE > /tmp/checkcode
/usr/bin/checkip 
echo OK > /tmp/checkps
echo "apache ALL=(ALL) NOPASSWD: /usr/bin/checkupg, /usr/bin/checkver" >> /etc/sudoers
rm -f /var/www/localhost/htdocs/index.html
/usr/sbin/httpd -k start
cat /tmp/cronjobs | crontab -
rm -rf /var/www/localhost/htdocs/.git
ln -s /tmp/checklogs /var/www/localhost/htdocs/node.log  
/usr/sbin/crond -b
exec /app/presearch-node >> /tmp/checklogs 
