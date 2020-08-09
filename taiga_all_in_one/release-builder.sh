#!/usr/bin/env bash

###
# Move this script inside a freeflow-server Repo
# That you want to build a release from
# run the script, it will build it
###

apt install -y libzip-dev php php-fpm php-gd php-curl php-mbstring php-zip php-exif php-intl php-fileinfo php-imagick php-mysql php-zip php-xml php-apcu php-ldap php-sqlite3 imagemagick npm unzip  vim git wget grunt
npm install -g grunt-cli less

#git clone https://github.com/humhub/humhub.git /var/www/html/humhub
# git checkout tags/v1.3.11   # In case you want to checkout a revision first
#pushd /var/www/html/humhub
wget -c https://getcomposer.org/download/1.8.4/composer.phar
php composer.phar update --no-dev
php composer.phar install --no-dev
npm install
grunt build-assets
grunt build-theme
