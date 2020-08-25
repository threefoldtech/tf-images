# Building

```
    docker build -t threefolddev/crystaldrive . 
    docker push threefolddev/crystaldrive
```
- then convert it form our hub to an flist https://hub.grid.tf

# create docker container 

```
docker run -i -p8080:3000 -p2207:22 --name crystaldrive-test -e TF_EXP_USER=mytest4 -e EMAIL=mytest4@test.com -e DESCRIPTION=test4 -e pub_key= -e JWT_SECRET_KEY=jwtuuidnodash -e SESSION_SECRET_KEY=seesionuuid -e SEED="3bot login seed for app" -e OPEN_KYC_URL=https://openkyc.live/verification/verify-sei -e THREEBOT_LOGIN_URL=https://login.threefold.me -e ONLY_OFFICE_HOST=127.0.0.1  -v ~/onlyoffice-data:/root/onlyoffice/data  threefolddev/crystaldrive
```


- IMPORTANT : Please backup your seed file /root/bcdb/user.seed , is generated automtic on first time of container starting 
		is created by providing the three env vars
		```
		TF_EXP_USER=mytest4 -e EMAIL=mytest4@test.com -e DESCRIPTION=test4
		```
- pub_key=  is your ssh key 
- /root/onlyoffice/data is the ONLY_OFFICE_DATA_PATH inside container, you can make it shared as above to ~/onlyoffice-data in your host
# flist
	 https://hub.grid.tf/bishoy.3bot/threefolddev-crystaldrive-latest.flist
# References

https://github.com/crystaluniverse/crystaldrive
