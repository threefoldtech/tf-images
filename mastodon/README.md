# Building

in the mastodon directory

`docker build -t threefolddev/mastodon .`

## Running

```bash
docker run -it --name masstodon -e DOMAIN=64.227.1.81 -e DB_USER=mastodon -e DB_NAME=mastodon_production  \ 
-e SMTP_SERVER=smtp.sendgrid.net -e SMTP_PORT=587 \ 
-e SMTP_LOGIN=apikey -e SMTP_PASSWORD=urpass -e SMTP_FROM_ADDRESS=urlmal \
 -p80:80 -p443:443 threefolddev/mastodon
```

## Flist


## setup 

1 - create contaniner, should access https://64.227.1.81

2 - register you admin account 

3 - after register, you can login with your e-mail/password

4 - should get a verfication message to ur mail

5 - if did not got message, check your SMTP settings on .env.production


========

## reference 

 https://github.com/tootsuite/mastodon

## Deployment

**Tech stack:**

- **Ruby on Rails** powers the REST API and other web pages
- **React.js** and Redux are used for the dynamic parts of the interface
- **Node.js** powers the streaming API

**Requirements:**

- **PostgreSQL** 9.5+
- **Redis** 4+
- **Ruby** 2.5+
- **Node.js** 10.13+
