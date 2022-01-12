# Mattermost all in one
this Docker file used to build a mattermost all in one image

Note: if you already have a prebuilt release skip to point 4
## 1.Prerequisites
- install golang
```
https://go.dev/doc/install
```
- add this to bashrc
```
export GOPATH=$HOME/go
export PATH=$PATH:$GOPATH/bin
ulimit -n 8096
```

- Install required packages 
```
apt-get install make npm zip unzip docker.io docker-compose -y 
```
## 2.Cloning the repos 
- clone frontend repo 
```
git clone https://github.com/freeflowuniverse/freeflow_teams_frontend.git
```
- clone the backend
```
git clone https://github.com/freeflowuniverse/freeflow_teams_backend.git
```
- clone the tf-images repo
```
git clone https://github.com/threefoldtech/tf-images.git
```
## 3.Building frontend and backend packages
```
mkdir -p freeflow_teams_frontend/dist
cd freeflow_teams_backend
ln -nfs ../freeflow_teams_frontend/dist client
cd ../freeflow_teams_frontend
make build
cd ../freeflow_teams_backend
make build 
make package
```
## 4.Docker build prerequesits
```
cd ../tf-images/tfgrid3/mattermost_aio
cp ../freeflow_teams_backend/dist/mattermost-team-linux-amd64.tar.gz .
```
## 5.Building mattermost image
```
docker build -t threefoldtech/mattermost:latest
docker push threefoldtech/mattermost:latest 
```

## 6.ENV VARs
```
SSH_KEY = "<your ssh public key"
DB_PASSWORD = "<Database password>"
SITE_URL = <your domain>
SMTPServer=<SMTP Server> # used to send notification emails
SMTPPort=<SMTP port>
SMTPUsername=<SMTP username>
SMTPPassword=<SMTP password>
```