#!/bin/bash

set -x

ufw default deny incoming
ufw default allow outgoing
ufw allow ssh
ufw allow 443
ufw allow 80
ufw limit ssh

