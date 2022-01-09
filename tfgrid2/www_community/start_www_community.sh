#!/bin/bash
set -ex
# add agnet
[[ -d /ssh ]] || mkdir /ssh
[ -f /ssh/id_rsa ] || echo ssh key file does not mounted, please use -v /ssh:/ssh and put private key there
chmod 600 /ssh/id_rsa
eval `ssh-agent -s` && ssh-add /ssh/id_rsa
ssh-add -l
[[ -d /root/.ssh ]] || mkdir  /root/.ssh
if ! grep github.com ~/.ssh/known_hosts >/dev/null 2>&1 ; then 
ssh-keyscan github.com >> /root/.ssh/known_hosts
fi
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

echo "checking env variables was set correctly "
for var in SEND_GRID_KEY SUPPORT_EMAIL_FROM SUPPORT_EMAIL_TO WEBHOOK_SECRET
    do
        if [ -z "${!var}" ]
        then
                 echo "$var not set, Please set it in creating your container"
                 #exit 1
        fi
    done

# prepare ssh
[ -d /etc/ssh/ ] && chmod 400 -R /etc/ssh/
mkdir -p /run/sshd
[ -d /root/.ssh/ ] || mkdir /root/.ssh
[[ -z "${COMMUNITY_BRANCH}" ]] &&  export COMMUNITY_BRANCH=development

export DEST=/opt
if [ -d "$DEST/www_community" ] ; then
    echo " - www_community DIR ALREADY THERE, pulling it"
    cd $DEST/www_community
    git pull
else
    mkdir -p $DEST
    cd $DEST
    git clone "https://github.com/threefoldfoundation/www_community"  -b ${COMMUNITY_BRANCH} www_community
fi

if [ -d "$DEST/www_community/public/threefold" ] ; then
    echo " - threefold DIR ALREADY THERE, pulling it"
    cd $DEST/www_community/public/threefold
    git pull
else
    mkdir -p $DEST/www_community/public/threefold
    cd  $DEST/www_community/public
    git clone "git@github.com:threefoldfoundation/data_threefold_projects_friends.git"  -b  master threefold
fi
cd $DEST/www_community/
bash build.sh

mkdir /var/log/{www_community,ssh}/ -p
supervisord -n -c /etc/supervisor/supervisord.conf

