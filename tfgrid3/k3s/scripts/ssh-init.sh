#!/bin/bash

set -x

if [ ! -z "$SSH_KEY" ]; then
    mkdir -p /var/run/sshd
    mkdir -p /root/.ssh
    
    chmod 700 /root/.ssh

    echo "$SSH_KEY" > /root/.ssh/authorized_keys
    chmod 600 /root/.ssh/authorized_keys
fi
