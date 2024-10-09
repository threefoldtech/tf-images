#!/bin/bash

# Script to download the latest version of tfrobot if version was not passed as env variable

download_latest_tfrobot() {
    echo "No version provided, downloading the latest version..."
    tf_v=$(curl -s https://api.github.com/repos/threefoldtech/tfgrid-sdk-go/releases/latest | grep 'tag_name' | cut -d '"' -f 4)
    echo "Downloading latest version: $tf_v"
    wget -O "Latest.tar.gz" "https://github.com/threefoldtech/tfgrid-sdk-go/releases/download/${tf_v}/tfgrid-sdk-go_Linux_x86_64.tar.gz"
    tar -xzf Latest.tar.gz -C /usr/local/bin/
    rm -rf /Latest.tar.gz
    echo "tfrobot version ${tf_v} installed successfully."
}

# Check if a version was provided as an argument
if [ -z "$1" ]; then
    echo "No version argument provided."
    download_latest_tfrobot
else
    tf_v=$1
    echo "Downloading specified version: ${tf_v}..."
    wget -O "tfrobot_version.tar.gz" "https://github.com/threefoldtech/tfgrid-sdk-go/releases/download/${tf_v}/tfgrid-sdk-go_Linux_x86_64.tar.gz"
    tar -xzf tfrobot_version.tar.gz -C /usr/local/bin/
    rm -rf /tfrobot_version.tar.gz
    echo "tfrobot version ${tf_v} installed successfully."
fi
