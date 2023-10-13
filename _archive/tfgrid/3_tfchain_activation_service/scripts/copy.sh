#!/bin/sh
set -e

if test -f "/env.sh"; then
    source /env.sh
fi
if test -f "env.sh"; then
    source env.sh
fi


mkdir -p /myhost/unknown/tfchain_activation_service/
rm -rf /myhost/unknown/tfchain_activation_service/*
cp -R /app /myhost/unknown/tfchain_activation_service/

echo " ** COPY DONE"



