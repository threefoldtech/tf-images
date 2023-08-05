#!/bin/bash

echo "ssh is not yet set." >> /usr/local/bin/nextcloud_installation.md

mkdir -p ~/.ssh
mkdir -p /var/run/sshd
chmod 600 ~/.ssh
chmod 600 /etc/ssh/*
echo $SSH_KEY >> ~/.ssh/authorized_keys

echo "ssh is set." >> /usr/local/bin/nextcloud_installation.md