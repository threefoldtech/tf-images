# Building 

1 - clone repo 

```
git clone https://github.com/xmonader/tf-images.git

```

2 - in the faveo directory

` cd tf-images/crm`

`docker build -t bishoyabdo/crm:latest .`

change bishoy to whatever image name.

# Running

```
docker run --rm -ti -p 80:80 -e SUPPORT_EMAIL='hamdy@greenitglobe.com' -e SENDGRID_API_KEY='yourkey' \ 
-e SUPPORT_EMAIL='sabrina@gig.tech' -e DOMAIN='staging.crm.threefoldtoken.com' bishoyabdo/crm:latest bash
```

## service run by supervisord
- postgre
- redis
- python
- crm services : mailer,rq_worker,syncdata,crm
- caddy
- ssh

## flist 

 https://hub.grid.tf/mikhaieb/bishoyabdo-crm-latest.flist 

### refrences

https://github.com/Incubaid/crm

