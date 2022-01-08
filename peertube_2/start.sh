#!/bin/bash

service nginx restart
service redis-server restart
service postgresql restart
service peertube start

echo ">> All service Up."
echo ">> Sleep for debugging...."

sleep infinity