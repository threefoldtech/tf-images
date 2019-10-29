# Building 

in the wordpress directory

`docker build -t xmon/wordpress .`

change xmon to whatever image name.

# Running

```
docker run --rm -ti -e MYSQL_ROOT_PASSWORD=password -e MYSQL_DATABASE=wordpress -e MYSQL_USER=wpuser -e MYSQL_PASSWORD=password xmon/wordpress /bin/bash
```


```
docker run --rm -ti -e MYSQL_ROOT_PASSWORD=password -e MYSQL_DATABASE=wordpress -e MYSQL_USER=wpuser -e MYSQL_PASSWORD=passw
ord -e WORDPRESS_DB_HOST=localhost:3306 WORDPRESS_DB_USER=wpuser WORDPRESS_DB_PASSWORD=password WORDPRESS_DB_NAME=wordpress xmon/wordpress /bin/bash 
```

## missing

- ssh 
- itsyou.online (low prio)