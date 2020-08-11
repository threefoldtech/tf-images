# How to Build ?

```
git clone https://github.com/threefoldtech/tf-images.git
cd tf-images/couchdb
docker build --tag mycouchdb:1.0 .

```
Sit back and relax then ! You should see a successful message as below,

```
Step 18/21 : RUN ln -s usr/local/bin/docker-entrypoint.sh /docker-entrypoint.sh # backwards compat
 ---> Running in 222618a2d656
Removing intermediate container 222618a2d656
 ---> d5b4e5cdc6ed
Step 19/21 : ENTRYPOINT ["/start_couchdb.sh"]
 ---> Running in 947a15e5ec8a
Removing intermediate container 947a15e5ec8a
 ---> 97a90dacd18b
Step 20/21 : VOLUME /opt/couchdb/data
 ---> Running in 6896a9b0b562
Removing intermediate container 6896a9b0b562
 ---> 6f98ab45e1d6
Step 21/21 : EXPOSE 5984 4369 9100
 ---> Running in 911a501193c1
Removing intermediate container 911a501193c1
 ---> 4ceadee4624e
Successfully built 4ceadee4624e
```

You can then do to spin the container with your created image. Map host ports as needed.

```
docker run -dit --name=mycdb -p 5984:5984 --hostname=mycdb mycouchdb:4.0 bash
```


**NOTE : To customize any settings for coucdb, use the local.ini to edit. For instance, you can change the default admin password for couchdb.**

### Details for CouchDB solution / flist herein

**flist = https://hub.grid.tf/arehman/v2-couchdb-0-2.flist**

**Environment variables**

- pub_key (your ssh key)
- db_admin (couchdb admin)
- db_pass (couchdb admin passwd)

> NOTE : Default DB admin user and password =  admin / test9278

**For data persistence, you can mount a volume to the following directory,**

/opt/couchdb/data

**Couchdb configuration directory**

/opt/couchdb/etc

**Couchdb logs directory**

/opt/couchdb/log


## How to verify ?

Note : (Replace 172.17.10.35 with your container IP, port remains same though)

http://172.17.10.35:5984/_utils   

Login with DB admin and password and go to http://172.17.10.35:5984/_utils/#/verifyinstall

![image](https://user-images.githubusercontent.com/25789764/88478523-18e6b300-cf5a-11ea-80f2-2a03f68b83fe.png)



