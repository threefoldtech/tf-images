# Building

in the cryptpad directory

`docker build -t {user/org}/cryptpad:latest .`

## Running

```bash
docker run -dti -e pub_key="ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDL/IvQhp..." -e size=1000 -p 3000:3000 {user/org}/cryptpad:latest --entrypoint="/start.sh"
```

## Access using ssh
```bash
ssh roo@{CONTAINER_IP}
```

## From Browser

```bash
{CONTAINER_IP}:3000
```
## flist
https://hub.grid.tf/bola.3bot/3bot-cryptopad-latest.flist
