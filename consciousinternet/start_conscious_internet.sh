#!/bin/bash
set -ex
echo "checking env variables was set correctly "
for var in SEND_GRID_KEY SUPPORT_EMAIL_FROM SUPPORT_EMAIL_TO WEBHOOK_SECRET 
    do
        if [ -z "${!var}" ]
        then
                 echo "$var not set, Please set it in creating your container"
                 exit 1
        fi
    done

# prepare ssh
[ -d /etc/ssh/ ] && chmod 400 -R /etc/ssh/
mkdir -p /run/sshd
[ -d /root/.ssh/ ] || mkdir /root/.ssh

export DEST=/opt

if [ -d "$DEST/www_conscious_internet" ] ; then
    echo " - www_conscious_internet DIR ALREADY THERE, pulling it"
    cd $DEST/www_conscious_internet
    git pull
else
    mkdir -p $DEST
    cd $DEST
    git clone "https://github.com/threefoldfoundation/www_conscious_internet"  -b ${CONSCIOUS_INTERNET_BRANCH} www_conscious_internet
fi

if [ -d "$DEST/www_conscious_internet/public/threefold" ] ; then
    echo " - threefold DIR ALREADY THERE, pulling it"
    cd $DEST/www_conscious_internet/public/threefold
    git pull
else
    mkdir -p $DEST/www_conscious_internet/public/threefold
    cd  $DEST/www_conscious_internet/public
    git clone "https://github.com/threefoldfoundation/data_threefold_projects_friends"  -b  master threefold
fi

mkdir /var/log/{conscious_internet,ssh}/ -p
supervisord -c /etc/supervisor/supervisord.conf
exec "$@"