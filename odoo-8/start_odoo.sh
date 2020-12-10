#!/bin/bash

set -ex

# prepare postgres
[[ -d /var/lib/postgresql ]] || mkdir -p /var/lib/postgresql
chown -R postgres.postgres /var/lib/postgresql/
chown -R postgres.postgres /var/log/postgresql
#gpasswd -a postgres ssl-cert
#chown root:ssl-cert  /etc/ssl/private/ssl-cert-snakeoil.key
#chmod 640 /etc/ssl/private/ssl-cert-snakeoil.key
#chown postgres:ssl-cert /etc/ssl/private
chown -R postgres:postgres  /var/run/postgresql
chown -R postgres:postgres /etc/postgresql

# initialize postgres dir if it is empty
find /var/lib/postgresql -maxdepth 0 -empty -exec sh -c 'pg_dropcluster 9.4 main && pg_createcluster 9.4 main' \;
/etc/init.d/postgresql start

# reindex incase database courrpted 

su - postgres -c "psql odoo -c 'REINDEX INDEX ir_translation_src_hash_idx'" || true

locale-gen en_US.UTF-8

#exec su postgres -c "/usr/lib/postgresql/9.4/bin/postgres -D /var/lib/postgresql/9.4/main -c config_file=/etc/postgresql/9.4/main/postgresql.conf"

su - postgres -c "psql -t -c '\du' | cut -d \| -f 1 | grep -qw odoo && echo odoo user already exist || createuser odoo"
su - postgres -c "psql -lqt | cut -d \| -f 1 | grep -qw  odoo && echo odoo database is already exist || createdb odoo -O odoo --encoding='utf-8' --template=template0"

# stop postgres as we gonna start it using supervisord
/etc/init.d/postgresql stop

# Substitude the environment variables in backup template, note am using § to  escape character  $
AWS_ACCESS_KEY_ID=${AWS_ACCESS_KEY_ID:-""} \
AWS_SECRET_ACCESS_KEY=${AWS_SECRET_ACCESS_KEY:-""} \
RESTIC_REPOSITORY=${RESTIC_REPOSITORY:-""}
RESTIC_PASSWORD=${RESTIC_PASSWORD:-""} \
envsubst < /etc/templates/backup-template | sed -e 's/§/$/g' >  /root/backup.sh

chmod +x /root/backup.sh

cat << EOF > /mycron
0 0 * * * /root/backup.sh >> /root/backup.log 2>&1
EOF

crontab /mycron

[[ -d /opt/odoo ]] || mkdir /opt/odoo
chown -R odoo /opt/odoo

supervisord -n -c /etc/supervisor/supervisord.conf
