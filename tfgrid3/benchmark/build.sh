#!/bin/bash

if [ "$EUID" -ne 0 ]
  then echo "Please run as root"
  exit
fi


wget https://dl-cdn.alpinelinux.org/alpine/v3.19/releases/x86_64/alpine-minirootfs-3.19.1-x86_64.tar.gz
mkdir rootfs
tar xf alpine-minirootfs-3.19.1-x86_64.tar.gz -C rootfs
rm alpine-minirootfs-3.19.1-x86_64.tar.gz


echo "nameserver 1.1.1.1" > rootfs/etc/resolv.conf


mkdir rootfs/data rootfs/fio
chroot rootfs sh <<EOF
apk update
apk add fio openssh jq curl
EOF

wget https://github.com/threefoldtech/cpu-benchmark-simple/releases/download/v0.1/grid-cpubench-simple-0.1-linux-amd64-static -O cpubench
chmod +x cpubench
mv cpubench rootfs/sbin/
cp benchmark rootfs/etc/periodic/15min/

# setup zinit
wget https://github.com/threefoldtech/zinit/releases/download/v0.2.14/zinit
chmod +x zinit
mv zinit rootfs/sbin/zinit

mkdir rootfs/etc/zinit
cp etc/zinit/* rootfs/etc/zinit/

rm rootfs/etc/resolv.conf

tar czf benchmark.tar.gz -C rootfs .

rm -rf rootfs
