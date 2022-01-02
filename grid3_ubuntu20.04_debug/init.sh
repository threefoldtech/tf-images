#!/bin/bash

mkdir -p ~/.ssh
echo $SSH_KEY >> ~/.ssh/authorized_keys
chmod 600 ~/.ssh/authorized_keys
exec /usr/sbin/sshd -D
