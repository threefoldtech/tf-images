#!/bin/bash

echo "ufw is not yet set." >> /usr/local/bin/nextcloud_installation.md

set -x

ufw default deny incoming
ufw default allow outgoing
ufw allow ssh
ufw allow http
ufw allow https
ufw allow 8443
ufw limit ssh

echo "ufw is set." >> /usr/local/bin/nextcloud_installation.md