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

* rpcuser (The node RPC credentials user/pass)
* rpcpasswd

### Services that need to be exposed

* RPC - 14022 TCP 
* P2P - 12024 TCP 
* WEB - 80/443 TCP

### How to run ?

You can then spin the container with your created image. Map host ports as needed,

```docker run -dit --name=dgb --hostname=dgb -p 80:80 -p 14022:14022 -p 12024:12024 dgb:latest bash```
 
### How to verify ?

The node displays running services via status page that runs on the HTTP port. It should be accessible by,

```http://your_ip_address```

Get into the container with,

```docker exec -it dgb bash```

### How to verify ?

Get into the container with,

```docker exec -it dgb bash```

Verify the node runnning by checking the harmony process, you could see it running as below

```
root@dgb:/opt# netstat -lntpe
Active Internet connections (only servers)
Proto Recv-Q Send-Q Local Address           Foreign Address         State       User       Inode      PID/Program name
tcp        0      0 0.0.0.0:22              0.0.0.0:*               LISTEN      0          22338958   1/sshd
tcp        0      0 0.0.0.0:12024           0.0.0.0:*               LISTEN      0          22338214   23/digibyted
tcp        0      0 0.0.0.0:14022           0.0.0.0:*               LISTEN      0          22338207   23/digibyted
tcp6       0      0 :::22                   :::*                    LISTEN      0          22338960   1/sshd
tcp6       0      0 :::12024                :::*                    LISTEN      0          22338213   23/digibyted

```


The default data directory for Digibyte is /dgb where you will see all Digibyte data,

```
root@dgb:/dgb/.digibytet# tree -dh
.
|-- [4.0K]  blocks
|   `-- [4.0K]  index
|-- [4.0K]  chainstate
`-- [4.0K]  database

4 directories
```
