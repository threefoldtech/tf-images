#!/bin/bash

set -x

ufw default deny incoming
ufw default allow outgoing
ufw allow ssh
ufw allow 9000
# ufw limit ssh

