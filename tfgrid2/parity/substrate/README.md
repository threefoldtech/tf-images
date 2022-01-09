# Parity/Substrate Node

* Version = substrate 3.0.0-3a1acf
* Docker image for flist = ```docker pull arrajput/parity-substrate-flist:v1```
* flist = ```https://hub.grid.tf/arehman/arrajput-parity-substrate-flist-v1.flist```

This image will start a substrate node template

### How to build from the Dockerfile ?

```
git clone https://github.com/threefoldtech/tf-images.git
cd parity/substrate
docker build --tag substrate:latest .
```
Sit back and relax then ! It should be quicker and you should see a successful message as below,

```
Step 17/21 : COPY scripts/substrate .
 ---> Using cache
 ---> c4a37e5cd3e4
Step 18/21 : ENTRYPOINT ["/start_substrate"]
 ---> Using cache
 ---> 03129aa830e6
Step 19/21 : VOLUME /substrate
 ---> Using cache
 ---> c51cf8bb6c37
Step 20/21 : WORKDIR /substrate
 ---> Using cache
 ---> 56dc4f015617
Step 21/21 : EXPOSE 30333 9933 9944
 ---> Using cache
 ---> 8320beaedf02
Successfully built 8320beaedf02
Successfully tagged substrate:latest

```

### Minimal Hardware requirements

  * 2 Cores
  * 4 GB Ram
  * 100 GB disk

### Startup Script / EntryPoint

This should be found here [ENTRYPOINT](scripts/start_substrate)

```/start_substrate```

### Environment Variables

* node_name = Name for the node provided by the user

### Services that need to be exposed

* RPC - 30333 TCP 
* P2P - 9933 TCP 
* WS  - 9944 TCP
* WEB - 80/443 TCP
* MGMT - 8000 TCP

### How to run ?

You can then spin the container with your created image. Map host ports as needed,

```
docker run -dit --name=substrate --hostname=substrate -p 30333:30333 -p 9933:9933 -p 9944:9944 -p 80:80 -p 8000:8000 arrajput/parity-substrate-flist:v1 bash
```
 
### How to verify ?

The node displays running services via status page that runs on the HTTP port. It should be accessible by,

```http://your_ip_address```

Get into the container with,

```docker exec -it substrate bash```

### How to verify ?

Verify the node runnning by checking the harmony process, you could see it running as below

```
/substrate# netstat -lntupe
Active Internet connections (only servers)
Proto Recv-Q Send-Q Local Address           Foreign Address         State       User       Inode      PID/Program name
tcp        0      0 0.0.0.0:9944            0.0.0.0:*               LISTEN      0          71732940   37/substrate
tcp        0      0 0.0.0.0:30333           0.0.0.0:*               LISTEN      0          71732922   37/substrate
tcp        0      0 0.0.0.0:8000            0.0.0.0:*               LISTEN      0          71733352   128/node
tcp        0      0 0.0.0.0:9933            0.0.0.0:*               LISTEN      0          71732936   37/substrate
tcp        0      0 0.0.0.0:9933            0.0.0.0:*               LISTEN      0          71732933   37/substrate
tcp        0      0 0.0.0.0:9933            0.0.0.0:*               LISTEN      0          71732930   37/substrate
tcp        0      0 0.0.0.0:9933            0.0.0.0:*               LISTEN      0          71732927   37/substrate
tcp        0      0 127.0.0.1:9615          0.0.0.0:*               LISTEN      0          71732923   37/substrate
tcp        0      0 0.0.0.0:80              0.0.0.0:*               LISTEN      0          71732901   46/apache2
tcp6       0      0 :::30333                :::*                    LISTEN      0          71732921   37/substrate

```

The default data directory for Substrate is /substrate where you will see all Substrate data,

```
:/substrate# tree -dh

@sb:/substrate# tree -dh
.
`-- [4.0K]  chains
    `-- [4.0K]  dev
        |-- [ 68K]  db
        |-- [4.0K]  keystore
        `-- [4.0K]  network

5 directories

```

![image](https://user-images.githubusercontent.com/25789764/128677706-31b5e95d-ab92-48b3-ae3c-cf90218e98c5.png)

