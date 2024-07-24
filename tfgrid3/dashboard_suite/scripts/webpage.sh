#!/bin/bash

mkdir -p /tmp/webpage

echo '<h1>This is the start page for the Dashboard Suite Deployment. Refresh the page for updates</h1>' > /tmp/webpage/heading.html
touch /tmp/webpage/log

while true; do
  cat /tmp/webpage/heading.html > /tmp/webpage/index.html
  cat /tmp/webpage/log | sed "s/\r/\n/g" | tail -n 1 >> /tmp/webpage/index.html
  sleep 1
done