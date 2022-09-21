# Development Guide for Ubuntu:22.04 image
## This guide will take you through steps for pulling & running ubuntu:22.04 image

### Pull the image
```bash
docker pull threefolddev/ubuntu:22.04
```
### RUN the image
```bash
sudo docker run -d --name <container_name> -e SSH_KEY=<'ssh_key_value'> threefolddev/ubuntu:22.04
```
