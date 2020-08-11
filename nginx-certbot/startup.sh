chmod 600 /etc/ssh/*_key
echo $PUBKEY > ~/.ssh/authorized_keys
service ssh start
trc -local 127.0.0.1:80 -local-tls 127.0.0.1:443 -remote $TFGATEWAY & 
while ! nc -z $SOLUTION_IP $SOLUTION_PORT </dev/null; do sleep 1; done
certbot --nginx -n -m "$EMAIL" --agree-tos  --domains "$DOMAIN" 
rm -f /etc/nginx/sites-enabled/default
if [ "$ENFORCE_HTTPS" = 'true' ] ; then
    cp /config/nginx-https.conf /etc/nginx/sites-enabled/default
else
	cp /config/nginx.conf /etc/nginx/sites-enabled/default
fi
sed -i "s/DOMAIN/$DOMAIN/g" /etc/nginx/sites-enabled/default
sed -i "s/SOLUTION_IP/$SOLUTION_IP/g" /etc/nginx/sites-enabled/default
sed -i "s/SOLUTION_PORT/$SOLUTION_PORT/g" /etc/nginx/sites-enabled/default
certbot --domains $DOMAIN --non-interactive --redirect --authenticator standalone --installer nginx --post-hook "service nginx start"
service nginx reload

