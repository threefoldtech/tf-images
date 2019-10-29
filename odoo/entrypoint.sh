#!/usr/bin/env bash
service postgresql start
su -c "createuser -s odoo" postgres || true
su -c "odoo -c /etc/odoo/odoo.conf" odoo