#!/bin/bash

service redis-server restart
service postgresql restart
service peertube start

sleep infinity