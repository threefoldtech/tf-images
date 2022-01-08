## Before building

`caddy` and `trc` binaries should be in this directory.

## Building

In the publishingtools directory.

```bash
docker build --force-rm -t {user/org}/publishingtools .
```

## Running

```bash
docker run -it -e TITLE=<any title> -e URL=<url to git repo> -e BRANCH=<repo branch> -e DOMAIN=<domain> {user/org}/publishingtools
```

## Access using ssh

```bash
ssh roo@{CONTAINER_IP}
```

## flist

https://hub.grid.tf/ahmed_hanafy_1/ahmedhanafy725-pubtools-https.flist
