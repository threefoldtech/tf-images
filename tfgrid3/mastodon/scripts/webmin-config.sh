#!/bin/bash

set -x

# disable the ssl
sed -i "0,/ssl=1/ s//ssl=0/" /etc/webmin/miniserv.conf

# set credi
user="${ADMIN_USERNAME:=user}"
pass="${ADMIN_PASSWORD:=pass}"

echo "$user:$pass:0" >> /etc/webmin/miniserv.users
echo "$user:access privileges" >> /etc/webmin/webmin.acl
/usr/share/webmin/changepass.pl /etc/webmin $user $pass