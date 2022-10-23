# IPFS CLUSTER
get an ipfs cluster up and running on a VM

## what in this image
- [Ipfs Cluster](https://ipfscluster.io/) on Ubuntu 20.04
- include preinstalled wget, openssh-server, curl, ipfs and ipfs cluster binaries.
- zinit process manager which is configured with these services:
     - sshd: starting OpenSSH server daemon 
     - ipfs: starting ipfs daemon.
     - ipfscluster:Initalize the ipfs cluster service.
     - secret: Adds the Multiaddress of a cluster peer to the peerstore and starts the ipfs cluster daemon. 
     - sshkey: Add the user SSH key to authorized_keys, so he can log in remotely to the host which running this image.

## Building

in the grid3_ipfs_cluster directory

`docker build -t {user|org}/ipfs_cluster .`

## Running with docker
- For the first peer in the cluster:
     
     `docker run {user|org}/ipfs_cluster`
- For the other peers in the cluster environment variables are needed:

     `docker run -e "CLUSTER_SECRET=$CLUSTER_SECRET" -e "BOOTSTRAP=$BOOTSTRAP" {user|org}/ipfs_cluster`

## Deploying
Easiest way to deploy a VM using the flist is to head to to our [playground](https://play.grid.tf) and deploy a Virtual Machine by providing this flist URL.
* make sure to provide the correct entrypoint, and required env vars.

## Flist
### URL:
This Flist should be updated to official repo.
```
https://hub.grid.tf/mayarosama.3bot/mayarosama-ipfscluster-latest.flist
```

### Entrypoint
- `/sbin/zinit init`

### Required Env Vars
- `SSH_KEY`: User SSH public key.

### Optional Env Vars (For adding another peer to the ipfs cluster)
- `CLUSTER_SECRET`: The cluster secret. should be same for all cluster peers.
- `BOOTSTRAP`: The cluster bootstrap peer address to use for joining existed cluster.
- `IPFS_PROFILE`: ex. "server" to optimize for running with public ip address.
- `CLUSTER_PINSVCAPI_HTTPLISTENMULTIADDRESS`: "/ip4/0.0.0.0/tcp/9097" to expose the pinning service rest endpoint
- `CLUSTER_PINSVCAPI_BASICAUTHCREDENTIALS`: ex."username:password"
- `CLUSTER_RESTAPI_HTTPLISTENMULTIADDRESS`: "/ip4/0.0.0.0/tcp/9094" to expose the rest api endpoint.
- `CLUSTER_RESTAPI_BASICAUTHCREDENTIALS`: "username:password"
- `CLUSTER_METRICS_ENABLESTATS`: "true" to enable metrics endpoint.
- `CLUSTER_METRICS_PROMETHEUSENDPOINT`: "/ip4/0.0.0.0/tcp/8888" to expose it.
