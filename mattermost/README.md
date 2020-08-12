# Flist
https://hub.grid.tf/ayoubm.3bot/rafyamgadbenjamin-mattermost-latest.flist

## Building
in the mattermost directory

`docker build -t {user/org}/mattermost:5.24.2 .`

## Running

```bash
docker run -ti -e pub_key="ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAA..." -e MYSQL_ROOT_PASSWORD="mostest" -e MYSQL_USER="mmuser" -e MYSQL_PASSWORD="mostest" -e MYSQL_DATABASE="mattermost_db" -p 8065:8065 {user/org}/mattermost:5.24.2
```

## Access using ssh
```bash
ssh roo@{CONTAINER_IP}
```

## From Browser

```bash
{CONTAINER_IP}:8065
```

# Service
- mysql > 5.7
- mattermost > 5.24.2