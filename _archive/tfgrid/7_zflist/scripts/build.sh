#!/bin/sh

set -ex

mkdir -p /code/threefoldtech/
cd /code/threefoldtech/ 
rm -rf *
mkdir zflist
cd zflist


wget -cnv https://github.com/threefoldtech/0-flist/archive/refs/tags/${ZFLIST_VERSION}.tar.gz  -O /tmp/src.tar.gz
tar --strip-components=1 -xzf /tmp/src.tar.gz -C ./
rm /tmp/src.tar.gz 

source autobuild/dependencies.sh

capnp
libcurl

pushd libflist
make
popd

pushd zflist
make production
popd

cp zflist/zflist /tmp/zflist
strip -s /tmp/zflist
