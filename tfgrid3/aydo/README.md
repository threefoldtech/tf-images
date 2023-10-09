# Description

This is an image of [Aydo](https://github.com/freeflowuniverse/aydo/) and [ONLYOFFICE](https://www.onlyoffice.com/) with Aydo running on port 80 (can also run on 443 for HTTPS) and ONLYOFFICE on port 4000. The VM with this image must have public IP in order for Aydo to work with ONLYOFFICE.

## Environment Variables

Only one is required:

- "SSH_KEY": Public SSH key to be able to access the machine. If not provided SSH won't work.

## Build flist

Build and push the image to Docker Hub:

```bash
docker build -t <docker-hub-username>/aydo .
docker push <docker-hub-username>/aydo
```

Convert the image on [TF Grid Hub](hub.grid.tf).

## Example

Using `tf-grid-cli`:

```bash
tf-grid-cli deploy vm --name aydo --ssh ~/.ssh/id_rsa.pub --ipv4 --flist https://hub.grid.tf/aelawady.3bot/abdulrahmanelawady-aydo-latest.flist --entrypoint "/sbin/zinit init"
```
