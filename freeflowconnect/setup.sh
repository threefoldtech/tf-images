#!/usr/bin/env bash
set -x

#Backend
if [[ ! -d /backend ]] ; then
    git clone https://github.com/threefoldtech/freeflowconnect-backend /backend
else
    echo Free Flow backend dir already exists, updating repo now
    cd /backend
    git stash
    git pull
fi

cd /backend
pip3 install -r requirements.txt

FILE=/backend/config/freeflow_config.py

if [ ! -f "$FILE" ]; then
    mv /backend/config/freeflow_config_example.py /backend/config/freeflow_config.py
fi

sed -i "s/THREE_BOT_CONNECT_URL.*/THREE_BOT_CONNECT_URL = '$THREE_BOT_CONNECT_URL'/g" /backend/config/freeflow_config.py

#Frontend
if [[ ! -d /frontend ]] ; then
    git clone https://github.com/threefoldtech/freeflowconnect-frontend /frontend
    cd /frontend
else
    echo Free Flow backend dir already exists, updating repo now
    cd /frontend
    git stash
    git pull
fi

# Set domain to be host ip address if not provided
if [ -z "$DOMAIN"]
  then
    echo "setting domain"
    export DOMAIN=`hostname --ip-address`
fi


sed -i "s/chatServer.*/chatServer: 'http:\/\/$DOMAIN\/api',/g" /frontend/public/config.js
sed -i "s/botFrontEnd.*/botFrontEnd: 'http:\/\/$DOMAIN\/',/g" /frontend/public/config.js
sed -i "s/botBackend.*/botBackend: 'http:\/\/$DOMAIN\/api',/g" /frontend/public/config.js
sed -i "s/janusServer.*/janusServer: 'http:\/\/$DOMAIN\/janus',/g" /frontend/public/config.js

# build
cd /frontend
FILE=package-lock.json
if [  -f "$FILE" ]; then
    rm $FILE
fi

yarn install
echo "Now building"
yarn build
yarn lint