#!/usr/bin/env bash
# prepare postgres
chown -R postgres.postgres /var/lib/postgresql/
chown -R postgres.postgres /var/log/postgresql
gpasswd -a postgres ssl-cert
chown root:ssl-cert  /etc/ssl/private/ssl-cert-snakeoil.key
chmod 640 /etc/ssl/private/ssl-cert-snakeoil.key
chown postgres:ssl-cert /etc/ssl/private
chown -R postgres /var/run/postgresql
chown -R postgres.postgres /etc/postgresql

if [ -d /var/run/postgresql ]; then
    chmod 2775 /var/run/postgresql
else
    install -d -m 2775 -o postgres -g postgres /var/run/postgresql
fi

# prepare odoo
chown odoo /etc/odoo/odoo.conf
chown -R odoo.odoo /var/lib/odoo
chown -R odoo /mnt/extra-addons
chown -R postgres.postgres /supervisor/logs/postgresql
chown -R odoo.odoo /supervisor/logs/odoo

# use supervisord to start ssh, postgres and odoo
supervisord -c /etc/supervisor/supervisord.conf
echo "waiting 3 second to start postgres"
sleep 3
echo "create a odoo user in db"
su -c "createuser -s odoo" postgres || true

exec "$@"
