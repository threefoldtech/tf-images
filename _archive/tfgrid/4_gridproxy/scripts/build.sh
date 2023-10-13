#!/bin/sh

set -ex

cd /app
rm -rf *


mkdir /app/gridproxy

wget -cnv https://github.com/threefoldtech//tfgridclient_proxy/archive/refs/tags/${GRIDPROXY_VERSION}.tar.gz  -O /tmp/src.tar.gz
tar --strip-components=1 -xzf /tmp/src.tar.gz -C /app/gridproxy
rm /tmp/src.tar.gz

YGGDRASIL_VERSION=$(awk -F= '/YGG_VERS/ { print $2}' /app/gridproxy/Dockerfile)
mkdir /app/yggdrasil
cd /app/yggdrasil
git clone --depth 1 --branch $YGGDRASIL_VERSION https://github.com/yggdrasil-network/yggdrasil-go.git .
./build && go build -o genkeys cmd/genkeys/main.go

mkdir /app/rmb
wget -cnv https://github.com/threefoldtech/rmb_go/archive/refs/tags/v0.2.2.tar.gz  -O /tmp/src.tar.gz
tar --strip-components=1 -xzf /tmp/src.tar.gz -C /app/rmb
rm /tmp/src.tar.gz

cd /app/rmb/cmds/msgbusd
CGO_ENABLED=0 GOOS=linux go build -ldflags '-w -s -extldflags "-static"' -o msgbusd


cd /app/gridproxy
CGO_ENABLED=0 GOOS=linux go build -ldflags "-w -s -X main.GitCommit=$GRIDPROXY_VERSION -extldflags '-static'" -o server cmds/proxy_server/main.go 


