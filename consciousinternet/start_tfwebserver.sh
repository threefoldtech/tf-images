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

[[ -z "${TFWEBSERVER_PROJECTS_PEOPLE_BRANCH}" ]] &&  export TFWEBSERVER_PROJECTS_PEOPLE_BRANCH=development
[[ -z "${PUBLIC_REPO_BRANCH}" ]] &&  export PUBLIC_REPO_BRANCH=master

git clone https://github.com/threefoldfoundation/tfwebserver_projects_people -b ${TFWEBSERVER_PROJECTS_PEOPLE_BRANCH} /opt/tfwebserver_projects_people
cd /opt/tfwebserver_projects_people/public/
git clone https://github.com/threefoldfoundation/www_threefold_ecosystem/ -b ${PUBLIC_REPO_BRANCH} threefold
cd /opt/tfwebserver_projects_people/ && ./build.sh

mkdir /var/log/{tfwebserver,ssh}/ -p
supervisord -c /etc/supervisor/supervisord.conf
exec "$@"
