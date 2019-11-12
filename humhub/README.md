# Humhub

is MySQL, apache2 and php server to build your social network 

# Building 

1 - clone repo 

```
git clone https://github.com/xmonader/tf-images.git

```

2 - in the humhub directory

` cd tf-images/humhub`

`docker build -t bishoy/humhub .`

change bishoy to whatever image name.

# Running

```
docker run --rm -ti -p 80:80 -e MYSQL_ROOT_PASSWORD=rootpass -e MYSQL_DATABASE=humhub -e MYSQL_USER=humhub -e MYSQL_PASSWORD=humpass  bishoy/humhub /bin/bash
```
Then login to your humhub and setup your configuration by http://localhost

## advanced options

if you want to modify humhub version while starting docker container and to bind mount a volume of the database and app dir to docker host

```
docker run --rm -ti -p 80:80 -e MYSQL_ROOT_PASSWORD=rootpass -e MYSQL_DATABASE=humhub -e MYSQL_USER=humhub -e MYSQL_PASSWORD=humpass  -e HUMHUB_VERSION=1.3.15 -v /opt/humhub:/var/www/html/humhu -v /opt/mysql:/var/lib/mysql bishoy/humhub /bin/bash

```
## service run by supervisord
- apache2
- mysql
- ssh

## flist 

https://hub.grid.tf/mikhaieb/bishoyabdo-humhub-1.3.15.flist
 
