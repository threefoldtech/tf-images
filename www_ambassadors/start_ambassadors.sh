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
[[ -z "${AMBASSADORS_BRANCH}" ]] &&  export AMBASSADORS_BRANCH=development

export DEST=/opt
if [ -d "$DEST/www_ambassadors" ] ; then
    echo " - www_ambassadors DIR ALREADY THERE, pulling it"
    cd $DEST/www_ambassadors
    git pull
else
    mkdir -p $DEST
    cd $DEST
    git clone "https://github.com/threefoldfoundation/www_ambassadors"  -b ${AMBASSADORS_BRANCH} www_ambassadors
fi

if [ -d "$DEST/www_ambassadors/public/threefold" ] ; then
    echo " - threefold DIR ALREADY THERE, pulling it"
    cd $DEST/www_ambassadors/public/threefold
    git pull
else
    mkdir -p $DEST/www_ambassadors/public/threefold
    cd  $DEST/www_ambassadors/public
    git clone "https://github.com/threefoldfoundation/data_threefold_projects_friends"  -b  master threefold
fi
cd $DEST/www_ambassadors/
bash build.sh

mkdir /var/log/{ambassadors,ssh}/ -p
supervisord -c /etc/supervisor/supervisord.conf
exec "$@"
