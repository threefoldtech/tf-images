#!/bin/bash
export AWS_ACCESS_KEY_ID=our_aws_access_key
export AWS_SECRET_ACCESS_KEY=our_aws_secret_key
export RESTIC_REPOSITORY=our_restic_repository
export RESTIC_PASSWORD=our_restic_password

backup_time=`date +%Y-%m-%d_%H%M`
humhub_dir='/var/www/html/humhub'
cd $humhub_dir
mysqldump -u$root -p$ROOT_DB_PASS humhub > dbbackup_$backup_time.sql && find  $humhub_dir -maxdepth 1 -type f -name 'dbbackup*.gz' -delete
if [ $? -ne 0 ] ; then
    touch WARNING_DUMP_FAILED
    echo database backup fail at `date`
    exit 1
fi
gzip dbbackup_$backup_time.sql
unset HISTFILE
if ! /usr/local/bin/restic snapshots ;then echo /usr/local/bin/restic repo does not initalized yet; /usr/local/bin/restic init ; fi > /dev/null
/usr/local/bin/restic backup -q $humhub_dir
/usr/local/bin/restic forget -q --prune --keep-within 2m
