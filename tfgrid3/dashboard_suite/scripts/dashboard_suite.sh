#!/bin/bash

# Go to the network directory
cd /code/grid_deployment/docker-compose/${NETWORK}net

# Copy the secret env file
cp .secrets.env-example .secrets.env

# Set the secret key
KEY=$(tr -dc A-Za-z0-9 </dev/urandom | head -c 18; echo)

# Set variables in file
sed -i "s/DOMAIN\=/DOMAIN\=${DOMAIN}/g" .secrets.env
sed -i "s/TFCHAIN_NODE_KEY\=/TFCHAIN_NODE_KEY\=${KEY}/g" .secrets.env
sed -i "s/ACTIVATION_SERVICE_MNEMONIC\=\"\"/ACTIVATION_SERVICE_MNEMONIC\=\"${SEED}\"/g" .secrets.env
sed -i "s/GRID_PROXY_MNEMONIC\=\"\"/GRID_PROXY_MNEMONIC\=\"${SEED}\"/g" .secrets.env

# Load and deploy the TFGrid Stack
sh install_grid_bknd.sh