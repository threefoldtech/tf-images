# Development Guide for Ubuntu:24.04 Noble image
## This guide will take you through steps for pulling & running ubuntu:24.04 image

### Pull the image
```bash
docker pull threefolddev/ubuntu:24.04
```

### Build the image
```bash
docker build -t threefolddev/ubuntu:24.04 .
```

### RUN the image
```bash
sudo docker run -d --name <container_name> threefolddev/ubuntu:24.04
```