#!/bin/sh

set -x 

touch /tmp/init_postgres.sql

export PEERTUBE_WEBSERVER_PORT="443"
export PEERTUBE_DB_SUFFIX="_prod"
export PEERTUBE_DB_USERNAME="peertube"
export PEERTUBE_DB_PASSWORD="peertube"

cat <<EOF > /tmp/init_postgres.sql
create database peertube$PEERTUBE_DB_SUFFIX;
create user $PEERTUBE_DB_USERNAME password '$PEERTUBE_DB_PASSWORD';
grant all privileges on database peertube$PEERTUBE_DB_SUFFIX to $PEERTUBE_DB_USERNAME;
\c peertube$PEERTUBE_DB_SUFFIX
CREATE EXTENSION pg_trgm;
CREATE EXTENSION unaccent;
EOF

su postgres -c "psql --file=/tmp/init_postgres.sql"