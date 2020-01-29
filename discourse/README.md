# Building

in the discourse directory

```
    docker build -t bishoyabdo/forum:latest . 
    docker push bishoyabdo/forum:latest
```
- then convert it form our hub to an flist https://hub.grid.tf
- note we use a prepared image in Dockerfile called bishoyabdo/tf-discourse
- tf-discourse image has some prepared configuration and scripts, this image created by below reference 
- tf-discourse image prepared configuration and scripts are taken from following templates 
   https://github.com/discourse/discourse_docker/tree/master/templates
## References

https://github.com/discourse/discourse_docker/tree/master/image/base

### ZOS container parameters
```
./container.py create -n 10.102.251.225 -iyocl  uritsyouonlineappid --clientsecret urityouonlinescret -\ 
f https://hub.grid.tf/mikhaieb/bishoyabdo-forum-latest.flist  -p '2222:22' -p'443:443' -p '80:80' \ 
-envs DISCOURSE_SMTP_PASSWORD=ursmtppassword --name forum-test -sp 1dacade3-cfea-4cf5-bb22-3bb2f032a23b \ 
-v postgresdata:/var/lib/postgresql  -v varlog:/var/log -v www_discourse:/var/www/discourse -v shared_ssl:/shared/ssl \ 
-envs DISCOURSE_VERSION=staging -envs RAILS_ENV=production -envs HOSTNAME=forum11.threefold.io -envs DISCOURSE_HOSTNAME=forum11.threefold.io \ 
-envs DISCOURSE_SMTP_USER_NAME=apikey -envs DISCOURSE_SMTP_ADDRESS=smtp.sendgrid.net -envs DISCOURSE_DEVELOPER_EMAILS=bishoy@incubaid.com -envs DISCOURSE_SMTP_PORT=587 \ 
-envs LETSENCRYPT_ACCOUNT_EMAIL=bishoy@incubaid.com -envs AWS_ACCESS_KEY_ID=urawskey -envs AWS_SECRET_ACCESS_KEY=urawssecret \ 
-envs RESTIC_REPOSITORY="s3:https://s3.grid.tf/forums-test"  -envs RESTIC_PASSWORD="urresticpassword"
```
- before create container, you put your DISCOURSE_HOSTNAME in dns as a A record so can generate certifcate easily
- make sure the HOSTNAME is same as DISCOURSE_HOSTNAME 
- make sure pass the mounted directories correctly 
- logs are located in /var/log and app logs are in /var/www/discourse/log/
- after setup the discourse using admin account, ask another account to login with 3bot and grant him as an admin
- DATA is presistent for database the local data in /var/lib/postgresql , redis in /shared/redis_data ,application /var/www/discourse/public which has upload and backup
- from admin discourse, you can set a periodic backup to be taken in path /var/www/discourse/public/backups/default
- There is a backup script located /.backup.sh will backup to our s3 each 2 hours from above location of discourse backup
