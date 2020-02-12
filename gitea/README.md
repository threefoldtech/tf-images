# Building 

in the gitea directory

`docker build -t xmon/gitea .`

change xmon to whatever image name.

# Running

```
 docker run -ti --rm -p 3000:3000 -e POSTGRES_DB=gitea -e DB_TYPE=postgres -e DB_HOST=localhost:5432 -e DB_USER=postgres -e DB_PASSWORD=postgres -e APP_NAME=myrepos -e ROOT_URL=http://167.172.153.0:3000 -v /data:/data -v /data/postgres:/var/lib/postgresql/data bishoyabdo/gitea /bin/bash
```

## missing

- ssh 
- itsyou.online (low prio)
