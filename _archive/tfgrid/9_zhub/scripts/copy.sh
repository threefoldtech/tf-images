#!/bin/sh
set -e

if test -f "/env.sh"; then
    source /env.sh
fi
if test -f "env.sh"; then
    source env.sh
fi


mkdir -p /myhost/unknown/zhub/app
rm -f /myhost/unknown/zhub/app/*
cp -R /code/* /myhost/unknown/zhub/app/

echo " ** COPY DONE"



