set -e
set +x

apk add --no-cache tmux bash sudo
# cd /tmp
# rm -f install_nvm.sh
# curl -sL https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.3/install.sh -o install_nvm.sh

# bash install_nvm.sh

# chmod 770 $NVM_DIR/nvm.sh

# export NVM_DIR="$HOME/.nvm"
# source $NVM_DIR/nvm.sh

# command -v nvm

# nvm install node

# echo " ** INSTALL NVM DONE"

apk add --no-cache nodejs npm

echo " ** INSTALL NODEJS DONE"
