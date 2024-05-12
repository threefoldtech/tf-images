# centos-stream9

## what in this image
- based on Quay.io official CentOS stream 9
- include preinstalled openssh-server package.

## Building

in the centos-stream9 directory

`docker build -t {user|org}/grid3_centos:stream9 .`

## Testing
### Running

```bash
docker run -dti {user|org}/grid3_centos:stream9
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
```
https://hub.grid.tf/tf-official-apps/threefoldtech-centos-8.flist
```

### Entrypoint
- `/entrypoint.sh`


### Required Env Vars
- `SSH_KEY`: User SSH public key.
