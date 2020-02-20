#!/usr/bin/env bash
set -ex

echo "checking env variables was set correctly "

if [[ -z "$SECRET_KEY" ]] || [[ -z "$EMAIL_HOST" ]] || [[ -z "$EMAIL_HOST_USER" ]] || [[ -z "$EMAIL_HOST_PASSWORD" ]] || [[ -z "$HOST_IP" ]] || [[ -z "$HTTP_PORT" ]] ; then
    echo " one of below variables are not set yet, Please set it in creating your container"
    echo "SECRET_KEY EMAIL_HOST EMAIL_HOST_USER EMAIL_HOST_PASSWORD HOST_IP HTTP_PORT"
    exit 1
fi

# Install dependencies and populate database
cd /home/taiga/taiga-back
virtualenv -p /usr/bin/python3 taiga
sudo /home/taiga/taiga-back/taiga/bin/pip3 install -r requirements.txt
/home/taiga/taiga-back/taiga/bin/python3 manage.py migrate --noinput
/home/taiga/taiga-back/taiga/bin/python3 manage.py loaddata initial_user
/home/taiga/taiga-back/taiga/bin/python3 manage.py loaddata initial_project_templates
/home/taiga/taiga-back/taiga/bin/python3 manage.py compilemessages
/home/taiga/taiga-back/taiga/bin/python3 manage.py collectstatic --noinput

# edit backend
sed -i "s|http://localhost/static/|https://$HOST_IP/static/|g"  /home/taiga/taiga-back/settings/local.py
sed -i "s|http://localhost/media/|https://$HOST_IP/media/|g" /home/taiga/taiga-back/settings/local.py
sed -i "s|'localhost'|\"$HOST_IP\"|g" /home/taiga/taiga-back/settings/local.py
sed -i "s|'http'|'https'|g" /home/taiga/taiga-back/settings/local.py
sed -i "s|smtp_email_host|$EMAIL_HOST|g" /home/taiga/taiga-back/settings/local.py
sed -i "s|email_user|$EMAIL_HOST_USER|g" /home/taiga/taiga-back/settings/local.py
sed -i "s|email_password|$EMAIL_HOST_PASSWORD|g" /home/taiga/taiga-back/settings/local.py
sed -i "s|your_sceret_key|$SECRET_KEY|g" /home/taiga/taiga-back/settings/local.py


# Edit conf files for frontend
sed -i "s|https://circles.threefold.me/api|https://$HOST_IP/api|g" /home/taiga/taiga-front-dist/dist/conf.json
sed -i "s|wss://circles.threefold.me/events|wss://$HOST_IP/events|g" /home/taiga/taiga-front-dist/dist/conf.json
# Edit config.json for events
sed -i "s|amqp://guest:guest@localhost:5672|amqp://taiga:$SECRET_KEY@localhost:5672/taiga|g" /home/taiga/taiga-events/config.json
sed -i "s|mysecret|$SECRET_KEY|g" /home/taiga/taiga-events/config.json
