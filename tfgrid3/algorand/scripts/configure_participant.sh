#!/bin/bash

set -x
    
if [  $NODE_TYPE = 'participant' ]; then
    export WALLET_NAME="my_wallet"
    export WALLET_PASS=""
    expect /scripts/wallet_new.exp

    account_import_response=$(goal account import -m "$ACCOUNT_MNEMONICS") 
    export ACCOUNT_ADDRESS=${account_import_response:9}

    export CATCHUP=$(curl https://algorand-catchpoints.s3.us-east-2.amazonaws.com/channel/$NETWORK/latest.catchpoint)
    goal node catchup $CATCHUP

    # make sure it caught up before continue
    sleep 60
    until goal node status | grep "Last Catchpoint"; do sleep 60; done

    goal account addpartkey --address $ACCOUNT_ADDRESS --roundFirstValid=$FIRST_ROUND --roundLastValid=$LAST_ROUND
    
    goal account changeonlinestatus --address $ACCOUNT_ADDRESS --online=true --txfile=online.txn

    goal clerk sign --infile="online.txn" --outfile="online.stxn"

    goal clerk rawsend -f online.stxn
fi