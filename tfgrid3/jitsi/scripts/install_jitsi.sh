#!/bin/bash

curl -sL https://prosody.im/files/prosody-debian-packages.key -o /etc/apt/keyrings/prosody-debian-packages.key
echo "deb [signed-by=/etc/apt/keyrings/prosody-debian-packages.key] http://packages.prosody.im/debian $(lsb_release -sc) main" | tee /etc/apt/sources.list.d/prosody-debian-packages.list
apt install lua5.2


curl -sL https://download.jitsi.org/jitsi-key.gpg.key | sh -c 'gpg --dearmor > /usr/share/keyrings/jitsi-keyring.gpg'
echo "deb [signed-by=/usr/share/keyrings/jitsi-keyring.gpg] https://download.jitsi.org stable/" | tee /etc/apt/sources.list.d/jitsi-stable.list

apt update

echo "jitsi-videobridge2 jitsi-videobridge/jvb-hostname string $(hostname)" | debconf-set-selections
echo "jitsi-meet jitsi-meet/cert-choice select Generate a new self-signed certificate" | debconf-set-selections

apt install jitsi-meet -y