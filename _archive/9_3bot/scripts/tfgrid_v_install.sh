set -ex

apk add --no-cache tmux bash sudo python3 libtool g++

curl https://raw.githubusercontent.com/threefoldtech/builders/master/scripts/install.sh > /tmp/install.sh && bash -x /tmp/install.sh

npm install grid3_client -g

mkdir -p ~/.vmodules/threefoldtech
cd ~/.vmodules/threefoldtech
git clone https://github.com/threefoldtech/vgrid

echo " ** INSTALL V TFGRID DONE" 