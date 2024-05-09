# flist
	 https://hub.grid.tf/bishoy.3bot/threefolddev-forum_all_in_one-latest.flist

# Building

in the discourse directory

```
    docker build -t threefolddev/forum_all_in_one . 
    docker push threefolddev/forum_all_in_one
```
- then convert it form our hub to an flist https://hub.grid.tf

## References

https://github.com/discourse/discourse_docker/tree/master/image/base

### create docker container 
```
docker run -i -p80:80 -p443:443 -p2207:22 -p804:80 --name forum-test -e DISCOURSE_SMTP_PASSWORD="mypass" -e DISCOURSE_VERSION=staging -e RAILS_ENV=production -e DISCOURSE_HOSTNAME=64.227.1.81 -e DISCOURSE_SMTP_USER_NAME=apikey -e DISCOURSE_SMTP_ADDRESS=smtp.sendgrid.net -e DISCOURSE_DEVELOPER_EMAILS=bishoy@incubaid.com -e DISCOURSE_SMTP_PORT=587 -e THREEBOT_PRIVATE_KEY="mythreebotkey" -e FLASK_SECRET_KEY="flasksecret" -e THREEBOT_URL=https://login.threefold.me -e OPEN_KYC_URL=https://openkyc.live/verification/verify-sei -e RESTIC_REPOSITORY=s3:https://s3.grid.tf/forum-test  -e RESTIC_PASSWORD="yourpass" -e AWS_ACCESS_KEY_ID=id  -e AWS_SECRET_ACCESS_KEY=accesskey threefolddev/forum_all_in_one
```

### additional env variables have a defaults if not set as below
    
     RUBY_GC_HEAP_GROWTH_MAX_SLOTS=40000
     RUBY_GC_HEAP_INIT_SLOTS=400000
     RUBY_GC_HEAP_OLDOBJECT_LIMIT_FACTOR=1.5
     RUBY_GLOBAL_METHOD_CACHE_SIZE=131072
     PG_MAJOR=10
     UNICORN_SIDEKIQS=1
     DISCOURSE_DB_SOCKET=/var/run/postgresql
     home=/var/www/discourse
     upload_size=10m
     UNICORN_WORKERS=4
     DISCOURSE_SMTP_ENABLE_START_TLS=true
     
    
- logs are located in /var/log and app logs are in /var/www/discourse/log/
- after setup the discourse using admin account, ask another account to login with 3bot and grant him as an admin
- the local data in /var/lib/postgresql , redis in /shared/redis_data ,application /var/www/discourse/public which has upload and backup
- from admin discourse, you can set a periodic backup to be taken in path /var/www/discourse/public/backups/default

### configuration for https
    we are using self-sgined by nginx

### more info
- this flist same as discourse_3bot but with addataional package restic and its configuration.
- there is a crontab uplaod backup to s3 server (minio).
    
### Reference

https://github.com/discourse/discourse_docker
