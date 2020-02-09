echo starting backup at `date`
unset HISTFILE
if ! restic snapshots ;then echo restic repo does not initalized yet; restic init ; fi > /dev/null
cd $app_directory
for i in `find $app_directory -type f -mtime -1` ; do restic backup --cleanup-cache $i ; done
#Delete files older than 7 days
find $app_directory/ -mtime +7 -exec rm {} \;
