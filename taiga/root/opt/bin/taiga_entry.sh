#!/usr/bin/env bash

#Start postgresql and create user
locale-gen en_US.UTF-8 
service postgresql start
sudo -u postgres createuser taiga
sudo -u postgres createdb taiga -O taiga --encoding='utf-8' --locale=en_US.utf8 --template=template0


# Install dependencies and populate database
cd /taiga/taiga-back
su taiga
source taiga/bin/activate
pip3 install -r requirements.txt
python3 manage.py migrate --noinput
python3 manage.py loaddata initial_user
python3 manage.py loaddata initial_project_templates
python3 manage.py compilemessages
python3 manage.py collectstatic --noinput

# Start rabbitmq-server and create user+vhost
sudo service rabbitmq-server start
sudo rabbitmqctl add_user taiga $SECRET_KEY 
sudo rabbitmqctl add_vhost taiga
sudo rabbitmqctl set_permissions -p taiga taiga ".*" ".*" ".*"


# Edit conf files for frontend
sed -i "s/localhost:8000/$HOST_IP:4321/g" /taiga/taiga-front-dist/dist/conf.json

# Edit config.json for events
sed -i "s/guest:guest/taiga:$SECRET_KEY/g" /taiga/taiga-events/config.json
sed -i "s/mysecret/$SECRET_KEY/g" /taiga/taiga-events/config.json

#Restart nginx
mkdir /taiga/logs/
sudo nginx -t && sudo service nginx restart

#Start taiga
tmux new -d -s taiga-back-session 'cd /taiga/taiga-back; taiga/bin/gunicorn --workers 4 --timeout 60 -b 127.0.0.1:8001 taiga.wsgi'; 
#Start taiga events
cd /taiga/taiga-events;
/bin/bash -c "node_modules/coffeescript/bin/coffee index.coffee"