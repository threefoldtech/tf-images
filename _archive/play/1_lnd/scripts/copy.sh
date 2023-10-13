#!/bin/sh
set -ex

if test -f "/env.sh"; then
    source /env.sh
fi
if test -f "env.sh"; then
    source env.sh
fi


export PS1="${NAME}: "

mkdir -p /myhost/alpine/${NAME}/bin
# cp /app/bin/* /myhost/alpine/${NAME}/bin/
cp /bin/lncli /myhost/alpine/${NAME}/bin/
cp /bin/lndconnect /myhost/alpine/${NAME}/bin/
# cp /bin/lnd  /myhost/alpine/${NAME}/bin/

echo " ** COPY DONE"



