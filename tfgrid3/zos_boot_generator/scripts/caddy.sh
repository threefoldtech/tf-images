#!/bin/bash

caddy reverse-proxy -r --from ${DOMAIN} --to :5555