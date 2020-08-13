#!/bin/bash

# enable ssh
chmod 600 /etc/ssh/*_key
echo $pub_key > ~/.ssh/authorized_keys
service ssh start

echo "127.0.0.1 localhost" > /etc/hosts
chmod 777 /etc/hosts

certbot --test-cert --nginx -n -m "$2" --agree-tos
cd /var/www/peertube/peertube-latest
sed -i "s/hostname: 'example.com'/hostname: '$1'/" /var/www/peertube/config/production.yaml
sed -i "s/peertube\.example\.com/$1/g" /etc/nginx/sites-available/peertube
sed -i "s/# server_names_hash_bucket_size: 64/server_names_hash_bucket_size: 128/" /etc/nginx/nginx.conf
ln -s /etc/nginx/sites-available/peertube /etc/nginx/sites-enabled/peertube
sed -i 's/ssl_certificate/# ssl_certificate/g' /etc/nginx/sites-available/peertube
certbot --test-cert --domains $1 --non-interactive --redirect --authenticator standalone --installer nginx --post-hook "service nginx start"
service nginx reload

chown -R postgres:postgres /var/lib/postgresql /etc/postgresql/10 /run/postgresql /var/log/postgresql
chown -R root:ssl-cert /etc/ssl/private
chmod 0640 /etc/ssl/private/ssl-cert-snakeoil.key

service postgresql start
redis-server --daemonize yes
sed -zi "s/signup:\n  enabled: false\n  limit: 10/signup:\n  enabled: true\n  limit: -1/" /var/www/peertube/config/production.yaml
NODE_ENV=production NODE_CONFIG_DIR=/var/www/peertube/config NODE_OPTIONS="--max-old-space-size=4096" npm start

