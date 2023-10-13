#!/bin/sh
set -e

if test -f "/env.sh"; then
    source /env.sh
fi
if test -f "env.sh"; then
    source env.sh
fi


mkdir -p /myhost/unknown/tfchain_graphql/app
rm -rf /myhost/unknown/tfchain_graphql/app/* 
cp /app/package.json /myhost/unknown/tfchain_graphql/app/
cp /app/package-lock.json /myhost/unknown/tfchain_graphql/app/
cp -R /app/node_modules /myhost/unknown/tfchain_graphql/app/
cp -R /app/lib /myhost/unknown/tfchain_graphql/app/
cp -R /app/db /myhost/unknown/tfchain_graphql/app/
cp /app/schema.graphql /myhost/unknown/tfchain_graphql/app/
cp /app/init-countries.js /myhost/unknown/tfchain_graphql/app/
cp -R /app/typegen /myhost/unknown/tfchain_graphql/app/

echo " ** COPY DONE"



