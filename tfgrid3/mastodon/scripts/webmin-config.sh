#!/bin/bash

set -x

# disable the ssl
sed -i "0,/ssl=1/ s//ssl=0/" /etc/webmin/miniserv.conf

# set credi
user="${SUPERUSER_USERNAME:=user}"
pass="${SUPERUSER_PASSWORD:=pass}"

hashedpass=$(perl -e 'print crypt($ARGV[0], "password")' $password)
echo "$pass"
echo "$user:$pass:0" >> /etc/webmin/miniserv.users
sed "s/root: /$user:access privileges bandwidth /g" /etc/webmin/webmin.acl >> /etc/webmin/webmin.acl
/usr/share/webmin/changepass.pl /etc/webmin $user $pass