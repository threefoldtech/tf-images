#!/bin/bash

# clean
rm -rf /home/taiga/restic.*

echo "export AWS_ACCESS_KEY_ID=$AWS_ACCESS_KEY_ID" > /home/taiga/restic.env
echo "export AWS_SECRET_ACCESS_KEY=$AWS_SECRET_ACCESS_KEY" >> /home/taiga/restic.env
echo "export RESTIC_PASSWORD=$RESTIC_PASSWORD" >> /home/taiga/restic.env
echo "export RESTIC_REPOSITORY=$RESTIC_REPOSITORY" >> /home/taiga/restic.env

# Sanitation check for vars
for var in  AWS_ACCESS_KEY_ID AWS_SECRET_ACCESS_KEY RESTIC_PASSWORD RESTIC_REPOSITORY
  do
    if [ -z "${!var}" ]
      then
          exit 0
      fi
  done


echo "/home/taiga/taiga-back/media" > /home/taiga/restic.files
echo "/home/taiga/db_dump.sql" >> /home/taiga/restic.files

#if restic list snapshots; then
#  if [ -z `restic snapshots --json` ]; then
#    restic init; 
#  else 
#      restic restore --target /tmp/taiga_data latest
#      mv /tmp/taiga_data/media/* /home/taiga/taiga-back/media/
#      chown taiga:taiga /home/taiga/taiga-back/media -R
#      chown taiga:taiga /tmp/taiga_data -R
#      su taiga -c "psql < /tmp/taiga_data/db_dump.sql"
#    fi
#else
#    restic init;
#fi

if [ -z "$CRON_FREQUENCY" ]
then
    CRON_FREQUENCY="0 0 * * *"
fi

mkdir -p /etc/cron.d
line="pg_dump taiga -f /home/taiga/db_dump.sql;source /home/taiga/restic.env; export TAG=\$(date +%Y%m%d-%H%M%S);  /usr/bin/restic backup --files-from=/home/taiga/restic.files --tag \$TAG 2> /home/taiga/restic.err > /home/taiga/restic.log"
echo $line > /home/taiga/backup.sh
echo "$CRON_FREQUENCY bash /home/taiga/backup.sh" > /etc/cron.d/backup

chown taiga:taiga /home/taiga/restic.env /home/taiga/restic.files /etc/cron.d/backup

crontab -u taiga /etc/cron.d/backup
service cron restart
