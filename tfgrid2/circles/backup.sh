#! /bin/bash
#set -x
bkp_directory='/home/taiga/taiga-backup'
media_directory='/home/taiga/taiga-back/media'
[ -d $bkp_directory ] || ( mkdir $bkp_directory && chown -R taiga:taiga $bkp_directory )
[ -d $media_directory ] || ( mkdir $media_directory && chown -R taiga:taiga $media_directory )

date=`date +%d%m%y%H%M`

#Database backup
su - taiga -c "pg_dump -U taiga -c taiga > $bkp_directory/db-bkp-$date-dump.sql"

#File system backup
zip -r $bkp_directory/app-bkp-$date.zip $media_directory >> /dev/null 3>&1

unset HISTFILE
if ! restic snapshots ;then echo restic repo does not initalized yet; restic init ; fi > /dev/null
restic backup --cleanup-cache /home/taiga/taiga-backup
restic forget -q --prune --keep-within 1m

#Delete files older than 3 days
find $bkp_directory/ -mtime +3 -delete