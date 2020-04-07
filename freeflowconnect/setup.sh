#!/usr/bin/env bash
set -x

#Backend
if [[ ! -d /backend ]] ; then
    git https://github.com/threefoldtech/freeflowconnect-backend /backend
    cd /backend
    pip3 install -r requirements.txt
else
    echo Free Flow backend dir already exists, updating repo now
    cd /backend
    git stash
    git pull
    pip3 install -r requirements.txt
fi

#Frontend
if [[ ! -d /frontend ]] ; then
    git https://github.com/threefoldtech/freeflowconnect-frontend /frontend
    cd /frontend
    yarn install
    yarn build
    yarn lint
else
    echo Free Flow backend dir already exists, updating repo now
    cd /backend
    git stash
    git pull
    yarn install
    yarn build
    yarn lint
fi
