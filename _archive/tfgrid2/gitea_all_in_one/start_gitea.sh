#!/bin/bash
set -xe

# TODO check $DOMAIN variables

[[ -d /data/gitea/conf ]] || mkdir -p /data/gitea/conf
cd /data/gitea/conf && /app/gitea/gitea cert --host $DOMAIN

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

if [ -z ${pub_key+x} ]; then

        echo pub_key does not set in env variables
else
        [[ -d /data/git/.ssh/ ]] || mkdir -p /data/git/.ssh/
	touch /data/git/.ssh/authorized_keys
	if ! grep -q "$pub_key" /data/git/.ssh/authorized_keys ; then
        echo $pub_key >> /data/git/.ssh/authorized_keys
        chown git:git /data/git/.ssh/authorized_keys
	fi

fi

#sed -i "s/DOMAIN/$DOMAIN/g" /etc/nginx/conf.d/nginx-default.conf

chown -R git:git /data/gitea

if [ $# -gt 0 ]; then
    exec "$@"
else
    exec /bin/s6-svscan /etc/s6
fi
