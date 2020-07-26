#! /bin/bash
# not used now , TODO
set -ex 

if [ ! -f ${GITEA_CUSTOM}/conf/nginx-default.conf ] ;then
    mkdir -p ${GITEA_CUSTOM}/conf
		server_name ${DOMAIN:-"localhost"} \
		proxy_set_header X-Forwarded-For ${DOMAIN:-"localhost"} \
		proxy_set_header X-Forwarded-Host ${DOMAIN:-"localhost"} \
		ssl_certificate ${GITEA_CUSTOM}/conf/cert.pem \
                ssl_certificate_key ${GITEA_CUSTOM}/conf/key.pem \
    envsubst < /etc/templates/default.conf > ${GITEA_CUSTOM}/conf/nginx-default.conf
fi

