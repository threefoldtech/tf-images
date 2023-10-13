#!/bin/sh
set -e

if test -f "/env.sh"; then
    source /env.sh
fi
if test -f "env.sh"; then
    source env.sh
fi


mkdir -p /myhost/unknown/tfgrid_dashboard/app
rm -rf /myhost/unknown/tfgrid_dashboard/app/*
cp -R /app/dist/* /myhost/unknown/tfgrid_dashboard/app/

echo " ** COPY DONE"



