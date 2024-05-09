# Building 

in the www_community directory

`docker build -t threefolddev/www_community .`

change threefolddev to whatever image name.

# Running

```
docker run -it --name www_community -v /ssh:/ssh -e www_community=staging -e SEND_GRID_KEY=secret  -e SUPPORT_EMAIL_FROM=urmail -e SUPPORT_EMAIL_TO=urmail -e WEBHOOK_SECRET=68dggg -p80:80 bishoyabdo/www_community:latest bash
```

- note that you need to put your private key of threefoldagent or any user granted to repo https://github.com/threefoldfoundation/data_threefold_projects_friends so you can clone from it
- the flist expect the private key on path ` /ssh/id_rsa `
-  [start_ambassadors.sh](start_www_community.sh) script manage all services by supervisord


## optional env variables to be used with staging 
www_community, branch of  https://github.com/threefoldfoundation/www_conscious_internet default is development

## flist 

- https://hub.grid.tf/mikhaieb/bishoyabdo-www_community-latest.flist

