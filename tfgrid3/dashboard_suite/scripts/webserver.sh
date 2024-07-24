#!/bin/bash

mkdir -p /tmp/webserver

echo '<h1>This is the start page for the Dashboard Suite Deployment. Refresh the page for updates</h1>' > /tmp/webserver/heading.html
touch /tmp/webserver/log

while true; do
  cat /tmp/webserver/heading.html > /tmp/webserver/index.html
  cat /tmp/webserver/log | sed "s/\r/\n/g" | tail -n 1 >> /tmp/webserver/index.html
  sleep 1
done