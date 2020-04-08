#!/usr/bin/env bash
set -ex

export DEBIAN_FRONTEND=noninteractive

echo "checking env variables was set correctly "

for var in  THREE_BOT_CONNECT_URL
    do
        if [ -z "${!var}" ]
        then
                 echo "$var not set, Please set it in creating your container"
                 exit 1
        fi
    done


# prepare ssh
chmod 400 -R /etc/ssh/
mkdir -p /run/sshd
[ -d /root/.ssh/ ] || mkdir /root/.ssh

echo 'remove a record was added by zos that make our server slow, below is resolv.conf file contents'

if grep "10." /etc/resolv.conf ; then
  sed -i '/^nameserver 10./d' /etc/resolv.conf
fi

#locale-gen en_US.UTF-8
export LC_ALL=en_US.UTF-8

env | grep -v "PATH\=" | grep -v "HOME\=" | grep -v "PWD\=" | grep -v "SHLVL\=" >> /etc/environment

mkdir -p /var/log/{ssh,janus,ff_connect,cron,redis}

# setup script
echo starting Free Flow conenct setup script
bash /.setup.sh
# start supervisord
# need to check how to start frontend
supervisord -c /etc/supervisor/supervisord.conf
crontab /.all_cron

# add enty for redis host
echo "127.0.0.1      redis" >> /etc/hosts

exec "$@"
