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

# check for restore key
if [ ! -z "$PRESEARCH_BACKUP_PRI_KEY" ] && [ ! -z "$PRESEARCH_BACKUP_PUB_KEY" ] ; then
    mkdir presearch-node-keys/
    echo -e "-----BEGIN PRIVATE KEY-----\n$PRESEARCH_BACKUP_PRI_KEY\n-----END PRIVATE KEY-----" > presearch-node-keys/id_rsa
    echo -e "-----BEGIN PUBLIC KEY-----\n$PRESEARCH_BACKUP_PUB_KEY\n-----END PUBLIC KEY-----" > presearch-node-keys/id_rsa.pub
    chmod -R 644 presearch-node-keys/id_rsa

    docker run -dt --rm -v presearch-node-storage:/app/node --name presearch-restore presearch/node
    docker cp presearch-node-keys/. presearch-restore:/app/node/.keys/
    docker stop presearch-restore 
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
# removed from the following two run command for debuging "--restart=unless-stopped"

docker run -d --name presearch-auto-updater -v /var/run/docker.sock:/var/run/docker.sock presearch/auto-updater --cleanup --interval 900 presearch-auto-updater presearch-node
docker pull presearch/node
docker run -dt --name presearch-node -v presearch-node-storage:/app/node -e REGISTRATION_CODE=$PRESEARCH_REGISTRATION_CODE presearch/node
docker logs -f presearch-node

exec $@