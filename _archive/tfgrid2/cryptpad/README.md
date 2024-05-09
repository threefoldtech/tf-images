# Building

in the cryptpad directory

`docker build -t {user/org}/cryptpad:latest .`

## Running

```bash
docker run -dti -e pub_key="ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDL/IvQhp..." -e size=1000 -p 3000:3000 {user/org}/cryptpad:latest --entrypoint="/start.sh"
```

env var size = amount of data storage in MBs

## To use backups - pass these env variables

- "AWS_ACCESS_KEY_ID": "s3 access key",
- "AWS_SECRET_ACCESS_KEY": "s3 secret",
- "RESTIC_PASSWORD": "backup password",
- "RESTIC_REPOSITORY": "repo url example: `s3:s3backup.tfgw-testnet-01.gateway.tf/hamada`",
- "BACKUP_PATHS": "/persistent_data",
- "CRON_FREQUENCY": "* * * * *",  # example every 1 min


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
