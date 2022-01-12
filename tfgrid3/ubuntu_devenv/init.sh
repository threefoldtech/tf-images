#!/bin/bash

# SSH server
# echo $SSH_KEY >> /root/.ssh/authorized_keys

mkdir -p ~/.ssh
mkdir -p /var/run/sshd
echo $SSH_KEY >> ~/.ssh/authorized_keys
chmod 600 ~/.ssh/authorized_keys

# service ssh start

service redis-server start

# "Run vserver, logs located in: /var/log/vserver"
vserver &>> /var/log/vserver &

# "Run VWeblet"
pushd /root/weblets_pocs/poc2/VWeblet
npm run vtwin &>> /var/log/vtwin &
popd

if [[ ! -z "$TWIN_ID" ]] ;
then
    echo "Run msgbusd with twinId $TWIN_ID on devnet"
    msgbusd --twin $TWIN_ID &>> /var/log/msgbusd &
fi

echo '
export GOPATH=$HOME/go
export PATH=$PATH:$GOPATH/bin
export PATH=$PATH:$GOPATH/bin:/usr/local/go/bin
' >> ~/.profile

exec /usr/sbin/sshd -D

# sleep infinity