# Building

in the discourse directory

```
    docker build -t bishoyabdo/forum:latest . 
    docker push bishoyabdo/forum:latest
```
- then convert it form our hub to an flist https://hub.grid.tf

## Running


## References

https://github.com/discourse/discourse_docker/tree/master/image/base

### ZOS container parameters
```
./container.py create -n 10.102.251.225 -iyocl  uritsyouonlineappid --clientsecret urityouonlinescret -\ 
f https://hub.grid.tf/mikhaieb/bishoyabdo-forum-latest.flist  -p '2222:22' -p'443:443' -p '80:80' \ 
-envs DISCOURSE_SMTP_PASSWORD=ursmtppassword --name forum-test -sp 1dacade3-cfea-4cf5-bb22-3bb2f032a23b \ 
-v postgresdata:/var/lib/postgresql  -v varlog:/var/log -v www_discourse:/var/www/discourse -v shared_ssl:/shared/ssl \ 
-envs DISCOURSE_VERSION=staging -envs RAILS_ENV=production -envs HOSTNAME=mydiscourse -envs DISCOURSE_HOSTNAME=forum11.threefold.io \ 
-envs DISCOURSE_SMTP_ADDRESS=smtp.sendgrid.net -envs DISCOURSE_DEVELOPER_EMAILS=bishoy@incubaid.com -envs DISCOURSE_SMTP_PORT=587 \ 
-envs LETSENCRYPT_ACCOUNT_EMAIL=bishoy@incubaid.com -envs AWS_ACCESS_KEY_ID=urawskey -envs AWS_SECRET_ACCESS_KEY=urawssecret \ 
-envs RESTIC_REPOSITORY="s3:https://s3.grid.tf/forums-test"  -envs RESTIC_PASSWORD="urresticpassword"
```
