#!/usr/bin/env bash

#Start postgresql and create user
locale-gen en_US.UTF-8
export LC_ALL=en_US.UTF-8
service postgresql start
sudo -u postgres createuser taiga
sudo -u postgres createdb taiga -O taiga --encoding='utf-8' --locale=en_US.utf8 --template=template0

# Install dependencies and populate database
cd /taiga/taiga-back
sudo chmod +x /opt/bin/prepare_taiga.sh
su taiga -c 'bash /opt/bin/prepare_taiga.sh'

# Start rabbitmq-server and create user+vhost
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

#Start taiga
su taiga -c 'python3 /opt/bin/start_events.py'
exec "$@"