#!/bin/bash


# Create a system user to run Gitea
adduser --system --shell /bin/bash --gecos 'Git Version Control' --group --disabled-password --home /home/git git

# Download the latest Gitea binary
wget -O /usr/local/bin/gitea https://dl.gitea.io/gitea/1.15.5/gitea-1.15.5-linux-amd64

# Make the Gitea binary executable
chmod +x /usr/local/bin/gitea

# Create the required directory structure
mkdir -p /var/lib/gitea/{custom,data,log}
chown -R git:git /var/lib/gitea/
chmod -R 750 /var/lib/gitea/
mkdir /etc/gitea
chown root:git /etc/gitea
chmod 770 /etc/gitea

# # Initialize the Gitea configuration file
sudo -u git ./gitea web -c /etc/gitea/app.ini 

# # Create the Gitea SQLite database
# sudo -u git ./gitea migrate -c /etc/gitea/app.ini

