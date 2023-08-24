#!/bin/bash

echo "Before docker info sleep loop." >> /usr/local/bin/nextcloud_installation.md

export COMPOSE_HTTP_TIMEOUT=800
set -x
while ! docker info > /dev/null 2>&1; do
    sleep 2
done

echo "After docker info sleep loop." >> /usr/local/bin/nextcloud_installation.md

docker run \
--init \
--sig-proxy=false \
--name nextcloud-aio-mastercontainer \
--restart always \
--publish 80:80 \
--publish 8080:8080 \
--publish 8443:8443 \
--volume nextcloud_aio_mastercontainer:/mnt/docker-aio-config \
--volume /var/run/docker.sock:/var/run/docker.sock:ro \
nextcloud/all-in-one:latest