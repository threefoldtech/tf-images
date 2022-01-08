
docker login -u despiegk
docker build -t threefoldtech/grid3_docker_host:3.0 .
docker push threefoldtech/grid3_docker_host:3.0

echo " - CALL FLIST SERVER TO MAKE AN FLIST, CAN TAKE A WHILE..."
curl -X POST -F 'image=threefoldtech/grid3_docker_host:3.0' -H "Authorization: bearer $TFHUBKEY" https://hub.grid.tf/api/flist/me/docker

##info see https://github.com/threefoldtech/0-hub#getting-information-through-api


############### LONGER WAY

# curl -X POST -F 'image=threefoldtech/grid3_ubuntu_dev:20.04' -H "Authorization: bearer $TFHUBKEY" https://playground.hub.grid.tf/api/flist/me/docker

# info https://github.com/threefoldtech/0-flist

# export SSHKEY="ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQC/9RNGKRjHvViunSOXhBF7EumrWvmqAAVJSrfGdLaVasgaYK6tkTRDzpZNplh3Tk1aowneXnZffygzIIZ82FWQYBo04IBWwFDOsCawjVbuAfcd9ZslYEYB3QnxV6ogQ4rvXnJ7IHgm3E3SZvt2l45WIyFn6ZKuFifK1aXhZkxHIPf31q68R2idJ764EsfqXfaf3q8H3u4G0NjfWmdPm9nwf/RJDZO+KYFLQ9wXeqRn6u/mRx+u7UD+Uo0xgjRQk1m8V+KuLAmqAosFdlAq0pBO8lEBpSebYdvRWxpM0QSdNrYQcMLVRX7IehizyTt+5sYYbp6f11WWcxLx0QDsUZ/J"

# #kill all dockers
# docker container kill $(docker ps -q)
# docker container rm $(docker ps -a -q)
# docker run -dti -e SSH_KEY="$SSHKEY" threefoldtech/grid3_ubuntu:20.04

# export CONTAINER_IP=$(docker inspect -f '{{range.NetworkSettings.Networks}}{{.IPAddress}}{{end}}' $(docker container ls -lq))
# ssh root@$CONTAINER_IP 'apt update && apt install rsync -y'

# # export ZFLIST_HUB_USER="threefoldtech"
# export ZFLIST_PROGRESS=1
# export ZFLIST_MNT=/tmp/zflistmnt
# export ZFLIST_HUB="https://playground.hub.grid.tf"
# export ZFLIST_BACKEND='{"host": "playground.hub.grid.tf", "port": 9910}'
# export ZFLIST_HUB_TOKEN=sq6c-58Q0jxve69hEN5vS7ApifFrkrXj9aLR1XQJEuMIyJGCkk9Y6riSLT47LtBwiuB4NcBSdpCUOCywBkbOAVsia3Jpc3RvZi4zYm90IiwgMTY0MTY0NzcxN10=

# rm -rf /tmp/zflistmnt/
# rm -rf /tmp/containerout/
# rsync -ravd --exclude '/dev' --exclude '/tmp' --exclude '/media' --exclude '*.pyc' --exclude '/proc' --exclude '/sys' --exclude '/var/log' root@$CONTAINER_IP:/ /tmp/containerout/

# zflist init
# zflist putdir /tmp/containerout /
# zflist commit /tmp/grid3_ubuntu_20_04.flist
# zflist hub upload /tmp/grid3_ubuntu_20_04.flist


