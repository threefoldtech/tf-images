#!/usr/bin/env bash
chown -R postgres.postgres /var/lib/postgresql/
chown -R postgres.postgres /var/log/postgresql
gpasswd -a postgres ssl-cert
chown root:ssl-cert  /etc/ssl/private/ssl-cert-snakeoil.key
chmod 640 /etc/ssl/private/ssl-cert-snakeoil.key
chown postgres:ssl-cert /etc/ssl/private
chown -R postgres /var/run/postgresql
chown -R postgres.postgres /etc/postgresql
/etc/init.d/postgresql start
chown odoo /etc/odoo/odoo.conf
chown -R odoo.odoo /var/lib/odoo
chown -R odoo /mnt/extra-addons
su -c "createuser -s odoo" postgres || true
su -c "odoo -c /etc/odoo/odoo.conf" odoo
