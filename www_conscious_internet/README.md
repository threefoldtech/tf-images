# Building 

in the consciousinternet directory

`docker build -t bishoyabdo/consciousinternet .`

change bishoyabdo to whatever image name.

# Running

```
docker run -it --name consciousinternet -e CONSCIOUS_INTERNET_BRANCH=staging -e SEND_GRID_KEY=secret  -e SUPPORT_EMAIL_FROM=urmail -e SUPPORT_EMAIL_TO=urmail -e WEBHOOK_SECRET=68dggg -p80:80 bishoyabdo/consciousinternet:latest bash
```

-  [start_conscious_internet.sh](start_conscious_internet.sh) script manage all services by supervisord

## optional env variables to be used with staging 
CONSCIOUS_INTERNET_BRANCH, branch of  https://github.com/threefoldfoundation/www_conscious_internet default is development

## flist 

- https://hub.grid.tf/mikhaieb/bishoyabdo-consciousinternet-latest.flist

