#!/bin/bash

set -x 

if [ "$NETWORK" = 'testnet' ]; then
      cp /var/lib/algorand/genesis/testnet/genesis.json /var/lib/algorand/genesis.json
    elif [ "$NETWORK" = 'betanet' ];then
      cp /var/lib/algorand/genesis/betanet/genesis.json /var/lib/algorand/genesis.json
    elif [ "$NETWORK" = 'devnet' ];then
      cp /var/lib/algorand/genesis/devnet/genesis.json /var/lib/algorand/genesis.json
    else 
      cp /var/lib/algorand/genesis/mainnet/genesis.json /var/lib/algorand/genesis.json
fi