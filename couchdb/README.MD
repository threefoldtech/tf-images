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

http://172.17.10.35:5984/_utils   (replace 172.17.10.35 with your container IP, port remains same though)

Login with DB admin and password and go to http://172.17.10.35:5984/_utils/#/verifyinstall

![image](https://user-images.githubusercontent.com/25789764/88478523-18e6b300-cf5a-11ea-80f2-2a03f68b83fe.png)



