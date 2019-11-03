# Building

in the taiga directory

`docker build -t {user/org}/taiga .`

## Running

```bash
docker run -it -e SECRET_KEY={SECRET_KEY} -e EMAIL_HOST={EMAIL} -e EMAIL_HOST_USER={HOST_USER} -e EMAIL_HOST_PASSWORD={PASSWORD} -e HOST_IP={HOST_IP} {user/org}/taiga /bin/bash

```

Should be able to access taiga on http://{HOST_IP}:4321