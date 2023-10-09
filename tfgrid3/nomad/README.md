# Description

These are server and client images for [Nomad](https://www.nomadproject.io/) with the client supporting Docker task driver. Servers must be exactly 3 nodes while any number of clients are allowed.

## Environment Variables

Only two variables are expected to function properly:

- "SSH_KEY": Public SSH key to be able to access different nodes. If not provided SSH won't work.
- "FIRST_SERVER_IP": The private IP of the first server to be deployed. It should be provided for all nodes except the first server node. If not provided, the nodes won't be able to join the cluster.

## Build flist

- Build and push server and client images to Docker Hub:

```bash
docker build -t <docker-hub-username>/nomad-server ./server
docker push <docker-hub-username>/nomad-server
```

```bash
docker build -t <docker-hub-username>/nomad-client ./client
docker push <docker-hub-username>/nomad-client
```

- Convert both images on [TF Grid Hub](hub.grid.tf).

## Example

An example of 3 server and 2 client deployment can be found [here](https://gist.github.com/AbdelrahmanElawady/cc99e5ccbfb9f1a6e9412a8614c16982).
