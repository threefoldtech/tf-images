# Building 

in the consciousinternet directory

`docker build -t bishoyabdo/consciousinternet .`

change bishoyabdo to whatever image name.

# Running

```
docker run -it --name consciousinternet  -e SEND_GRID_KEY=secret  -e SUPPORT_EMAIL_FROM=urmail -e SUPPORT_EMAIL_TO=urmail -e WEBHOOK_SECRET=68dggg -p80:80 -p443:443 bishoyabdo/consciousinternet:latest bash
```

-  [start_tfwebserver.sh](start_tfwebserver.sh) script manage all services by supervisor
## flist 

- https://hub.grid.tf/mikhaieb/bishoyabdo-consciousinternet-latest.flist

 ## references 
 
https://github.com/threefoldfoundation/tfwebserver_projects_people

https://github.com/threefoldfoundation/www_threefold_ecosystem
