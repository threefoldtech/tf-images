### build image 

```
docker build -t ffc:latest .
```
### start docker container

```
docker run --privileged --hostname test --name test -e THREE_BOT_CONNECT_URL=login.staging.jimber.org -it ffc:latest bash

```