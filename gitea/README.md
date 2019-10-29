# Building 

in the gitea directory

`docker build -t xmon/gitea .`

change xmon to whatever image name.

# Running

```
docker run -ti --rm -e POSTGRES_DB=gitea -e DB_TYPE=postgres -e DB_HOST=localhost:5432 -e DB_USER=postgres -e DB_PASSWORD=postgres -e APP_NAME=myrepos -e ADMIN_USER=xmon -e ADMIN_PASSWORD=xmon -e ADMIN_EMAIL=xmon@there.com -e ROOT_URL=172.17.0.2:3000 xmon/gitea /bin/bash
```

## missing

- ssh 
- itsyou.online (low prio)