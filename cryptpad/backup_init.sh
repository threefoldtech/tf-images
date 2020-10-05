#!/bin/bash

# clean
rm -rf /restic.*

echo "export AWS_ACCESS_KEY_ID=$AWS_ACCESS_KEY_ID" > restic.env
echo "export AWS_SECRET_ACCESS_KEY=$AWS_SECRET_ACCESS_KEY" >> restic.env
echo "export RESTIC_PASSWORD=$RESTIC_PASSWORD" >> restic.env
echo "export RESTIC_REPOSITORY=$RESTIC_REPOSITORY" >> restic.env

# Sanitation check for vars
for var in  AWS_ACCESS_KEY_ID AWS_SECRET_ACCESS_KEY RESTIC_PASSWORD RESTIC_REPOSITORY BACKUP_PATHS
  do
    if [ -z "${!var}" ]
      then
          exit 1
      fi
  done

chmod +x restic.env
paths=$(echo $BACKUP_PATHS | tr ";" "\n")
for i in $paths
do
	echo $i >> restic.files
done

if restic list snapshots; then
  if [ -z `restic snapshots --json` ]; then
    restic init; 
  else 
      for path in paths
      do
        restic restore --target $path latest;
      done 
    fi
else
    restic init;
fi

if [ -z "$CRON_FREQUENCY" ]
then
    CRON_FREQUENCY="0 0 * * *"
fi

line="source /restic.env ; export TAG=\$(date +%Y%m%d-%H%M%S);  restic backup --files-from=/restic.files --tag \$TAG 2> /restic.err > /restic.log"
echo $line > /root/backup.sh
echo "$CRON_FREQUENCY root bash /root/backup.sh" > /etc/cron.d/backup
service cron start

