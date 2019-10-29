#!/usr/bin/env bash

chmod +x /opt/bin/*


echo "runing postgres"
/bin/bash /opt/bin/postgres_entry.sh postgres
su postgres -c 'pg_ctl start -D /var/lib/postgresql/data'

# su git -c "gitea create-user --username=$ADMIN_USER --password=$ِADMIN_PASSWORD --email=$ADMIN_EMAIL --admin"&

sleep 4
echo "running gitea entry"

/bin/bash /opt/bin/gitea_entry.sh&


exec "$@"