#!/bin/sh
set -e

if test -f "/env.sh"; then
    source /env.sh
fi
if test -f "env.sh"; then
    source env.sh
fi


mkdir -p /myhost/alpine/gridproxy/bin
rm -rf /myhost/alpine/gridproxy/bin/*
cp /app/gridproxy/server /myhost/alpine/gridproxy/bin/
cp /app/yggdrasil/yggdrasil /myhost/alpine/gridproxy/bin/
cp /app/yggdrasil/yggdrasilctl /myhost/alpine/gridproxy/bin/
cp /app/rmb/cmds/msgbusd/msgbusd /myhost/alpine/gridproxy/bin/
cp /app/yggdrasil/genkeys /myhost/alpine/gridproxy/bin/

echo " ** COPY DONE"



