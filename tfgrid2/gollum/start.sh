#!/bin/sh

# enable ssh
mkdir ~/.ssh
mkdir -p /var/run/sshd
chmod 600 ~/.ssh
chmod 600 /etc/ssh/*
touch ~/.ssh/authorized_keys
chmod 600 ~/.ssh/authorized_keys
echo $pub_key >> ~/.ssh/authorized_keys
chmod 600 ~/.ssh/authorized_keys
service ssh start

# certbot ssl certificate
sed -i "s/domain_name/$1/g" /etc/nginx/sites-available/gollum.conf
ln -s /etc/nginx/sites-available/gollum.conf /etc/nginx/sites-enabled/gollum.conf
certbot --nginx -n -m "$2" --agree-tos --domains "$1" 
service nginx start

# setup github repo
git clone https://$GITHUB_TOKEN@github.com/$GITHUB_USER/$GITHUB_REPO.git
cd $GITHUB_REPO/
git config user.name $GITHUB_USER
git config user.email $GITHUB_EMAIL
cp /tmp/config.rb .
cp /tmp/post-commit .git/hooks/
chmod +x .git/hooks/post-commit

# start gollum
gollum --port 8443 --config config.rb
