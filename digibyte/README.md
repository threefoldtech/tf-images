# Digibyte

* DigiByte Core v7.17.2 Official Release
* Docker image for flist = ```docker pull arrajput/digibyte-flist:1.0```

This image will start a Digibyte full node 

### How to build from the Dockerfile ?

```
git clone https://github.com/threefoldtech/tf-images.git
cd digibyte
docker build --tag dgb:latest .
```
Sit back and relax then ! It should be quicker and you should see a successful message as below,

```
 ---> d0de06934f0c
Step 17/17 : EXPOSE 12024 14022
 ---> Running in 030f3afef72c
Removing intermediate container 030f3afef72c
 ---> 0781ccba23e2
Successfully built 0781ccba23e2
Successfully tagged dgb:1.1
```

### Startup Script / EntryPoint

This should be found here [ENTRYPOINT](scripts/start_dgb.sh)

### Environment Variables

This is the only variable that needs to be set for now. This is the user's code that binds with the node and serves as node identity

* registration_code

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


