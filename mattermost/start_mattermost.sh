# enable ssh
chmod 600 /etc/ssh/*_key
echo $pub_key > ~/.ssh/authorized_keys
service ssh start

rm -rf /var/lib/mysql
chmod 777 /var/run/mysqld

echo "Starting MySQL"
/entrypoint.sh mysqld &

until mysqladmin -hlocalhost -P3306 -u"$MYSQL_USER" -p"$MYSQL_PASSWORD" processlist &> /dev/null; do
	echo "MySQL still not ready, sleeping"
	sleep 5
done

echo "Updating CA certificates"
update-ca-certificates --fresh >/dev/null

echo "Starting platform"
cd mattermost
chmod 777 /etc/hosts
echo "127.0.0.1 localhost" > /etc/hosts
exec ./bin/mattermost --config=config/config_docker.json
