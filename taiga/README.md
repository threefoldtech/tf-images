# Building

in the taiga directory

`docker build -t {user/org}/taiga .`

## Running

```bash
docker run -it -e SECRET_KEY={SECRET_KEY} -e EMAIL_HOST={EMAIL} -e EMAIL_HOST_USER={HOST_USER} -e EMAIL_HOST_PASSWORD={PASSWORD} -e HOST_IP={HOST_IP} {user/org}/taiga /bin/bash

```

Should be able to access taiga on http://{HOST_IP}:4321
## install over zos node on a contianer: 
you can use this flist https://hub.grid.tf/hosnys/hossnys-taiga-latest.flist to get your taiga instance running on a container
but make sure you opened a port for 4321 and pass the env variables like up in docker run.
