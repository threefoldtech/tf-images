# Building

in the ubuntu_18 directory

`docker build -t {user/org}/ubuntu:20.04 .`

## Running

```bash
docker run -dti -e pub_key="ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDL/IvQhp..." {user/org}/ubuntu:20.04
```

## Access using ssh
```bash
ssh roo@{CONTAINER_IP}
```

## flist
https://hub.grid.tf/tf-bootable/3bot-ubuntu-20.04.flist
