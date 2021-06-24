# Presearch

This image will start a Presearch node 

Docker image for flist = ```docker pull arrajput/presearch-flist:1.0```

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
### Hardware requirements

  * 1 Cores
  * 1 GB Ram
  * 3 GB disk

### Services that need to be exposed

* WEB - 80/443 TCP

### Startup Script / EntryPoint

This should be found here [ENTRYPOINT](scripts/start_presearch.sh)

### Environment Variables

This is the only variable that needs to be set for now. This is the user's code that binds with the node and serves as node identity

* REGISTRATION_CODE

### How to run ?

You can then spin the container with your created image. Map host ports as needed,

```docker run -dit --name=ps --hostname=ps -p 80:80 presearch:latest bash```
 
### How to verify ?

The node displays running services via status page that runs on the HTTP port. It should be accessible by,

```http://your_ip_address```

Get into the container with,

```docker exec -it ps bash```

Verify the node runnning by checking the digibyte process, you could see it running as below

```
root@presearch:/opt# ps -ef
PID   USER     TIME  COMMAND
    1 root      0:02 /app/presearch-node
   16 root      0:00 /usr/sbin/httpd -k start
   20 apache    0:00 /usr/sbin/httpd -k start
   21 apache    0:00 /usr/sbin/httpd -k start
  

```

