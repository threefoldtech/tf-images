# grid3_owncloud

get Owncloud up and running in on grid3 VM

## what in this image
- Owncloud on Ubuntu 20.04
- include preinstalled openssh-client, openssh-server, curl, docker and docker-compose.
- ufw with restricted rules applied.
- zinit process manager which is configured with these services:
     - sshd: starting OpenSSH server daemon 
     - contained: starting containerd daemon, which manages the complete docker containers lifecycle.
     - dockerd: starting the Docker daemon.
     - owncloud: Define different owncloud services/containers, and spin everything up. 
     - sshd-init: Add the user SSH key to authorized_keys, so he can log in remotely to the host which running this image.
     - ufw-init: define restricted firewall/iptables rules.
     - ufw: apply the pre-defined firewall rules
     - superuser-init: create the superuser based on en vars as soon as the owncloud is up and running

## Building

in the grid3_owncloud directory

`docker build -t {user|org}/grid3_owncloud_docker:latest .`

## Deploying on grid 3

### convert the docker image to Zero-OS flist
Easiest way to convert the docker image to Flist is using [Docker Hub Converter tool](https://hub.grid.tf/docker-convert), make sure you already built and pushed the docker image to docker hub before using this tool.

### Deploying
Easiest way to deploy a VM using the flist is to head to to our [playground](https://play.grid.tf) and deploy a Virtual Machine by providing this flist URL.
* make sure to provide the correct entrypoint, and required env vars.
* another important perquisite is to have a disk mounted on `/var/lib/docker`. make sure its size is big enough to fit both the images for owncloud, and the volumes which will store all the db and the media files, etc.

or use the dedicated owncloud weblet if available, which will deploy an instance that satisfies the above perquisites.

another way you could use is using our terraform plugin [docs](https://github.com/threefoldtech/terraform-provider-grid)

### Flist

- https://hub.grid.tf/waleedhammam.3bot/waleedhammam-owncloud-latest.flist

### Entrypoint
- `/sbin/zinit init`