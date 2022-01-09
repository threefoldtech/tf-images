### build image 

```
docker build -t bishoyabdo/circles:latest .
```
### start docker container

```
docker run -i -t  -p2204:22 -p804:80  -v ~/mytaiga/postgresdata:/var/lib/postgresql -v ~/mytaiga/sshkey:/root/.ssh \
-v ~/mytaiga/tiagahome:/home/taiga --name circles-test -e EMAIL_HOST=smtp.gmail.com -e EMAIL_HOST_PASSWORD=password\
-e EMAIL_HOST_USER=no-reply@threefold.tech -e TAIGA_HOSTNAME=test-circles.threefold.me -e HTTP_PORT=80\ 
-e PRIVATE_KEY="3bot private key" \ 
-e FLASK_SECRET_KEY="flash secert" \ 
-e THREEBOT_URL=https://login.staging.jimber.org \ 
-e OPEN_KYC_URL=https://openkyc.staging.jimber.org/verification/verify-sei \
-e SECRET_KEY=scret  -e SECRET_KEY=pass -e RESTIC_REPOSITORY=s3:https://s3.grid.tf/circles-test \
-e RESTIC_PASSWORD=password -e AWS_ACCESS_KEY_ID=key_id  -e AWS_SECRET_ACCESS_KEY=key bishoyabdo/circles:latest  bash

```
### Threefold-Circles-Flist

	https://hub.grid.tf/mikhaieb/bishoyabdo-circles-latest.flist

- note server only work with https due to threebot login require this 

- you should set all below env variables when create the container and use the domain naming instead ip address in TAIGA_HOSTNAME as below 

- env variables are : SECRET_KEY , EMAIL_HOST, EMAIL_HOST_USER, EMAIL_HOST_PASSWORD, TAIGA_HOSTNAME, HTTP_PORT, PRIVATE_KEY
                    FLASK_SECRET, THREEBOT_URL, OPEN_KYC_URL     

- also you need configure restic env variables : RESTIC_REPOSITORY AWS_ACCESS_KEY_ID AWS_SECRET_ACCESS_KEY RESTIC_PASSWORD"

- admin is create by default admin/123123 and to login admin account use https://staging.circles.threefold.me/admin/ 

- create your ur https redirection in caddy server 

```

https://test.circles.com {
        proxy / 10.102.251.225:80 {
                transparent
        }
}

http://test.circles.com {
    redir https://test.circles.com{uri}
}

```
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