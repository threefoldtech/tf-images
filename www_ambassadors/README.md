# Building 

in the www_ambassadors directory

`docker build -t bishoyabdo/www_ambassadors .`

change bishoyabdo to whatever image name.

# Running

```
docker run -it --name www_ambassadors  -e SEND_GRID_KEY=secret  -e SUPPORT_EMAIL_FROM=urmail -e SUPPORT_EMAIL_TO=urmail -e WEBHOOK_SECRET=68dggg -p80:80 bishoyabdo/consciousinternet:latest bash
```

-  [start_ambassadors.sh](start_ambassadors.sh) script manage all services by supervisord

## optional env variables to be used with staging 
AMBASSADORS_BRANCH, branch of  https://github.com/threefoldfoundation/www_conscious_internet default is development

## flist 

- https://hub.grid.tf/mikhaieb/bishoyabdo-www_ambassadors-latest.flist

