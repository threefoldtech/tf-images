### build image 

```
docker build -t threefolddev/taiga_io_all_in_one .
```
### Entrypoint 
```
/start_taiga.sh
```
### start docker container

```
docker run -d -t -p2202:22 -p802:80 -v /opt/circles/postgresdata:/var/lib/postgresql -v /opt/circles/sshkey:/root/.ssh -v /opt/circles/media:/home/taiga/taiga-back/media --name circles --hostname circles.com -e EMAIL_HOST=smtp.gmail.com -e EMAIL_HOST_PASSWORD=mypass -e EMAIL_HOST_USER=no-reply@threefold.tech -e TAIGA_HOSTNAME=circles.threefold.me -e HTTP_PORT=80 -e PRIVATE_KEY="your threeebot private key" -e FLASK_SECRET_KEY="flaskpass" -e THREEBOT_URL=https://login.threefold.me -e OPEN_KYC_URL=https://openkyc.liveverification/verify-sei -e SECRET_KEY="any-secret-key" -e RESTIC_REPOSITORY=s3:https://s3.grid.tf/circles-production -e RESTIC_PASSWORD="" -e AWS_ACCESS_KEY_ID="" -e AWS_SECRET_ACCESS_KEY="" threefolddev/taiga_io_all_in_one
	
	
```
### Threefold-Circles-Flist

	https://hub.grid.tf/bishoy.3bot/threefolddev-taiga_io_all_in_one-latest.flist

- note server only work with https due to threebot login require this 

- you should set all below env variables when create the container and use the domain naming instead ip address in TAIGA_HOSTNAME as below 

- env variables are : SECRET_KEY , EMAIL_HOST, EMAIL_HOST_USER, EMAIL_HOST_PASSWORD, TAIGA_HOSTNAME, HTTP_PORT, PRIVATE_KEY
                    FLASK_SECRET, THREEBOT_URL, OPEN_KYC_URL     

- also you need configure restic env variables : RESTIC_REPOSITORY AWS_ACCESS_KEY_ID AWS_SECRET_ACCESS_KEY RESTIC_PASSWORD"

- admin is create by default admin/123123 and to login admin account use https://circles.threefold.me/admin/ 


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
