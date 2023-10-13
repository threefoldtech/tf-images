#!/bin/sh

set -ex

cd /app
rm -rf *


wget -cnv https://github.com/threefoldtech//grid_weblets/archive/refs/tags/${WEBLETS_VERSION}.tar.gz  -O /tmp/src.tar.gz
tar --strip-components=1 -xzf /tmp/src.tar.gz -C ./
rm /tmp/src.tar.gz 

# avoid `JavaScript heap out of memory`
# webpack workaround for node17+
export NODE_OPTIONS="--max-old-space-size=6144 --openssl-legacy-provider"

npm install -g yarn
# no optional deps since this installs and compiles sodium-native
# ignore scripts since the prepare script calls husky and it's not a git repo
yarn install --no-optional --ignore-scripts
yarn build

cd playground
yarn install
yarn build


