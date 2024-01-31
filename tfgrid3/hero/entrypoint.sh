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
exec /usr/sbin/sshd -D
