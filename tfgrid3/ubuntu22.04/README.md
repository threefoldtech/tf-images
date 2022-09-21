# Development Guide for Ubuntu:22.04 image
## This guide will take you through steps for pulling & running ubuntu:22.04 image

### Pull the image
```bash
docker pull threefolddev/ubuntu:22.04
```

### Build the image
```bash
docker build -t threefolddev/ubuntu:22.04 .
```

### RUN the image
```bash
sudo docker run -d --name <container_name> -e SSH_KEY="ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDL/IvQhp..." threefolddev/ubuntu:22.04
```

### Getting container ID, IP & access using SSH
```bash
docker ps
docker inspect container_ID
ssh root@container_IP
```