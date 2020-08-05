# Flist link

`https://hub.grid.tf/ashraf.3bot/threefoldtech-peertube-latest.flist`

# Building

In the peertube directory run

`docker build -t {user/org}/peertube .`

# Running

`docker run -p 80:80 -p 433:433 -d {user/org}/peertube /usr/local/startup.sh {domain_name} {email}`

The domain name must be registered in a DNS server and forwards its http and https traffic to the container.

The startup script issues a certificate using certbot and associates its mail with the passed email. Then it initializes an nginx server to serve a peertube instance on https (http redirected to https).

The username and password of the administrator is printed out in the logs you can access them using:

`docker logs CONTATINER`

The configuration file is in `/var/www/peertube/config/production.yaml`. After modification the peertube server should by stopped and rerun using this command while in the `/var/www/peertube/peertube-latest` directory inside the container:

`pkill peertube && NODE_ENV=production NODE_CONFIG_DIR=/var/www/peertube/config NODE_OPTIONS="--max-old-space-size=4096" npm start`

# Environment

The only environment variable is `pub_key` used by the startup script to add this public key to the authorized keys.

# Service

This instance runs:
- nginx
- ssh
- postgresql
