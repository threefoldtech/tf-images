#!/bin/bash

set -x


# set credi
pass="${ADMIN_PASSWORD:=pass}"

mkdir -p ~/.config/code-server
touch ~/.config/code-server/config.yaml

echo "bind-addr: 0.0.0.0:8080
auth: password
password: $pass
cert: false" > ~/.config/code-server/config.yaml