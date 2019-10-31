from ubuntu:18.04

ARG HUMHUB_VERSION=1.3.15

WORKDIR /var/www/html
RUN apt-get update ; apt install -y wget ;\
    wget https://www.humhub.org/en/download/package/humhub-${HUMHUB_VERSION}.tar.gz -q -O humhub.tar.gz && \
    tar xzf humhub.tar.gz && \
    mv humhub-${HUMHUB_VERSION} humhub && \
    rm humhub.tar.gz

WORKDIR /var/www/html/humhub

RUN chown -R www-data:www-data /var/www

ENV DEBIAN_FRONTEND noninteractive
RUN (apt-get update -y && apt-get -y upgrade)

RUN apt-get install lamp-server^ -y
RUN apt-get install php-curl php-gd php-mbstring -y
RUN apt-get install php-intl php-zip wget -y
RUN apt-get install php-ldap php-apcu php-sqlite3 php-imagick imagemagick -y
RUN apt-get install cron ssh telnet -y
RUN apt-get install net-tools iputils-ping vim curl tmux rsync git -y
RUN apt-get install restic  redis-server -y

COPY apache2_file /etc/apache2/sites-available/freeflowpages.com.conf

WORKDIR /etc/apache2/sites-available
RUN rm 000-default.conf
    RUN a2ensite freeflowpages.com.conf
RUN a2enmod rewrite

WORKDIR /var/www/html/humhub

# php env
ENV PHP_POST_MAX_SIZE=16M
ENV PHP_UPLOAD_MAX_FILESIZE=10M
ENV PHP_MAX_EXECUTION_TIME=60
ENV PHP_MEMORY_LIMIT=1G

# mysql root pass and humhub database
ENV MYSQL_ROOT_PASSWORD=rootpass
ENV HUMHUB_DATABASE=humhub
ENV HUMHUB_DB_USER=humhub
ENV HUMHUB_DB_USER_PASSWORD=humpass

COPY root/opt/bin /opt/bin

RUN chmod +x /opt/bin/*

ENTRYPOINT ["/opt/bin/humhub.sh" ]

EXPOSE 80