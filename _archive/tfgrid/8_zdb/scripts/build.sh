#!/bin/sh

set -ex

mkdir -p /code
cd /code
rm -rf *


wget -cnv https://github.com/threefoldtech/0-db/archive/refs/tags/${ZDB_VERSION}.tar.gz  -O /tmp/src.tar.gz
tar --strip-components=1 -xzf /tmp/src.tar.gz -C ./
rm /tmp/src.tar.gz

make release
