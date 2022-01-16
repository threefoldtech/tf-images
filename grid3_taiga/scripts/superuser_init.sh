#!/bin/bash

script="
from taiga.users.models import User

username = '$ADMIN_USERNAME'
password = '$ADMIN_PASSWORD'
email = '$ADMIN_EMAIL'

if User.objects.filter(username=username).count()==0:
    User.objects.create_superuser(username, email, password)
    print('Superuser created.')
else:
    print('Username exists. Superuser creation skipped.')
"

if [ -z "$ADMIN_USERNAME" ] || [ -z "$ADMIN_EMAIL" ] || [ -z "$ADMIN_PASSWORD" ]; then
        echo "Error: Missing required env vars! Superuser creation skipped."
        exit 1
else
        while ! ps aux | grep [t]aiga.wsgi:application -q; do
                sleep 30
        done

        docker exec docker_taiga-back_1 bash -c "printf \"$script\" | DJANGO_SETTINGS_MODULE=settings.config python manage.py shell"
fi