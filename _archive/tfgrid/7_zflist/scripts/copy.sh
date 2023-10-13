#!/bin/sh
set -e

if test -f "/env.sh"; then
    source /env.sh
fi
if test -f "env.sh"; then
    source env.sh
fi


mkdir -p /myhost/ubuntu/zflist/bin
cp /tmp/zflist /myhost/ubuntu/zflist/bin/

echo " ** COPY DONE"



