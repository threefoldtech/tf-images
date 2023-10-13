#!/bin/sh

set -ex

mkdir -p /code/threefoldtech/
cd /code/threefoldtech/ 
rm -rf *
mkdir tfchain
cd tfchain


wget -cnv https://github.com/threefoldtech/tfchain/archive/refs/tags/${TFCHAIN_VERSION}.tar.gz  -O /tmp/tfchain.tar.gz
tar --strip-components=1 -xzf /tmp/tfchain.tar.gz -C ./
rm /tmp/tfchain.tar.gz 

source /usr/local/cargo/env
cd substrate-node
cargo build --release