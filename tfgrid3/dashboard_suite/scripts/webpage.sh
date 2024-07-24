#!/bin/bash

mkdir -p /mnt/disk/tmp/webpage

echo '<h1>This is the start page for the Dashboard Suite Deployment. Refresh the page for updates</h1>' > /mnt/disk/tmp/webpage/heading.html
touch /mnt/disk/tmp/webpage/log

while true; do
  cat /mnt/disk/tmp/webpage/heading.html > /mnt/disk/tmp/webpage/index.html
  cat /mnt/disk/tmp/webpage/log | sed "s/\r/\n/g" | tail -n 1 >> /mnt/disk/tmp/webpage/index.html
  sleep 1
done