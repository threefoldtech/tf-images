#!/bin/sh

set -ex

cd /app
rm -rf *


wget -cnv https://github.com/threefoldtech//tfchain_activation_service/archive/refs/tags/${TFCHAIN_ACTIVATION_SERVICE_VERSION}.tar.gz  -O /tmp/src.tar.gz
tar --strip-components=1 -xzf /tmp/src.tar.gz -C ./
rm /tmp/src.tar.gz 

npm ci --production