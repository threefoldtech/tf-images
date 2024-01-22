#!/bin/bash

# Set SSH public key from environment variable
if [ -n "$SSH_KEY" ]; then
    mkdir -p /root/.ssh
    echo "$SSH_KEY" > /root/.ssh/authorized_keys
    chmod 700 /root/.ssh
    chmod 600 /root/.ssh/authorized_keys
fi

mkdir -p /run/sshd
# Start the SSH server
/usr/sbin/sshd

export PASSWORD="password"
if [ -n "$CODE_SERVER_PASSWORD" ]; then
    export PASSWORD=$CODE_SERVER_PASSWORD
fi

exec code-server --bind-addr "[::]:8080"
