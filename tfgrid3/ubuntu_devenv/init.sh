#!/bin/bash

# SSH server
# echo $SSH_KEY >> /root/.ssh/authorized_keys

mkdir -p ~/.ssh
mkdir -p /var/run/sshd
echo $SSH_KEY >> ~/.ssh/authorized_keys
chmod 600 ~/.ssh/authorized_keys

# service ssh start

# service redis-server start

echo '
export GOPATH=$HOME/go
export PATH=$PATH:$GOPATH/bin
export PATH=$PATH:$GOPATH/bin:/usr/local/go/bin
' >> ~/.profile

exec /usr/sbin/sshd -D

# sleep infinity