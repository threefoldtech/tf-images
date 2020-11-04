#!/bin/bash
set -xe
# fix /etc/hosts
if ! grep -q "localhost" /etc/hosts; then
	touch /etc/hosts
	chmod  644 /etc/hosts
	echo $HOSTNAME  localhost >> /etc/hosts
	echo "127.0.0.1 localhost" >> /etc/hosts
fi

if [ "${USER}" != "git" ]; then
    # rename user
    sed -i -e "s/^git\:/${USER}\:/g" /etc/passwd
fi

if [ -z "${USER_GID}" ]; then
  USER_GID="`id -g ${USER}`"
fi

if [ -z "${USER_UID}" ]; then
  USER_UID="`id -u ${USER}`"
fi

## Change GID for USER?
if [ -n "${USER_GID}" ] && [ "${USER_GID}" != "`id -g ${USER}`" ]; then
    sed -i -e "s/^${USER}:\([^:]*\):[0-9]*/${USER}:\1:${USER_GID}/" /etc/group
    sed -i -e "s/^${USER}:\([^:]*\):\([0-9]*\):[0-9]*/${USER}:\1:\2:${USER_GID}/" /etc/passwd
fi

## Change UID for USER?
if [ -n "${USER_UID}" ] && [ "${USER_UID}" != "`id -u ${USER}`" ]; then
    sed -i -e "s/^${USER}:\([^:]*\):[0-9]*:\([0-9]*\)/${USER}:\1:${USER_UID}:\2/" /etc/passwd
fi

for FOLDER in /data/gitea/conf /data/gitea/log /data/git /data/ssh; do
    mkdir -p ${FOLDER}
done

# Substitude the environment variables in backup template, note am using § to  escape character  $
AWS_ACCESS_KEY_ID=${AWS_ACCESS_KEY_ID:-""} \
AWS_SECRET_ACCESS_KEY=${AWS_SECRET_ACCESS_KEY:-""} \
RESTIC_REPOSITORY=${RESTIC_REPOSITORY:-""}
RESTIC_PASSWORD=${RESTIC_PASSWORD:-""} \
envsubst < /etc/templates/backup-template | sed -e 's/§/$/g' >  /data/git/backup.sh

chmod +x /data/git/backup.sh

cat << EOF > /.mycron
00 05 * * * /data/git/backup.sh >> /data/git/backup.log 2>&1
EOF

/usr/sbin/crond -b -l 8
crontab /.mycron

# enable ssh login on gitea, i just set root pass but you still can not ssh with this password as per ssh config
#rootpass=`dd if=/dev/urandom bs=16 count=1 2>/dev/null | uuencode - | head -n 2 | grep -v begin | cut -b 2-40`
#echo -e "$rootpass\n$rootpass" | passwd  root

passwd -u root

# add ssh key to root

if [ -z ${pub_key+x} ]; then

        echo pub_key does not set in env variables
else
        [[ -d /root/.ssh/ ]] || mkdir -p /root/.ssh/
	touch /root/.ssh/authorized_keys
	if ! grep -q "$pub_key" /root/.ssh/authorized_keys ; then
        echo $pub_key >> /root/.ssh/authorized_keys
	fi

fi

chown -R git:git /data/gitea /data/git

if [ $# -gt 0 ]; then
    exec "$@"
else
    exec /bin/s6-svscan /etc/s6
fi
