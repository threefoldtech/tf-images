#!/bin/sh
set -e

if test -f "/env.sh"; then
    source /env.sh
fi
if test -f "env.sh"; then
    source env.sh
fi


mkdir -p /myhost/ubuntu/tfchain/bin
cp /code/threefoldtech/tfchain/substrate-node/target/release/tfchain /myhost/ubuntu/tfchain/bin/

mkdir -p /myhost/ubuntu/tfchain/etc
rm -rf /myhost/ubuntu/tfchain/etc/*

cp -R /code/threefoldtech/tfchain/substrate-node/chainspecs /myhost/ubuntu/tfchain/etc/

echo " ** COPY DONE"



