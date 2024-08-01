#!/bin/bash

mkdir -p /storage/tmp/webpage

echo '<h1>This is the start page for the Dashboard Suite Deployment. Refresh the page for updates</h1>' > /storage/tmp/webpage/heading.html
touch /storage/tmp/webpage/log

while true; do
  cat /storage/tmp/webpage/heading.html > /storage/tmp/webpage/index.html
  cat /storage/tmp/webpage/log | sed "s/\r/\n/g" | tail -n 1 >> /storage/tmp/webpage/index.html
  sleep 1
done