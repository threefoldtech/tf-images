# Nix: the package manager

## what in this image

- This image provides a ready to use nix package manager

## Building

in the nixos directory

`docker build -t {user|org}/nixos:test .`

## Testing

### Running

```bash
docker run -dti -e SSH_KEY="ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDL/IvQhp..." {user|org}/nixos:test
```

### Access using SSH

```bash
CONTAINER_IP=$(docker inspect -f '{{range.NetworkSettings.Networks}}{{.IPAddress}}{{end}}' $(docker container ls -lq))
ssh root@$CONTAINER_IP
```

## Deploying on grid 3

### convert the docker image to Zero-OS flist

Easiest way to convert the docker image to Flist is using [Docker Hub Converter tool](https://hub.grid.tf/docker-convert), make sure you already built and pushed the docker image to docker hub before using this tool.

## Flist

### URL:

```
https://hub.grid.tf/ashraf.3bot/ashraffouda-nixos-latest.flist
```

### Entrypoint

- `/entrypoint.sh`

### Required Env Vars

- `SSH_KEY`: User SSH public key.
