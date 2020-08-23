# Building

```
    docker build -t threefolddev/crystaldrive . 
    docker push threefolddev/crystaldrive
```
- then convert it form our hub to an flist https://hub.grid.tf

# create docker container 
```
docker run -i -p80:3000 -p2207:22 --name crystaldrive-test -e pub_key= -e JWT_SECRET_KEY= -e   SESSION_SECRET_KEY= \
-e SEED="sY4dAEWZXsPQEMOHzP65hNeDr4+7D0D6fbEm2In22t0=" -e OPEN_KYC_URL=https://openkyc.live/verification/verify-sei \
-e THREEBOT_LOGIN_URL=https://login.threefold.me -e ONLY_OFFICE_DATA_PATH=/root/onlyoffice/data \
-e ONLY_OFFICE_HOST=127.0.0.1
```

# flist
	 https://hub.grid.tf/bishoy.3bot/threefolddev-crystaldrive-latest.flist
# References

https://github.com/crystaluniverse/crystaldrive
