#!/bin/bash

# Prefix to look for
PREFIX="GITEA__"

# The path to the .env file
ENV_FILE="/docker/.env"
# Making sure file is empty 
> "$ENV_FILE"

env > /tmp/env_export.txt

while IFS='=' read -r name value ; do
  if [[ $name == $PREFIX* ]]; then
    echo "$name='$value'" >> "$ENV_FILE"
  fi
done < /tmp/env_export.txt

# Cleanup the temp file
rm /tmp/env_export.txt

echo "GITEA environment variables saved to $ENV_FILE"
