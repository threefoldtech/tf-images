# Peertube All In One image

### About

- This Dockerfile use the threefold peertube forked repo: [here](https://github.com/freeflowuniverse/tf-peertube)

- The image runs these services (peertube, postgresql, redis, ssh)

- The server by default runs on ipv6, to update that you can comment line #62 on entrypoint

  ```bash
  sed -i "0,/hostname: '0.0.0.0'/ s//hostname: '::'/" /config/production.yaml
  ```

- You can config the instance by exporting env vars like

  ```bash
  # config redis
      PEERTUBE_REDIS_HOSTNAME=127.0.0.1
      PEERTUBE_REDIS_PORT=6379
      # peertube expect redis to listen on 127.0.0.1:6379

  # config postgres
      PEERTUBE_DB_HOSTNAME=127.0.0.1
      PEERTUBE_DB_PORT=5432
      PEERTUBE_DB_SUFFIX
      PEERTUBE_DB_USERNAME
      PEERTUBE_DB_PASSWORD
      # peertube expect postgres to listen on 127.0.0.1:5432

  # config ssh
      SSH_KEY

  # config peertube
      PEERTUBE_WEBSERVER_HOSTNAME=peertube.gent01.dev.grid.tf
      PEERTUBE_WEBSERVER_PORT=443
      # peertube needs a webserver to run on * you can use tf gateway or nginx server *

  ```

  find the full list [here](https://github.com/freeflowuniverse/tf-peertube/blob/develop_threefold_login/support/docker/production/config/custom-environment-variables.yaml)

### Build

```bash
docker build -t <docker-username>/peertube:<version> .
docker push <docker-username>/peertube:<version>
```

convert to flist using the [tf-docker-converter](https://hub.grid.tf)

### Use

- Rus as a contianer

```
docker run -d -p <host-port>:9000 -v <host-volume>:/data --env-file ./.env <docker-username>/peertube:<version>
```

- Run as flist
  - use the flist link
  - set the entrypoint to `/sbin/zinit init`
  - provide the env variables you need
