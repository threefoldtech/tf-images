#!/bin/sh

set -x

ufw default allow outgoing
ufw default deny incoming
ufw allow ssh
ufw allow 9000
ufw enable

