#!/bin/bash

# Download the repo and create the directories
mkdir -p /mnt/disk/code
cd /mnt/disk/code
git clone https://github.com/threefoldtech/grid_deployment
cd /mnt/disk/code/grid_deployment

# Temporary: got to working branch
git checkout development_pv_2
# Go to the network directory
cd /mnt/disk/code/grid_deployment/docker-compose/${NETWORK}net

# Copy the secret env file
cp .secrets.env-example .secrets.env

# Create a subkey and store into KEY variable, with .gitignore exception
grep -qxF ".subkey_${NETWORK}net" .gitignore || echo -e "\n.subkey_${NETWORK}net" >> .gitignore
../../apps/subkey generate-node-key > .subkey_${NETWORK}net
KEY=$(cat .subkey_${NETWORK}net)

# Set variables in secret env file
sed -i "s/DOMAIN\=grid.tf/example.com/g" .secrets.env
sed -i "s/DOMAIN\=/DOMAIN\=${DOMAIN}/g" .secrets.env
sed -i "s/TFCHAIN_NODE_KEY\=/TFCHAIN_NODE_KEY\=${KEY}/g" .secrets.env
sed -i "s/ACTIVATION_SERVICE_MNEMONIC\=\"\"/ACTIVATION_SERVICE_MNEMONIC\=\"${SEED}\"/g" .secrets.env
sed -i "s/GRID_PROXY_MNEMONIC\=\"\"/GRID_PROXY_MNEMONIC\=\"${SEED}\"/g" .secrets.env

# Load and deploy the TFGrid Stack
yes y | sh install_grid_bknd.sh