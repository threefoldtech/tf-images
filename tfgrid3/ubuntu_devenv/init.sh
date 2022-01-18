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

# "Run Weblets"
pushd /root/weblets_pocs
pushd poc1
yarn dev &>> /var/log/pkid &
popd
pushd poc2/VWeblet
npm run vtwin &>> /var/log/vtwin &
popd
pushd poc4
npm run example &>> /var/log/example &
popd
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

echo ":8886 {
        route /* {
                uri strip_prefix /*
                reverse_proxy http://127.0.0.1:8080
        }
}
" >> /etc/caddy/Caddyfile

# Codeserver password
if [[ ! -z "$CODESERVER_PASSWORD" ]] ;
then
export PASSWORD=$CODESERVER_PASSWORD
else
export PASSWORD=tfdev001
fi

code-server &>> /var/log/code-server &

pushd /etc/caddy
caddy fmt --overwrite
caddy run --config Caddyfile &>> /var/log/caddy/caddylogs &
popd

exec /usr/sbin/sshd -D
# sleep infinity