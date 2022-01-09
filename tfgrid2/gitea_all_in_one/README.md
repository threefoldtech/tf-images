# Building 

in the gitea directory

`docker build -t threefolddev/gitea_all_in_one .`


# Running

```
docker run -it --name gitea -p 222:22 -p80:80 -p443:443 -p3000:3000 -e pub_key="ssh-rsa AAAAB3" -e POSTGRES_USER=root  -e POSTGRES_PASSWORD=pass  -e POSTGRES_DB=gitea -e DB_TYPE=postgres -e DB_HOST=localhost:5432  -e APP_NAME=myrepos -e HTTP_PORT=3000 -e DOMAIN=167.172.153.0 -e ROOT_URL=https://167.172.153.0:3000  -v /data:/data -v /data/postgres:/var/lib/postgresql/data  threefolddev/gitea_all_in_one

```

## ssh 
 - to ssh echo your public key in /data/git/.ssh/authorized_keys

 - ssh container using user `git` not root as home dir is /data/git 
    ```
    ssh git@167.172.153.0 -p222
    ``` 
## new

- 3bot login is enabled
## flist 

- https://hub.grid.tf/bishoy.3bot/threefolddev-gitea_all_in_one-latest.flist

## notes

- services are ssh and gitea are running by supervior and gitea working with `s6-supervise`
- services configuration exist in 
    ```
    # ls /etc/s6
    gitea    openssh
    
    ```
## initial setup 

 - you can login to initial setup page by using ROOT_RUL https://167.172.153.0:3000
 - set `Database Type` PostgreSQL and set other configuration as env variables 
 - set admin account as below
 ![admin](admin.png)
  - 
  
  
  if you did not register admin account in init page, admin user will be the fist user registered   
 ## references 
 
 - gitea_all_in_one image depend on threefolddev/gitea_3bot,  to build follow below :
 
 ```
git clone https://github.com/threefoldtech/tf-gitea
cd tf-gitea
docker build -t  threefolddev/gitea_3bot .

```
