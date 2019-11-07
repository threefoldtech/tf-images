#!/usr/bin/env bash

#Start postgresql and create user
locale-gen en_US.UTF-8
export LC_ALL=en_US.UTF-8
chown -R postgres.postgres /var/lib/postgresql/
chown -R postgres.postgres /var/log/postgresql
gpasswd -a postgres ssl-cert
chown root:ssl-cert  /etc/ssl/private/ssl-cert-snakeoil.key
chmod 640 /etc/ssl/private/ssl-cert-snakeoil.key
chown postgres:ssl-cert /etc/ssl/private
chown -R postgres /var/run/postgresql
chown -R postgres.postgres /etc/postgresql

service postgresql start
sudo -u postgres createuser taiga
sudo -u postgres createdb taiga -O taiga --encoding='utf-8' --locale=en_US.utf8 --template=template0

# Install dependencies and populate database
chown -R taiga:taiga /home/taiga
chown -R taiga:taiga /taiga
cd /taiga/taiga-back
sudo chmod +x /opt/bin/prepare_taiga.sh
su taiga -c 'bash /opt/bin/prepare_taiga.sh'

# Start rabbitmq-server and create user+vhost
chown -R rabbitmq:rabbitmq /etc/rabbitmq
chown -R rabbitmq:rabbitmq /var/lib/rabbitmq/
chown -R rabbitmq:rabbitmq /var/log/rabbitmq/
service rabbitmq-server start
rabbitmqctl add_user taiga $SECRET_KEY 
rabbitmqctl add_vhost taiga
rabbitmqctl set_permissions -p taiga taiga ".*" ".*" ".*"

# Edit conf files for frontend
sed -i "s/localhost:8000/$HOST_IP:4321/g" /taiga/taiga-front-dist/dist/conf.json

# Edit config.json for events
sed -i "s/guest:guest/taiga:$SECRET_KEY/g" /taiga/taiga-events/config.json
sed -i "s/mysecret/$SECRET_KEY/g" /taiga/taiga-events/config.json

#Restart nginx
mkdir /taiga/logs/
sudo nginx -t && sudo service nginx restart

#start ssh
chmod -R 644 /etc/ssh
/etc/init.d/ssh start

#Start taiga
mkdir -p /taiga/supervisor/logs
chown -R taiga:taiga /taiga/supervisor/

supervisord -c /etc/supervisor/supervisord.conf
exec "$@"
