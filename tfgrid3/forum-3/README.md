
# Discourse docker images
- `threefolddev/forum-base:v3.1`: 
    - deploys the [forum source code](https://github.com/Omarabdul3ziz/tf-forum3) on docker
    - [Dockerfile](https://github.com/threefoldtech/discourse_docker/blob/main/image/forum/Dockerfile)
- `threefolddev/forum-docker:v3.1`: 
    - deploys the `threefolddev/forum-base:v3.1`
    - [Dockerfile](./Dockerfile)

### Required Envars
```bash
DISCOURSE_HOSTNAME=newforum.gent01.dev.grid.tf # domain name referes to host-ip:80
DISCOURSE_DEVELOPER_EMAILS=admin@example.com
DISCOURSE_SMTP_ADDRESS: smtp.mailtrap.io
DISCOURSE_SMTP_PORT: 2525
DISCOURSE_SMTP_USER_NAME: 
DISCOURSE_SMTP_PASSWORD: 
```

### Logs
You can find most of the logs on the host machine at `/var/discourse/shared/standalone/logs` for all the servers ever hosted on this machine.
Or inside the docker container at `/var/www/discourse/logs`