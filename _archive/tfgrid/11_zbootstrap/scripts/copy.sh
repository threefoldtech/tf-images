#!/bin/sh
set -e

if test -f "/env.sh"; then
    source /env.sh
fi
if test -f "env.sh"; then
    source env.sh
fi


mkdir -p /myhost/alpine/zbootstrap/
rm -rf /myhost/alpine/zbootstrap/*
cp -R /opt /myhost/alpine/zbootstrap/opt
cp -R /code /myhost/alpine/zbootstrap/app

echo " ** COPY DONE"



