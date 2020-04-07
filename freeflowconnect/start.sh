#!/usr/bin/env bash
set -ex

export DEBIAN_FRONTEND=noninteractive

echo "checking env variables was set correctly "

for var in  SECRET_KEY EMAIL_HOST EMAIL_HOST_USER EMAIL_HOST_PASSWORD TAIGA_HOSTNAME HTTP_PORT PRIVATE_KEY  THREEBOT_URL OPEN_KYC_URL
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

locale-gen en_US.UTF-8
export LC_ALL=en_US.UTF-8

env | grep -v "PATH\=" | grep -v "HOME\=" | grep -v "PWD\=" | grep -v "SHLVL\=" >> /etc/environment

# setup script
echo starting Free Flow conenct setup script
bash /.setup.sh

crontab /.all_cron

# start supervisord
supervisord -c /etc/supervisor/supervisord.conf

exec "$@"
