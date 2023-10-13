#!/bin/sh

set -ex

cd /app
rm -rf *


wget -cnv https://github.com/threefoldtech//tfgrid_dashboard/archive/refs/tags/${DASHBOARD_VERSION}.tar.gz  -O /tmp/src.tar.gz
tar --strip-components=1 -xzf /tmp/src.tar.gz -C ./
rm /tmp/src.tar.gz 

npm install

npm run build
