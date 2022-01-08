#!/bin/bash
mkdir ~/.ssh
mkdir -p /var/run/sshd
chmod 600 ~/.ssh
chmod 600 /etc/ssh/*
touch ~/.ssh/authorized_keys
# fix /etc/hosts
if ! grep -q "localhost" /etc/hosts; then
	touch /etc/hosts
	chmod  644 /etc/hosts
	echo $HOSTNAME  localhost >> /etc/hosts
	echo "127.0.0.1 localhost" >> /etc/hosts
fi
#  check pub key
if [ -z ${pub_key+x} ]; then

        echo pub_key does not set in env variables
else

        [[ -d /root/.ssh ]] || mkdir -p /root/.ssh

				if ! grep -q "$pub_key" /root/.ssh/authorized_keys; then
					echo $pub_key >> /root/.ssh/authorized_keys
				fi
fi

mkdir blob block customize data datastore;

chown -R 4001:4001 /persistent-data;
rm -rf /cryptpad/datastore /cryptpad/archive /cryptpad/data /cryptpad/block /cryptpad/blob;
ln -sf /persistent-data/datastore/ /cryptpad/datastore;
ln -sf /persistent-data/archive/ /cryptpad/archive;
ln -sf /persistent-data/data/ /cryptpad/data;
ln -sf /persistent-data/block/ /cryptpad/block;
ln -sf /persistent-data/blob/ /cryptpad/blob;

chown -R 4001:4001 /cryptpad/datastore /cryptpad/archive /cryptpad/data /cryptpad/block /cryptpad/blob  /persistent-data/*;
cp /cryptpad/config/config.example.js /cryptpad/config/config.js
sed -i '/\/\/defaultStorageLimit: 50 \* 1024 \* 1024,/c\    defaultStorageLimit: process.env.size \* 1024 \* 1024,' /cryptpad/config/config.js

chmod 600 ~/.ssh/authorized_keys
service ssh start
bash /backup_init.sh

cd /cryptpad/ && node server
