#!/bin/bash

# clean
rm -rf /data/git/restic.*

echo "export AWS_ACCESS_KEY_ID=$AWS_ACCESS_KEY_ID" > /data/git/restic.env
echo "export AWS_SECRET_ACCESS_KEY=$AWS_SECRET_ACCESS_KEY" >> /data/git/restic.env
echo "export RESTIC_PASSWORD=$RESTIC_PASSWORD" >> /data/git/restic.env
echo "export RESTIC_REPOSITORY=$RESTIC_REPOSITORY" >> /data/git/restic.env

# Sanitation check for vars
for var in  AWS_ACCESS_KEY_ID AWS_SECRET_ACCESS_KEY RESTIC_PASSWORD RESTIC_REPOSITORY
  do
    if [ -z "${!var}" ]
      then
          exit 0
      fi
  done


echo "/data/git/gitea_dump.zip" >> /data/git/restic.files

mkdir -p /data/git /data/gitea
if restic list snapshots; then
  if [ -z `restic snapshots --json` ]; then
    restic init; 
  else 
      restic restore --target /tmp latest
      cd /tmp/data/git
      unzip gitea_dump.zip
      mv app.ini /data/gitea/conf/app.ini
      mv repos/* /data/gitea/repositories/
      chown -R gitea:gitea /data/gitea/conf/app.ini /data/gitea/repositories/
      echo "cd /tmp/data/git;export PGPASSWORD=$POSTGRES_PASSWORD" > restore_dump.sh
      echo "while ! nc -z localhost 5432; do" >> restore_dump.sh
      echo "echo \"waiting for postgres\" >> /tmp/data/git/wait.log" >> restore_dump.sh
      echo  "sleep 0.1" >> restore_dump.sh
      echo "done" >> restore_dump.sh
      echo "psql -U $POSTGRES_USER -d $POSTGRES_DB --no-password < gitea-db.sql" >> restore_dump.sh
      chmod +x restore_dump.sh
      bash restore_dump.sh &
    fi
else
    restic init;
fi

if [ -z "$CRON_FREQUENCY" ]
then
    CRON_FREQUENCY="0 0 * * *"
fi
chown -R git:git /data/git /data/gitea

mkdir -p /etc/cron.d
line="gitea dump -c /data/gitea/conf/app.ini -f /data/git/gitea_dump.zip; source /data/git/restic.env ; export TAG=\$(date +%Y%m%d-%H%M%S);  restic backup --files-from=/data/git/restic.files --tag \$TAG 2> /data/git/restic.err > /data/git/restic.log"
echo $line > /data/git/backup.sh
echo "$CRON_FREQUENCY bash /data/git/backup.sh" > /etc/cron.d/backup

chown git:git /data/git/restic.env /data/git/restic.files /etc/cron.d/backup

/usr/sbin/crond -b -l 8
crontab -u git /etc/cron.d/backup

