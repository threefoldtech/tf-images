#!/bin/ash

# generate host keys if not present
ssh-keygen -A

# add user key to authorized_keys
mkdir -p /root/.ssh
echo $SSH_KEY >> /root/.ssh/authorized_keys
if [ ! -f "/nix/store" ]; then
    NIX_VERSION=2.3.14
    mkdir -p -m 0755 /nix && USER=root sh nix-${NIX_VERSION}-$(uname -m)-linux/install
    ln -s /nix/var/nix/profiles/default/etc/profile.d/nix.sh /etc/profile.d/
    rm -r /nix-${NIX_VERSION}-$(uname -m)-linux*
    rm -rf /var/cache/apk/*
    /nix/var/nix/profiles/default/bin/nix-collect-garbage --delete-old
    /nix/var/nix/profiles/default/bin/nix-store --optimise
    /nix/var/nix/profiles/default/bin/nix-store --verify --check-contents
fi
if [ -n "$NIX_CONFIG" ]; then
echo $NIX_CONFIG > /root/default.nix
fi
# do not detach (-D), log to stderr (-e), passthrough other arguments
exec /usr/sbin/sshd -D -e "$@"
