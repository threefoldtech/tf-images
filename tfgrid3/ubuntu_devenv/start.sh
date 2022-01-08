#!/bin/bash

# SSH server
echo $SSH_KEY >> /root/.ssh/authorized_keys

service ssh start

service redis-server start

echo '
export GOPATH=$HOME/go
export PATH=$PATH:$GOPATH/bin
export PATH=$PATH:$GOPATH/bin:/usr/local/go/bin
' >> ~/.profile


sleep infinity