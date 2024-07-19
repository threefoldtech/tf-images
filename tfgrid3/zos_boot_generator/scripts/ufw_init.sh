#!/bin/bash

ufw default deny incoming
ufw default allow outgoing
ufw allow 80
ufw allow 443
ufw allow 22
ufw limit ssh