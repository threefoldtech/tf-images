# grid3_taiga

get Taiga up and running in on grid3 VM

## what in this image
- [Taiga](https://www.taiga.io/) on Ubuntu 20.04
- include preinstalled openssh-client, openssh-server, curl, docker and docker-compose.
- ufw with restricted rules applied.
- zinit process manager

## Building

in the grid3_taiga directory

`docker build -t {user|org}/grid3_taiga_docker:latest .`

## Deploying on grid 3

### convert the docker image to Zero-OS flist
Easiest way to convert the docker image to Flist is using [Docker Hub Converter tool](https://hub.grid.tf/docker-convert), make sure you already built and pushed the docker image to docker hub before using this tool.

### Deploying
Easiest way to deploy a VM using the flist is to head to to our [playground](https://play.grid.tf) and deploy a Virtual Machine by providing this flist URL.
make sure to provide the correct entrypoint.

another way you could use is using our terraform plugin [docs](https://github.com/threefoldtech/terraform-provider-grid)

here you can find a full terraform file example to deploy this flist on grid3 [link](https://github.com/threefoldtech/terraform-provider-grid/tree/development/examples/resources) 

## Flist
### URL:
TODO: should be updated to official repo.
```
https://hub.grid.tf/samehabouelsaad.3bot/abouelsaad-grid3_taiga_docker-latest.flist
```

### Entrypoint
- `/sbin/zinit init`


### Required Env Vars
- `SSH_KEY`: User SSH public key.
- `DOMAIN_NAME`: the domain name, eg: grid3taiga.gent01.dev.grid.tf

### Optional Env Vars (but some functionality won't be available if these env vars doesn't set)

#### superuser account (Admin)
- `ADMIN_USERNAME`: user name to access the admin dashboard on `{doamin name}/admin/`.
- `ADMIN_PASSWORD`: the admin password for admin dashboard.
- `ADMIN_EMAIL`: email address for admin user.

#### smtp server settings
- `DEFAULT_FROM_EMAIL`: the from email shown when sent emails to taiga members.
- `EMAIL_USE_TLS`: either "True" or "False".
- `EMAIL_USE_SSL`: either "True" or "False".
- `EMAIL_HOST`: eg, "smtp.gmail.com".
- `EMAIL_PORT`: smtp server port.
- `EMAIL_HOST_USER`: the account address to sent the emails from.
- `EMAIL_HOST_PASSWORD`: the account password.
