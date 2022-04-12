Originating from Ubuntu container latest 20.04 LTS at date (6th of April 2022)
Adding SSH binaries, copying SSH Public Key from ENV variable to ~/root/.ssh/authorized_keys
Download k3s v 1.22.8, supported by Rancher v2.6.4. k3s v1.23.x are experimental for current Rancher version.
zinit v0.2.6

# Building
`docker build -t archit3kt/k3s:1.22.8 .`

## Running

Creating tmp directories to mount on destination containers.

`mkdir -p /tmp/server1 /tmp/server2 /tmp/server3 /tmp/agent`

Customize the env files :

Docker with standard config and no running containers will default IPs starting from 172.11.0.2 and increment for each container. server1 which init the cluster should have 172.11.0.2, if this is not the case please modify the K3S_URL variables in every file from env_files directory.
Remember to change your SSH KEY to connect to your nodes !

for running one server node

```bash
docker run --env-file ./env_files/env_server_normal.list -v /tmp/server1:/opt/data --privileged archit3kt/k3s:1.22.8
```

for running 3 HA nodes

```bash
docker run --env-file ./env_files/env_server_HA1.list -v /tmp/server1:/opt/data --privileged archit3kt/k3s:1.22.8
docker run --env-file ./env_files/env_server_HA2.list -v /tmp/server2:/opt/data --privileged archit3kt/k3s:1.22.8
docker run --env-file ./env_files/env_server_HA3.list -v /tmp/server3:/opt/data --privileged archit3kt/k3s:1.22.8
```

for running an agent node

```bash
docker run --env-file ./env_files/env_agent.list -v /tmp/agent:/opt/data --privileged archit3kt/k3s:1.22.8
```

## Flist
https://hub.grid.tf/archit3kt.3bot/archit3kt-k3s-1.22.8.flist

## entrypoint 

```
zinit init 
```

Launch /entrypoint.sh

## ENV Vars

Mandatory variables :

- `K3S_URL`: For the master node this should be empty for worker nodes should be the master url for example `https://<MASTER_IP>:6443`
- `K3S_TOKEN`: Token used for k3s machines to join the cluster. Should be the same for all nodes
- `K3S_DATA_DIR`: Data dir for kubernetes. You could put /opt/data for example
- `K3S_NODE_NAME`: sets node name
- `SSH_KEY` : Your SSH Key to connect to your nodes

Optional variables :

- `INSTALL_HA_SERVER` : Specify any non empty value to activate. Initialize an embedded cluster with ETCD. Possible option for 1 node or more. Not selecting this option will install a unique server with default sqllite database
- `HARDENED` : Specify any non empty value to activate. Will apply some hardening tips listed by K3S (https://rancher.com/docs/k3s/latest/en/security/hardening_guide/). Pod Security Policies are not configured since it is actually deprecated, and no network policies are actually applied.
- `SERVER_NODE_ONLY_CONTROL_PLANE` : Specify any non empty value to activate. Apply a specific taint to the server so it runs only critical containers for the cluster to operate. Other containers will run on nodes which do not have this taint (agents).
- `LOG_DIRECTORY` : Specify where to put k3s logs. Default is /var/log/rancher. k3s log functionality should rotate them automatically (to verify)

## Terraform

You'll find in the terraform folder some examples of possible deployments, just change your destination node ID and the mnemonic words of your TF account inside the file you want to execute.

The reinit script automates the deletion and deployment process to restart from scratch. Useful for working with a fresh starting point

## Rancher

rancherInstall.sh go through the steps to install Rancher on your newly deployed k3s cluster. This is an install script for a newly created k3s cluster, not an update script ! You'll need to have kubectl and helm installed on your client OS.
