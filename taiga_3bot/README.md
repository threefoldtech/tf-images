### build image 

```
docker build -t threefolddev/taiga_all_in_one .
```
### Entrypoint 
```
/.start_taiga.sh
```
### start docker container

```
docker run -i -p80:80 -p443:443 -p2204:22 --name circles-test -e EMAIL_HOST_USER=no-reply@threefold.tech  -e TAIGA_HOSTNAME=64.227.1.81  -e EMAIL_HOST=smtp.gmail.com -e EMAIL_HOST_USER='no-reply@threefold.tech' -e EMAIL_HOST_PASSWORD=mypass -e HTTP_PORT=80 -e PRIVATE_KEY='GlzXhA='  -e FLASK_SECRET_KEY='flask' -e THREEBOT_URL="https://login.threefold.me" -e OPEN_KYC_URL="https://openkyc.live/verification/verify-sei" -e SECRET_KEY=myscr  threefolddev/taiga_all_in_one  bash

```
### Threefold-Circles-Flist

	https://hub.grid.tf/bishoy.3bot/threefolddev-taiga_all_in_one-latest.flist

- note server only work with https due to threebot login require this 

- you should set all below env variables when create the container and use the domain naming instead ip address in TAIGA_HOSTNAME as below 

- env variables are : SECRET_KEY , EMAIL_HOST, EMAIL_HOST_USER, EMAIL_HOST_PASSWORD, TAIGA_HOSTNAME, HTTP_PORT, PRIVATE_KEY
                    FLASK_SECRET, THREEBOT_URL, OPEN_KYC_URL     

- also you need configure restic env variables : RESTIC_REPOSITORY AWS_ACCESS_KEY_ID AWS_SECRET_ACCESS_KEY RESTIC_PASSWORD"

- admin is create by default admin/123123 and to login admin account use https://64.227.1.81/admin/ 


- you should do all above steps to get a working circles server ,verfiy env varaibles by run command `env` in shell
- check local.py file settings if you got troubles  /home/taiga/taiga-back/settings/local.py
- you can check supervior service as below 
    ```
    # supervisorctl status all
    
    cron:cron_00                     RUNNING   pid 1560, uptime 0:18:23
    nginx                            RUNNING   pid 1550, uptime 0:18:23
    postgres                         RUNNING   pid 1549, uptime 0:18:23
    rabbitmq                         RUNNING   pid 1551, uptime 0:18:23
    ssh                              RUNNING   pid 1548, uptime 0:18:23
    taiga-back                       RUNNING   pid 1552, uptime 0:18:23
    taiga-events                     RUNNING   pid 1555, uptime 0:18:23
    
    ```
