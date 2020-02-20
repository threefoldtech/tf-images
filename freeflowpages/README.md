- to create containers and env got to below repo

https://docs.grid.tf/threefold/itenv_threefold_main/src/branch/master/freeflowpages/

## env variables 

```
'AWS_ACCESS_KEY_ID': 'aws-key-id',
 'AWS_SECRET_ACCESS_KEY': 'key',
 'CLIENT_ID': 'freeflowpages',
 'CLIENT_SECRET': 'iyo client id',
 'DB_PASS': 'humhub_db_user_to_connect_app_pass',
 'DB_USER': 'humhub_db_user_to_connect_app_username',
 'HUMHUB_INSTALLATION_VERSION': '1.3.15',
 'RESTIC_PASSWORD': 'restic pass',
 'RESTIC_REPOSITORY': 's3:https://s3.grid.tf/freeflowpages-stag-backup',
 'ROOT_DB_PASS': 'root db user password',
 'SMTP_HOST': 'smtp.sendgrid.net',
 'SMTP_PASS': 'smtp pass',
 'SMTP_PORT': '587',
 'SMTP_USER': 'apikey',
 'THREEBOT_KEY_PAIR': '3bot key par',
 'FFP_HOSTNAME':'staging.freeflowpages.com', # this will use in protected/modules/threebot_login/authclient/ThreebotAuth.php
 'threebot_stag': 'True'} # True in case use install freeflowpages as staging

```
## persistent data with below dirs

```
['/root/.ssh/', '/backup', '/var/www/html/humhub', '/var/mysql/binlog', '/var/lib/mysql/']

```
## Fresh install 
1- you need to access server and setup your settings from http://ip:port to set admin user, make admin email as your 3bot app email

2 - reboot container, will install remain modules like rest, Freeflow, threebot_login and reeflow_extras

3 - after reboot module should be install and enabled, only Restful module need to enabled manually as below
    [enable](rest.png)

4 - flist has a crontabs to backup locally and to restic   

