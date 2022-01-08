# grid3_ubuntu20.04

## what in this image
- based on official docker ubuntu 20.04
- include preinstalled openssh-client, openssh-server, git, mc, mcedit curl, wget, dnsutils, iproute2, and vim packages.

## Building

in the grid3_ubuntu20.04_debug directory

`docker build -t {user|org}/grid3_ubuntu:20.04 .`



## Testing
### Running

```bash
docker run -dti -e SSH_KEY="ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDL/IvQhp..." {user|org}/grid3_ubuntu:20.04
```

### Access using SSH
```bash
CONTAINER_IP=$(docker inspect -f '{{range.NetworkSettings.Networks}}{{.IPAddress}}{{end}}' $(docker container ls -lq))
ssh root@$CONTAINER_IP
```

## Deploying on grid 3

### convert the docker image to Zero-OS flist
Easiest way to convert the docker image to Flist is using [Docker Hub Converter tool](https://hub.grid.tf/docker-convert), make sure you already built and pushed the docker image to docker hub before using this tool.

### Deploying
Easiest way to deploy a VM using the flist is to head to to our [playground](https://play.grid.tf) and deploy a Virtual Machine by providing this flist URL.
make sure to provide the correct entrypoint.

another way you could use is using our terraform plugin [docs](https://github.com/threefoldtech/terraform-provider-grid)

## Flist
### URL:
TODO: should be updated to official repo.
```
https://hub.grid.tf/samehabouelsaad.3bot/abouelsaad-grid3_ubuntu20.04_debug-latest.flist
```

### Entrypoint
- `/init.sh`


### Required Env Vars
- `SSH_KEY`: User SSH public key.