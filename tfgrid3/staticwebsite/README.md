# Static Website
get a static website up and running on a VM

## What is in this image
- Includes preinstalled wget, openssh-server, curl, git and caddy binaries.
- zinit process manager which is configured with these services:
     - sshd: Starts OpenSSH server daemon 
     - sshkey: Adds the user SSH key to authorized_keys, so he can log in remotely to the host which running this image.
     - clone: Clones the git repository to `website` directory.
     - github_branch: Checkout out to a specific branch if `GITHUB_BRANCH` env var was provided.
     - caddyfile: Constracts the Caddyfile.
     - caddy: Runs the caddy server.

## Building

in the staticwebsite directory

`docker build -t {user|org}/staticwebsite .`

### Convert the docker image to Zero-OS flist
Easiest way to convert the docker image to Flist is using [Docker Hub Converter tool](https://hub.grid.tf/docker-convert), make sure you already built and pushed the docker image to docker hub before using this tool.


## Deploying
Easiest way to deploy a VM using the flist is to head to to our [dashboard](https://dashboard.grid.tf) and deploy a Virtual Machine by providing the flist URL.
* make sure to provide the correct entrypoint, and required env vars.
* another important perquisite is to have a disk mounted on `/var/lib/docker`. make sure its size is big enough to fit both the images for taiga, and the volumes which will store all the db and the media files, etc.

or use the dedicated Static Website application if available, which will deploy an instance that satisfies the above perquisites.



## Flist
### URL:
This Flist should be updated to official repo.
```
https://hub.grid.tf/mayarosamaa.3bot/mayarosama-staticwebsite-latest.flist
```

### Entrypoint
- `/sbin/zinit init`

### Required Env Vars
- `SSH_KEY`: User SSH public key.
- `GITHUB_URL`: Git Repository to be clonned.

### Optional Env Vars 
- `GITHUB_BRANCH`: The git branch that is going to be served, if not provided the default branch will be served.
- `USER_DOMAIN`: The domain provided by the user.
- `HTML_DIR`: The directory inside the repository that has the static files to be served.