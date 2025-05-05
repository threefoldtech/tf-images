## TF Images : 

- we have here all threefoldtech docker images for operating system distros, apps and solutions which are available for deployment on https://dashboard.grid.tf , this repository is managed and maintained by Threefoldtech operation team .

## Examples for Apps :

### Discourse 
- Dockerfile info: [discourse](./tfgrid3/forum-3/README.md)
- flist: https://hub.grid.tf/tf-official-apps/forum.flist

### Taiga
- Dockerfile info: [taiga](./tfgrid3/taiga/README.md)
- flist: https://hub.grid.tf/tf-official-apps/grid3_taiga_docker-latest.flist

### Wordpress
- Dockerfile info: [wordpress](./tfgrid3/wordpress/README.md)
- flist https://hub.grid.tf/tf-official-apps/tf-wordpress-latest.flist

### Gitea-mycelium
- Dockerfile info: [gitea](./tfgrid3/gitea_mycelium/README.md)
- flist https://hub.grid.tf/tf-official-apps/gitea-mycelium.flist

### Peertube

- Dockerfile info: [peertube](./tfgrid3/peertube/README.md)
- flist: https://hub.grid.tf/tf-official-apps/peertube-latest.flist

### Orcestrators : 

## K3S:
- Dockerfile info : [K3S](./tfgrid3/k3s/README.md)
- flist: https://hub.grid.tf/tf-official-apps/threefolddev-k3s-v1.31.0.flist

## Operating Systems Distros :

### Ubuntu 20.04
- Dockerfile info: [Ubuntu 20.04](./tfgrid3/ubuntu20.04/README.md)
- flist : https://hub.grid.tf/tf-official-vms/ubuntu-20.04-lts.flist

### Ubuntu 22.04
- Dockerfile info: [Ubuntu 22.04](./tfgrid3/ubuntu22.04/fullvm/README.md)
- flist : https://hub.grid.tf/tf-official-vms/ubuntu-22.04.flist

### Ubuntu 24.04 
- Dockerfile info: [Ubuntu 24.04](.//tfgrid3/ubuntu24.04/fullvm/README.md)
- flist : https://hub.grid.tf/tf-official-vms/ubuntu-24.04-full.flist

## Entrypoint For TF-images : 
 ### Operating Systems : 
 - Alpine: https://hub.grid.tf/tf-official-apps/alpine3.flist :```/entrypoint.sh``` 
 - Arc_mycelium: https://hub.grid.tf/tf-official-apps/arch_mycelium.flist : ``` "/sbin/zinit", "init"```
 - Centos-9: https://hub.grid.tf/tf-official-apps/centos-stream9.flist : ```/entrypoint.sh```
 - Debian: https://hub.grid.tf/tf-official-apps/debian12.flist : ```"zinit", "init"```
 - Ubuntu20.04: https://hub.grid.tf/tf-official-vms/ubuntu-20.04-lts.flist : ```/init.sh```
 - Ubuntu22.04 micro-vm: https://hub.grid.tf/tf-official-vms/ubuntu-22.04.flist : ```"zinit", "init"```
 - Ubuntu23.10 micro-vm: https://hub.grid.tf/tf-official-vms/ubuntu-23.10-mycelium.flist : ```"/sbin/zinit", "init"```
 - Ubuntu24.04 micro-vm: https://hub.grid.tf/tf-official-vms/ubuntu-24.04-latest.flist : ```"zinit", "init"```
 - Umbrel: https://hub.grid.tf/tf-official-apps/umbrel-latest.flist : ```"/sbin/zinit", "init"```

 
 ### Solutions : 
 - Algorand: https://hub.grid.tf/tf-official-apps/algorand-latest.flist : ```"/sbin/zinit", "init"```
 - Casper: https://hub.grid.tf/tf-official-apps/casperlabs-latest.flist : ```"/sbin/zinit", "init"```
 - Forum-3: https://hub.grid.tf/tf-official-apps/forum.flist : ```"/sbin/zinit", "init"```
 - Funkwhale: https://hub.grid.tf/tf-official-apps/funkwhale-1.4.0.flist :  ```"/sbin/zinit", "init"```
 - Gitea_mycelium: https://hub.grid.tf/tf-official-apps/gitea-mycelium.flist :  ```"/sbin/zinit", "init"```
 - Jenkins: https://hub.grid.tf/tf-official-apps/jenkins-latest.flist : ```"/sbin/zinit", "init"```
 - Jitsi: https://hub.grid.tf/tf-official-apps/jitsi-latest.flist : ```"/sbin/zinit", "init"```
 - K3s: https://hub.grid.tf/tf-official-apps/threefolddev-k3s-v1.31.0.flist : ```"/sbin/zinit", "init"```
 - Mattermost: https://hub.grid.tf/tf-official-apps/mattermost-latest.flist : ```"/sbin/zinit", "init"```
 - Nextcloud: https://hub.grid.tf/tf-official-apps/nextcloud.flist : ```"/sbin/zinit", "init"```
 - Nostr: https://hub.grid.tf/tf-official-apps/nostr_relay-mycelium.flist : ```"/sbin/zinit", "init"```
 - Owncloud: https://hub.grid.tf/tf-official-apps/owncloud-10.9.1.flist : ```"/sbin/zinit", "init"```
 - Peertube: https://hub.grid.tf/tf-official-apps/peertube-latest.flist : ```"/sbin/zinit", "init"```
 - Presearch: https://hub.grid.tf/tf-official-apps/presearch.flist : ```"/sbin/zinit", "init"```
 - Static website: https://hub.grid.tf/tf-official-apps/presearch.flist : ```"/sbin/zinit", "init"```
 - Subsquid: https://hub.grid.tf/tf-official-apps/subsquid.flist : ```"/sbin/zinit", "init"```
 - Taiga : https://hub.grid.tf/tf-official-apps/grid3_taiga_docker-latest.flist : ```"/sbin/zinit", "init"```
 - TFrobot: https://hub.grid.tf/tf-official-apps/tfrobot.flist : ```"/sbin/zinit", "init"```
 - Wordpress: https://hub.grid.tf/tf-official-apps/tf-wordpress-latest.flist : ```"/sbin/zinit", "init"```

## Contribution : 

- create a new branch for your work from development branch .
- push your work to your branch .
- create a PR and ask for review from code owners . 
- once your PR approved and merged , make sure to ask @maxux to promote your newly built flist . 
## new issues :

- please follow the issue templates in this repo when creating a new issue .
