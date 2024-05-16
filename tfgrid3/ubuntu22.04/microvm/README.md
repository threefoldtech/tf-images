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
sudo docker run -d --name <container_name> threefolddev/ubuntu:22.04
```
