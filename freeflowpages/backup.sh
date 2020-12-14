export AWS_ACCESS_KEY_ID=our_aws_access_key
export AWS_SECRET_ACCESS_KEY=our_aws_secret_key
export RESTIC_REPOSITORY=our_restic_repository
export RESTIC_PASSWORD=our_restic_password

backup_time=`date +%Y-%m-%d_%H%M`
humhub_dir='/var/www/html/humhub'
cd $humhub_dir
mysqldump -u$DB_USER -p$DB_PASS humhub > dbbackup_$backup_time.sql && find  $humhub_dir -maxdepth 1 -type f -name 'dbbackup*.gz' -delete
gzip dbbackup_$backup_time.sql
unset HISTFILE
if ! restic snapshots ;then echo restic repo does not initalized yet; restic init ; fi > /dev/null
restic backup -q $humhub_dir
restic forget -q --prune --keep-within 2m

