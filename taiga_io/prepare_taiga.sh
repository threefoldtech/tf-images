#!/usr/bin/env bash
set -x

# Install dependencies and populate database
/taiga/bin/python3 manage.py migrate --noinput
/taiga/bin/python3 manage.py loaddata initial_user
/taiga/bin/python3 manage.py loaddata initial_project_templates
echo "wait 3 seconds to sync data to disk is required by ZeroOS in mounting points"
sleep 3 ; sync
/taiga/bin/python3 manage.py compilemessages
/taiga/bin/python3 manage.py collectstatic --noinput

# Edit conf files for frontend
sed -i "s|https://circles.threefold.me/api|https://$TAIGA_HOSTNAME/api|g" /home/taiga/taiga-front-dist/dist/conf.json
sed -i "s|wss://circles.threefold.me/events|wss://$TAIGA_HOSTNAME/events|g" /home/taiga/taiga-front-dist/dist/conf.json
# Edit config.json for events
sed -i "s|amqp://guest:guest@localhost:5672|amqp://taiga:$SECRET_KEY@localhost:5672/taiga|g" /home/taiga/taiga-events/config.json
sed -i "s|mysecret|$SECRET_KEY|g" /home/taiga/taiga-events/config.json
