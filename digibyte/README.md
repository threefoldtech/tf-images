# Digibyte

To Deploy on Kubernetes, see this link  [Digibyte Helm Charts for K8s](helm)

### How to build from the Dockerfile ?

```
git clone https://github.com/threefoldfoundation/blockchain_partners.git
cd Digibyte
docker build --tag dgb:latest .
```
Sit back and relax then ! It should be quicker and you should see a successful message as below,

```
Step 15/17 : ENTRYPOINT ["/start_dgb.sh"]
 ---> Running in 54eb9f2a9231
Removing intermediate container 54eb9f2a9231
 ---> c18a04f7115c
Step 16/17 : VOLUME /digibyte
 ---> Running in 0df5eeed9f6b
Removing intermediate container 0df5eeed9f6b
 ---> d0de06934f0c
Step 17/17 : EXPOSE 12024 14022
 ---> Running in 030f3afef72c
Removing intermediate container 030f3afef72c
 ---> 0781ccba23e2
Successfully built 0781ccba23e2
Successfully tagged dgb:1.1
```

### How to run ?

You can then spin the container with your created image. Map host ports as needed,

```docker run -dit --name=dgb --hostname=dgb -p 12024:12024 -p 14022:14022 dgb:latest bash```
 
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


The default data directory for Digibyte is /dgb/.digibyte where you will see all Digibyte data,

```
root@dgb:/dgb/.digibytet# tree -dh
.
|-- [4.0K]  blocks
|   `-- [4.0K]  index
|-- [4.0K]  chainstate
`-- [4.0K]  database

4 directories
```

## Preparing our flist - [Digibyte flist is here](flist.md)

This should be easy ! Export your docker container as ".tar.gz" and upload it to Threefold's hub @ [https://hub.grid.tf](https://hub.grid.tf)

```docker export your_container_name > docker export your_container_name.tar.gz```

![hub_upload](images/upload_hub.jpg)

#### - Details of flists for Digibyte under this link [Digibyte flists](flist.md)
