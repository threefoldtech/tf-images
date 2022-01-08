# faveo

is MySQL, nginx and php server to ticket system

# Building 

1 - clone repo 

```
git clone https://github.com/xmonader/tf-images.git

```

2 - in the faveo directory

` cd tf-images/faveo`

`docker build -t bishoyabdo/faveo .`

change bishoy to whatever image name.

# Running

```
docker run --rm -ti -p 80:80 bishoyabdo/faveo /bin/bash
```
Then login to your faveo and setup your configuration by http://localhost

## service run by supervisord
- nginx
- mysql
- php7.1-fpm
- ssh

## flist 

 https://hub.grid.tf/mikhaieb/bishoyabdo-faveo-latest.flist 
