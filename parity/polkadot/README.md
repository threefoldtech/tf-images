# Parity/PolkaDot Node

* Polkadot v0.9.8 Official Release
* Docker image for flist = ```docker pull arrajput/parity-polkadot-flist:v1```
* flist = ```https://hub.grid.tf/arehman/arrajput-parity-polkadot-flist-v1.flist```

This image will start a Polkadot full node 

### How to build from the Dockerfile ?

```
git clone https://github.com/threefoldtech/tf-images.git
cd parity/polkadot
docker build --tag polkadot:latest .
```
Sit back and relax then ! It should be quicker and you should see a successful message as below,

```
 ---> d0de06934f0c
Step 17/17 : EXPOSE 12024 14022
 ---> Running in 030f3afef72c
Removing intermediate container 030f3afef72c
 ---> 0781ccba23e2
Successfully built 0781ccba23e2
Successfully tagged polkadot:latest
```

### Minimal Hardware requirements

  * 4 Cores
  * 12 GB Ram
  * 500 GB disk

### Startup Script / EntryPoint

This should be found here [ENTRYPOINT](scripts/start_polkadot)

```/start_polkadot```

### Environment Variables

* node_name = Name for the node provided by the user

### Services that need to be exposed

* RPC - 30333 TCP 
* P2P - 9933 TCP 
* WS  - 9944 TCP
* WEB - 80/443 TCP

### How to run ?

You can then spin the container with your created image. Map host ports as needed,

```docker run -dit --name=polkadot --hostname=polkadot -p 30333:30333 -p 9933:9933 -p 9944:9944 -p 80:80 arrajput/parity-polkadot-flist:v1 bash```
 
### How to verify ?

The node displays running services via status page that runs on the HTTP port. It should be accessible by,

```http://your_ip_address```

Get into the container with,

```docker exec -it polkadot bash```

### How to verify ?

Verify the node runnning by checking the harmony process, you could see it running as below

```
:/polkadot# netstat -lntupe
Active Internet connections (only servers)
Proto Recv-Q Send-Q Local Address           Foreign Address         State       User       Inode      PID/Program name
tcp        0      0 0.0.0.0:30333           0.0.0.0:*               LISTEN      0          65134343   30/polkadot
tcp        0      0 0.0.0.0:9933            0.0.0.0:*               LISTEN      0          65134359   30/polkadot
tcp        0      0 0.0.0.0:9933            0.0.0.0:*               LISTEN      0          65134356   30/polkadot
tcp        0      0 0.0.0.0:9933            0.0.0.0:*               LISTEN      0          65134353   30/polkadot
tcp        0      0 0.0.0.0:9933            0.0.0.0:*               LISTEN      0          65134350   30/polkadot
tcp        0      0 127.0.0.1:9615          0.0.0.0:*               LISTEN      0          65134685   30/polkadot
tcp        0      0 0.0.0.0:80              0.0.0.0:*               LISTEN      0          65134137   33/apache2
tcp        0      0 0.0.0.0:9944            0.0.0.0:*               LISTEN      0          65134363   30/polkadot
tcp6       0      0 :::30333                :::*                    LISTEN      0          65134342   30/polkadot
udp        0      0 0.0.0.0:49552           0.0.0.0:*                           0          65134690   30/polkadot
udp        0      0 0.0.0.0:5353            0.0.0.0:*                           0          65134689   30/polkadot


```

The default data directory for PolkaDot is /polkadot where you will see all PolkaDot data,

```
:/polkadot# tree -dh
.
`-- [4.0K]  chains
    `-- [4.0K]  polkadot
        |-- [388K]  db
        |   `-- [4.0K]  parachains
        |       `-- [4.0K]  db
        |-- [4.0K]  keystore
        `-- [4.0K]  network

7 directories
```

![image](https://user-images.githubusercontent.com/25789764/128147874-8dfce2f5-1a68-4ceb-8ca0-269847b8413b.png)
![image](https://user-images.githubusercontent.com/25789764/128147996-56ad5f4a-3b66-4428-83fd-e649489770d7.png)


