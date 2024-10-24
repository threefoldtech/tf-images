#!/bin/sh

set -x

if [ ! -z "$SSH_KEY" ]; then
    mkdir -p /var/run/sshd
    mkdir -p /root/.ssh
    touch /root/.ssh/authorized_keys
    
    chmod 700 /root/.ssh
    chmod 600 /root/.ssh/authorized_keys
fi
