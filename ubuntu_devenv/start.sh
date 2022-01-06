#!/bin/bash

# SSH server
echo $SSH_KEY >> /root/.ssh/authorized_keys

service ssh start

sleep infinity