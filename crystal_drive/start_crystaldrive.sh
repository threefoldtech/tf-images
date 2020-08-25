#!/bin/bash
set -ex
# prepare ssh
[ -d /etc/ssh/ ] && chmod 400 -R /etc/ssh/
mkdir -p /run/sshd
[ -d /root/.ssh/ ] || mkdir /root/.ssh
mkdir -p /var/log/{zdb,bcdb,crystaldrive,ssh}

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

				if ! grep -q "$pub_key" /root/.ssh/authorized_keys; then
					echo $pub_key >> /root/.ssh/authorized_keys
				fi
fi

cd /root/bcdb
tfuser id create --name $TF_EXP_USER --email $EMAIL  --description "$DESCRIPTION" > /root/start.log || true
[[ -f `pwd`/user.seed ]] && echo user.seed file created successfully  || echo user.seed file does not created! >> /root/start.log

if [ -d /root/crystaldrive  ] ; then
	    echo " - threefold DIR ALREADY THERE, pulling it"
	    cd /root/crystaldrive
	    git pull || true
	else
		git clone https://github.com/crystaluniverse/crystaldrive ~/crystaldrive 
fi
cd /root/crystaldrive ;
sed -i "s|git@github.com:crystaluniverse|https://github.com/crystaluniverse|g" build.sh ;\

if ! grep -q "github.com" $HOME/.ssh/known_hosts; then
ssh-keyscan github.com >> $HOME/.ssh/known_hosts
fi

# move old to tmp dir
[[ -f /tmp/crystaldrive ]] && rm /tmp/crystaldrive
[[ -f /usr/local/bin/crystaldrive ]] && mv /usr/local/bin/crystaldrive /tmp/crystaldrive
shards update
./build.sh -a && mv crystaldrive /usr/local/bin/

mkdir -p $ONLY_OFFICE_DATA_PATH

supervisord -n -c /etc/supervisor/supervisord.conf
