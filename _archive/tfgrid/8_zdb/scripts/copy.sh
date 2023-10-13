#!/bin/sh
set -e

if test -f "/env.sh"; then
    source /env.sh
fi
if test -f "env.sh"; then
    source env.sh
fi


mkdir -p /myhost/alpine/zdb/bin
rm -f /myhost/alpine/zdb/bin/*
cp /code/bin/* /myhost/alpine/zdb/bin/

echo " ** COPY DONE"



