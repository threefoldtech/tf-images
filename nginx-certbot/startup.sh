#!/bin/bash

chmod 600 /etc/ssh/*_key
echo $PUBKEY > ~/.ssh/authorized_keys
service ssh start
trc -local 127.0.0.1:80 -local-tls 127.0.0.1:443 -remote $TFGATEWAY & 
while ! nc -z $SOLUTION_IP $SOLUTION_PORT </dev/null; do sleep 1; done
cp /config/nginx.conf /etc/nginx/sites-enabled/default
sed -i "s/DOMAIN/$DOMAIN/g" /etc/nginx/sites-enabled/default
sed -i "s/SOLUTION_IP/$SOLUTION_IP/g" /etc/nginx/sites-enabled/default
sed -i "s/SOLUTION_PORT/$SOLUTION_PORT/g" /etc/nginx/sites-enabled/default
cmd="certbot --nginx --agree-tos  -m "$EMAIL" --non-interactive --domains $DOMAIN"
if [ "$ENFORCE_HTTPS" = 'true' ] ; then
  cmd=$cmd" --redirect"
else
  cmd=$cmd" --no-redirect"
fi
if [ "$TEST_CERT" = 'true' ] ; then
  cmd=$cmd" --test-cert"
fi
service nginx start

for i in {1..6}; do
if $cmd ; then
        break
fi
sleep 10
done

service nginx stop
nginx -g 'daemon off;'

