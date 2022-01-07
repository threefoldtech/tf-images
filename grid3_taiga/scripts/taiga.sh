#!/usr/bin/env sh

export COMPOSE_HTTP_TIMEOUT=800
set -x
while ! docker info > /dev/null 2>&1; do
    sleep 2
done

if [ -z "$DEFAULT_FROM_EMAIL" ] || [ -z "$EMAIL_USE_TLS" ] || [ -z "$EMAIL_USE_SSL" ] || [ -z "$EMAIL_HOST" ] || [ -z "$EMAIL_PORT" ] || [ -z "$EMAIL_HOST_USER" ] || [ -z "$EMAIL_HOST_PASSWORD" ]; then
    echo "Warning: Missing required env vars for smtp service! Email notifications will not be sent and will be only shown in the stdout"
    exec docker-compose -f /docker/docker-compose.yml up $@
else
    exec docker-compose -f /docker/docker-compose-smtp.yml -f /docker/docker-compose.yml up $@
fi