#!/bin/sh
set -xe

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
        echo $pub_key >> /data/git/.ssh/authorized_keys
        chown git:git /data/git/.ssh/authorized_keys

fi

# disable self-signed as it handled by nginx
#cd /app/gitea && /app/gitea/gitea cert --host $DOMAIN && chown -R git:git /app/gitea                                                                                                                                  
if [ ! -f /etc/nginx/conf.d/nginx-default.conf ]; then
	[ -d /etc/nginx/conf.d/ ] || mkdir  /etc/nginx/conf.d
cat <<EOF > /etc/nginx/conf.d/nginx-default.conf
	server {
	    listen 80;
	    server_name $DOMAIN;
	    return 301 https://$DOMAIN\$request_uri;
	}

	# https
	# redirect to 3000 port with https!
	server {
        	listen 443 ssl http2 default_server;
        	listen [::]:443 ssl http2 default_server;
        	ssl_certificate /etc/nginx/conf.d/cert.pem;
        	ssl_certificate_key /etc/nginx/conf.d/key.pem;
		location / {
			proxy_pass http://127.0.0.1:3000;
			proxy_set_header X-Forwarded-For $DOMAIN; 
			proxy_set_header X-Forwarded-Host $DOMAIN;
		}
	}
EOF

fi
chown -R git:git /data/gitea

if [ $# -gt 0 ]; then
    exec "$@"
else
    exec /bin/s6-svscan /etc/s6
fi
