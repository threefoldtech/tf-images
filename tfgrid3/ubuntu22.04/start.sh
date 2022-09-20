#!/bin/bash

mkdir -p /var/run/sshd
mkdir -p /root/.ssh/ 
echo $SSH_KEY > /root/.ssh/authorized_keys
exec /usr/sbin/sshd