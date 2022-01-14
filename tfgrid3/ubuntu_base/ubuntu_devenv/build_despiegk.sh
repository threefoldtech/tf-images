set -ex

export NAME="grid3_ubuntu_dev:20.04"

docker login -u despiegk
docker build -t threefoldtech/grid3_ubuntu_dev:20.04 .
docker push threefoldtech/grid3_ubuntu_dev:20.04

echo " - CALL FLIST SERVER TO MAKE AN FLIST, CAN TAKE A WHILE..."
curl -X POST -F 'image=threefoldtech/grid3_ubuntu_dev:20.04' -H "Authorization: bearer $TFHUBKEY" https://hub.grid.tf/api/flist/me/docker
