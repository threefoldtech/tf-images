#!/bin/sh

set -x

# default configs
cp /app/config/default.yaml /config

# overriden by productions configs
cp /app/support/docker/production/config/production.yaml /config

# schema to overriden by environment variables
cp /app/support/docker/production/config/custom-environment-variables.yaml /config

# Listen on ipv6
sed -i "0,/hostname: '0.0.0.0'/ s//hostname: '::'/" /config/production.yaml

# Start peertube server
cd /app
export NODE_CONFIG_DIR=/config 
export NODE_ENV=production 