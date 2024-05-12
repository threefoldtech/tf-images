#!/bin/bash

# generate host keys if not present
ssh-keygen -A

# add user key to authorized_keys
mkdir -p /root/.ssh

# do not detach (-D), log to stderr (-e), passthrough other arguments
exec /usr/sbin/sshd -D -e "$@"
