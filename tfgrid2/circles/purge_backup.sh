# backup local and purge old ones
backup_time=`date +%Y-%m-%d_%H%M`
humhub_dir='/var/www/html/humhub'
cd $humhub_dir
mkdir -p /backup/humhub_$backup_time
cp -rp * /backup/humhub_$backup_time
cd /backup/
tar -czvf humhub_$backup_time.tar.gz humhub_$backup_time > /dev/null && rm -rf humhub_$backup_time
find  /backup -maxdepth 1 -type f -name 'humhub*.tar.gz' -mtime +31 -delete