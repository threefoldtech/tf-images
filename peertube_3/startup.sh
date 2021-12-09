service ssh start
service postgresql start
redis-server --daemonize yes
echo $PUB_KEY
if ! grep -q "$PUB_KEY" /root/.ssh/authorized_keys; then
	echo $PUB_KEY >> /root/.ssh/authorized_keys
fi
npm start
