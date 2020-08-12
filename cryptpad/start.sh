#!/bin/bash
mkdir ~/.ssh
mkdir -p /var/run/sshd
chmod 600 ~/.ssh
chmod 600 /etc/ssh/*
touch ~/.ssh/authorized_keys
chmod 600 ~/.ssh/authorized_keys
echo $pub_key >> ~/.ssh/authorized_keys
chmod 600 ~/.ssh/authorized_keys
service ssh start
cd /cryptpad/ && node server
