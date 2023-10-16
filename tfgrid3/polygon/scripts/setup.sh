#!/bin/bash

set -x 
rm -rf /root/node/setup.sh && cp /etc/scripts/setup_bor.sh /root/node/setup.sh
bash /root/node/setup.sh &&\
rm -rf /root/node/start.sh && cp /etc/scripts/bor_light_start.sh /root/node/start.sh