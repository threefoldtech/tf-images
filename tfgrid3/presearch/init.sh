#!/bin/bash

# xtrace the commands
set -x

# check the env vars
if ! grep -q "$SSH_KEY" /root/.ssh/authorized_keys; then
    echo $SSH_KEY >> /root/.ssh/authorized_keys
fi

if [ -z $PRESEARCH_REGISTRATION_CODE ]; then
    echo "$PRESEARCH_REGISTRATION_CODE not set, Please set it"
fi

# start the services
service ssh start
service docker start

# clean docker space
docker stop presearch-node
docker rm presearch-node
docker stop presearch-auto-updater
docker rm presearch-auto-updater

# run node and updater containers
docker run -d --name presearch-auto-updater --restart=unless-stopped -v /var/run/docker.sock:/var/run/docker.sock presearch/auto-updater --cleanup --interval 900 presearch-auto-updater presearch-node
docker pull presearch/node
docker run -dt --name presearch-node --restart=unless-stopped -v presearch-node-storage:/app/node -e REGISTRATION_CODE=$PRESEARCH_REGISTRATION_CODE presearch/node
docker logs -f presearch-node

exec $@
