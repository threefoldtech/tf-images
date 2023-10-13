#!/bin/sh

set -ex

cd /app
rm -rf *


wget -cnv https://github.com/threefoldtech/tfchain_graphql/archive/refs/tags/${GRAPHQL_VERSION}.tar.gz  -O /tmp/src.tar.gz
tar --strip-components=1 -xzf /tmp/src.tar.gz -C ./
rm /tmp/src.tar.gz 

# dependencies for building
npm ci

npm run build

rm -rf node_modules
# dependencies for production
npm ci --production