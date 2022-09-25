#!/bin/bash

set -x

if [ $NODE_TYPE == 'indexer' ]; then
    cd /indexer
    
    # Bootstrap Algorand node data directory on VM from algorand-node docker image
    docker-compose run algorand-node sh -c "cp -R /root/node/data/* /var/algorand/data/"
    docker-compose run algorand-node sh -c "cp /var/algorand/config.json /var/algorand/data/"
    
    # Start everything up
    docker-compose up -d
fi