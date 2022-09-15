#!/bin/bash

set -x

if [ $RELAY_NODE ]; then
    cp /var/lib/algorand/config.json.example /var/lib/algorand/config.json
    
    if [ $NETWORK == "testnet" ]; then 
      sed -i 's/"NetAddress": ""/"NetAddress": ":4161"/' /var/lib/algorand/config.json
    elif [ $NETWORK == "mainnet" ]; then 
      sed -i 's/"NetAddress": ""/"NetAddress": ":4160"/' /var/lib/algorand/config.json
    else 
      echo "Couldn't create relay node on non-(main/test) network"
    fi 
fi