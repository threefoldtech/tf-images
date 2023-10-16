#!/bin/bash

set -x 

if [ "$NETWORK" = "testnet" ]; then
      cp -rf /root/launch/testnet-v4/without-sentry/bor/* /root/node 
    else 
      cp -rf /root/launch/mainnet-v1/without-sentry/bor/* /root/node
fi