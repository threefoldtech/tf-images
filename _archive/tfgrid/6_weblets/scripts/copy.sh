#!/bin/sh
set -e

if test -f "/env.sh"; then
    source /env.sh
fi
if test -f "env.sh"; then
    source env.sh
fi


mkdir -p /myhost/unknown/grid_weblets/app
rm -rf /myhost/unknown/grid_weblets/app/*
cp -R /app/dist/* /myhost/unknown/grid_weblets/app/

echo " ** COPY DONE"



