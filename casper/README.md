# Casper

* Protocol version "1.1.0" 
* Image for flist = ```docker pull arrajput/casper-flist:1.0```

This image will start a Casper full node 

### Hardware requirements

  * 4 Cores
  * 16 GB Ram
  * 1 TB disk

### How to build from the Dockerfile ?

```
git clone https://github.com/threefoldtech/tf-images.git
cd casper
docker build --tag casper:latest .
```
Sit back and relax then ! It should be quicker and you should see a successful message as below,

```
Step 16/19 : ENTRYPOINT ["/start_casper"]
 ---> Using cache
 ---> f5778a4466c5
Step 17/19 : VOLUME /var/lib/casper
 ---> Using cache
 ---> b1d059cf5fd9
Step 18/19 : WORKDIR /var/lib/casper
 ---> Using cache
 ---> d7c23ec991ba
Step 19/19 : EXPOSE 35000 7777 8888 9999
 ---> Using cache
 ---> 0317e53b47a9
Successfully built 0317e53b47a9
Successfully tagged casper:latest

```

### Startup Script / EntryPoint

This should be found here [ENTRYPOINT](scripts/start_casper)

### How to run ?

You can then spin the container with your created image. Map host ports as needed,

```
docker run -dit --name=casper --hostname=casper -p 35000:35000 -p 7777:7777 -p 8888:8888 -p 9999:9999 -p 8080:80 casper:latest bash
```

### Services to EXPOSE
 
* 35000 = P2P service
* 7777 = RPC service
* 8888 = HTTP REST endpoint
* 9999 = HTTP SSE service
* 80/443 = WEB

Make sure all the above required ports are opened

![image](https://user-images.githubusercontent.com/25789764/123585265-f4432d00-d7f3-11eb-997c-5c3d333f224a.png)

 
### How to verify ?

The node displays running services via status page that runs on the HTTP port. It should be accessible by,

```http://your_ip_address```

Get into the container with,

```docker exec -it casper bash```

Verify the node runnning by checking the digibyte process, you could see it running as below

```
root@casper:/var/lib/casper# netstat -lntupe
Active Internet connections (only servers)
Proto Recv-Q Send-Q Local Address           Foreign Address         State       User       Inode      PID/Program name
tcp        0      0 0.0.0.0:8888            0.0.0.0:*               LISTEN      0          7632603    54/casper-node
tcp        0      0 0.0.0.0:35000           0.0.0.0:*               LISTEN      0          7632602    54/casper-node
tcp        0      0 0.0.0.0:9999            0.0.0.0:*               LISTEN      0          7632604    54/casper-node
tcp        0      0 0.0.0.0:80              0.0.0.0:*               LISTEN      0          7633249    31/apache2

```


The default data directory for Casper is /var/lib/casper where you will see all Casper data,

```
root@casper:/var/lib/casper# tree -dh
.
|-- [4.0K]  bin
|   |-- [4.0K]  1_0_0
|   |-- [4.0K]  1_1_0
|   |-- [4.0K]  1_1_2
|   `-- [4.0K]  1_2_0
`-- [4.0K]  casper-node

```


