#!/bin/sh

set -ex

mkdir -p /code
cd /code
rm -rf *


wget -cnv https://github.com/threefoldtech/0-initramfs/archive/refs/tags/${ZINITRAMFS_VERSION}.tar.gz  -O /tmp/src.tar.gz
tar --strip-components=1 -xzf /tmp/src.tar.gz -C ./
rm /tmp/src.tar.gz

source autobuild/tf-build-settings.sh
bash initramfs.sh
