# Building 

in the gitea directory

`docker build -t bishoyabdo/gitea .`

change bishoyabdo to whatever image name.

# Running

```
docker run -it -p 222:22 -p 3000:3000 -e pub_key="ssh-rsa AAAA" -e POSTGRES_DB=gitea -e DB_TYPE=postgres -e DB_HOST=localhost:5432 -e POSTGRES_USER=postgres  -e POSTGRES_PASSWORD=pass -e APP_NAME=myrepos -e ROOT_URL=http://localhost:3000   -v /data:/data -v /data/postgres:/var/lib/postgresql/data bishoyabdo/gitea
```

## ssh 
 - to ssh echo your public key in /data/git/.ssh/authorized_keys

 - ssh container using user `git` not root as home dir is /data/git 
    ```
    ssh git@167.172.153.0 -p222
    ``` 
## missing

- itsyou.online (low prio)

## flist 

- https://hub.grid.tf/mikhaieb/bishoyabdo-gitea-latest.flist

## notes

- services are ssh and gitea are running by supervior and gitea working with `s6-supervise`
- services configuration exist in 
    ```
    # ls /etc/s6
    gitea    openssh
    
    ```
## initial setup 

 - you can login to initial setup page by using ROOT_RUL http://167.172.153.0:3000 
 - set `Database Type` PostgreSQL and set other configuration as env variables 
 - set admin account as below
 ![admin](admin.png)
  - 
  
  
  if you did not register admin account in init page, admin user will be the fist user registered   
 ## references 
 
 - gitea image is gitea/gitea:latest,  https://github.com/go-gitea/gitea
