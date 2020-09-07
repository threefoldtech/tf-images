#!/bin/bash

ssh-keygen -A
# fix /etc/hosts
if ! grep -q "localhost" /etc/hosts; then
	touch /etc/hosts
	chmod  644 /etc/hosts
	echo $HOSTNAME  localhost >> /etc/hosts
	echo "127.0.0.1 localhost" >> /etc/hosts
fi
#  check pub key
if [ -z ${SSHKEY+x} ]; then

        echo SSHKEY does not set in env variables
else

        [[ -d /root/.ssh ]] || mkdir -p /root/.ssh

				if ! grep -q "$SSHKEY" /root/.ssh/authorized_keys; then
					echo $SSHKEY >> /root/.ssh/authorized_keys
				fi
fi

echo "PermitRootLogin yes" >> /etc/ssh/sshd_config
echo "StrictHostKeyChecking no" >> /etc/ssh/ssh_config
chmod -R 500 /etc/ssh
service ssh restart
cat > /config.toml << EOF
[server]
addr = "0.0.0.0" 
port = 3000

[[$TYPE]]
name = "$NAME"
title = "$TITLE"
url = "$URL"
branch = "$BRANCH"
EOF

if [ "$TYPE" == "blog" ]; then
# blog
cat > /Caddyfile << EOF
$DOMAIN {

        redir {
            if {scheme} is https
            if {path} is /
            / /blog/$NAME 307
        }

       redir {
           if {scheme} is http
           if {path} is /
           / https://{host}blog/$NAME/
        }

       redir {
           if {scheme} is http
           / https://{host}{uri}
        }

        tls $EMAIL
        proxy /api localhost:3000/
        proxy / localhost:3000
}
EOF
else
# other
cat > /Caddyfile << EOF
$DOMAIN {
       redir {
           if {scheme} is http
           / https://{host}{uri}
        }
        tls $EMAIL
        proxy / localhost:3000/$NAME
}
EOF
fi
cd /sandbox/code/github/crystaluniverse/publishingtools
./bin/tfweb -c /config.toml &> tfweb.log &
/trc -local localhost:80 -local-tls localhost:443 -remote $TRC_REMOTE &> trc.log &
for i in {1..6}; do
if [ "$TEST_CERT" = 'true' ] ; then
    yes | /caddy -ca https://acme-staging-v02.api.letsencrypt.org/directory -conf /Caddyfile
else
    yes | /caddy -conf /Caddyfile
fi
sleep 10
done
