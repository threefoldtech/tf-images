# Flist link

`https://hub.grid.tf/ashraf.3bot/threefoldtech-peertube-latest.flist`

# Building

In the peertube directory run

`docker build -t {user/org}/peertube .`

# Running

`docker run -p 80:80 -p 433:433 -d {user/org}/peertube /usr/local/bin/startup.sh {domain_name}`

The domain name is the one used to access the website. Registering the domain and issueing a certificate is done in other containers.

The username and password of the administrator is printed out in the logs you can access them using:

`docker logs CONTATINER`

The configuration file is in `/var/www/peertube/config/production.yaml`. After modification the peertube server should by stopped and rerun using this command while in the `/var/www/peertube/peertube-latest` directory inside the container:

`pkill peertube && NODE_ENV=production NODE_CONFIG_DIR=/var/www/peertube/config NODE_OPTIONS="--max-old-space-size=4096" npm start`

# ZOS

The entry point that should be used to run the container is:

`/usr/local/bin/startup.sh {domain_name}`

# Environment

The only environment variable is `pub_key` used by the startup script to add this public key to the authorized keys.

# Service

This instance runs:
- nginx
- ssh
- postgresql
