#!/bin/bash

set -x

if [ ! -z "$SSH_KEY" ]; then
    mkdir -p /var/run/sshd
    mkdir -p /root/.ssh
    chmod 755 /var/run/sshd
    chmod 700 /root/.ssh

fi