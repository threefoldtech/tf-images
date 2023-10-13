#!/bin/sh

set -ex

mkdir -p /code
cd /code
rm -rf *


wget -cnv https://github.com/threefoldtech/0-hub/archive/refs/tags/${ZHUB_VERSION}.tar.gz  -O /tmp/src.tar.gz
tar --strip-components=1 -xzf /tmp/src.tar.gz -C ./
rm /tmp/src.tar.gz

