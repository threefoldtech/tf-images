#!/bin/sh
set -e

if test -f "/env.sh"; then
    source /env.sh
fi
if test -f "env.sh"; then
    source env.sh
fi


mkdir -p /myhost/zos/initramfs
rm -rf /myhost/zos/initramfs/*

cp /code/staging/vmlinuz.efi /myhost/zos/initramfs/

echo " ** COPY DONE"



