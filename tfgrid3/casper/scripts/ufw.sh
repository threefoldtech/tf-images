#!/bin/bash
set -x

ufw default deny incoming
ufw default allow outgoing
ufw allow ssh
ufw limit ssh
ufw allow 7777
ufw allow 8888
ufw allow 9999
ufw allow 35000
ufw allow 80
ufw allow 443
