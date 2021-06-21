# Presearch

This image will start a Presearch node 

Docker image for flist = docker pull arrajput/presearch-flist:1.0

### How to build from the Dockerfile ?

```
git clone https://github.com/threefoldtech/tf-images.git
cd presearch
docker build --tag presearch:latest .
```
Sit back and relax then ! It should be quicker and you should see a successful message as below,

```
Step 6/10 : COPY config/presearch /var/www/localhost/htdocs/
 ---> 6cc91321e9a7
Step 7/10 : COPY config/cronjobs /tmp/
 ---> adc2d0bb1239
Step 8/10 : COPY scripts/check* /usr/bin/
 ---> 95a6b214cbbf
Step 9/10 : COPY scripts/start_presearch.sh /
 ---> ed63e8c221b9
Step 10/10 : ENTRYPOINT ["/start_presearch.sh"]
 ---> Running in af06c59a8231
Removing intermediate container af06c59a8231
 ---> c66a20398946
Successfully built c66a20398946
Successfully tagged presearch:latest
```

### Startup Script / EntryPoint

This should be found here [ENTRYPOINT](scripts/start_dgb.sh)

