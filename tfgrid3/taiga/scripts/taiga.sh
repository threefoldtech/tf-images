#!/usr/bin/env sh

export COMPOSE_HTTP_TIMEOUT=800
set -x
while ! docker info > /dev/null 2>&1; do
    sleep 2
done
exec docker-compose -f /docker/docker-compose.yml up $@

