#!/bin/bash

set -ex

# start postgres to create postgres database odoo user and database , are exist or not

if [ -d /var/run/postgresql ]; then
    chmod 2775 /var/run/postgresql
else
    install -d -m 2775 -o postgres -g postgres /var/run/postgresql
fi

exec su postgres -c "/usr/lib/postgresql/9.4/bin/postgres -D /var/lib/postgresql/9.4/main -c config_file=/etc/postgresql/9.4/main/postgresql.conf"

su - postgres -c "psql -t -c '\du' | cut -d \| -f 1 | grep -qw odoo && echo odoo user already exist || createuser odoo"
su - postgres -c "psql -lqt | cut -d \| -f 1 | grep -qw  odoo && echo odoo database is already exist || createdb odoo -O odoo --encoding='utf-8'--template=template0"

# stop postgres as we gonna start it using supervisord
pkill -9 postgres

supervisord -n -c /etc/supervisor/supervisord.conf
