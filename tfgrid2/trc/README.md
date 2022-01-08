# Building 

in the trc directory

`docker build -t threefolddev/trc:zinit .`


# Running

```
docker run -e SOLUTION_IP=172.17.0.1 -e HTTP_PORT=80 -e HTTPS_PORT=443 -e REMOTE_IP=185.69.166.120 -e REMOTE_PORT=18000 -e TRC_SECRET=474:f235f9d9fd394fbb86e55bf0e69dac73 threefolddev/trc:zinit
```

## flist 

- https://hub.grid.tf/omar0.3bot/omarelawady-trc-zinit.flist
