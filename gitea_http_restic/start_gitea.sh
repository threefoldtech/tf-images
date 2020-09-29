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

cat > /home/git/backup.sh << EOF
export AWS_ACCESS_KEY_ID=$AWS_ACCESS_KEY_ID
export AWS_SECRET_ACCESS_KEY=$AWS_SECRET_ACCESS_KEY
export RESTIC_REPOSITORY=$RESTIC_REPOSITORY
export RESTIC_PASSWORD=$RESTIC_PASSWORD

cd /data/git
/app/gitea/gitea dump -c /data/gitea/conf/app.ini
if [ $? -ne 0 ] ; then
    touch WARNING_DUMP_FAILED
    exit 1
fi
unset HISTFILE
if ! restic snapshots ;then echo restic repo does not initalized yet; restic init ; fi > /dev/null
for i in `find . -type f -mtime -1 -name "gitea-dump*"` ; do restic backup --cleanup-cache $i ; done
if [ $? -eq 0 ] ; then
    find . -type f -mtime -1 -name "gitea-dump*" -mtime +7 -exec rm {} \;
else
    echo 'dump done locally only at /data/git/'
fi
EOF

chmod +x /data/git/backup.sh
cat << EOF > /.mycron
00 05 * * * /data/git/backup.sh >> /var/log/cron/backup.log 2>&1
EOF

/usr/sbin/crond -b -l 8
crontab /.mycron
