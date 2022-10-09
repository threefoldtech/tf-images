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



### Deploying
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
- `CLUSTER_SECRET`: The cluster secret, so it can be added to the configuration file.
- `MULTIADDRESS`: The cluster peer address so it can be added to the peerstore.
