# Building 

in the gitea directory

`docker build -t bishoyabdo/gitea .`

change bishoyabdo to whatever image name.

# Running

```
 docker run -ti --rm -p 222:22 -p 3000:3000 -e POSTGRES_DB=gitea -e DB_TYPE=postgres -e DB_HOST=localhost:5432 -e DB_USER=postgres -e DB_PASSWORD=postgres -e APP_NAME=myrepos -e ROOT_URL=http://167.172.153.0:3000 -v /data:/data -v /data/postgres:/var/lib/postgresql/data bishoyabdo/gitea /bin/bash
```

## ssh 
 - to ssh echo your public key in /data/git/.ssh/authorized_keys

 - ssh container using user git not root as home dir is /data/git 
    ```
    ssh root@167.172.153.0 -p222
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
## admin account 

 - is configured in initial setup when login to ROOT_RUL http://167.172.153.0:3000 as below 