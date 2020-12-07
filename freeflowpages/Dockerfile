FROM ubuntu:18.04 AS builder

ARG GOROOT=/usr/local/go
ARG PATH=$GOROOT/bin:$PATH
RUN apt-get update
RUN apt-get install wget git -y 

# install latest go then restic
RUN set -ex; \
   wget https://dl.google.com/go/go1.13.7.linux-amd64.tar.gz; \
   tar -xvf go1.13.7.linux-amd64.tar.gz; \
    mv go /usr/local; \
    export PATH=$GOROOT/bin:$PATH ; \
    echo "export PATH=$GOROOT/bin:$PATH" >>  ~/.profile ; \
    git clone https://github.com/restic/restic; \
    cd restic; \
    go run build.go; \
    mv restic /usr/local/bin/restic

FROM ubuntu:18.04 

COPY --from=builder /usr/local/bin/restic /usr/local/bin/restic

ARG DEBIAN_FRONTEND=noninteractive
 
RUN apt-get update
RUN apt-get install lamp-server^ -y
RUN apt-get install php-curl php-gd php-mbstring -y
RUN apt-get install php-intl php-zip wget -y
RUN apt-get install php-ldap php-apcu php-sqlite3 php-imagick imagemagick -y
RUN apt-get install cron ssh telnet python3-pip -y
RUN apt-get install net-tools iputils-ping vim curl tmux rsync git -y
RUN apt-get install redis-server -y

# install supervisor
RUN pip3 install supervisor

COPY freeflowpages.com.conf /etc/apache2/sites-available/freeflowpages.com.conf

RUN set -ex ; \
    rm /etc/apache2/sites-enabled/000-default.conf ; \
    a2ensite freeflowpages.com.conf; \
    a2enmod rewrite

# below is setup of MySQL master node
COPY mysqld.cnf /etc/mysql/mysql.conf.d/mysqld.cnf

# change php file upload size settings to meet one in humhub, let set it to be 150M
RUN set -ex ; \
    sed -i 's/post_max_size.*/post_max_size = 150M/g;s/upload_max_filesize.*/upload_max_filesize = 150M/g' /etc/php/7.2/apache2/php.ini

COPY setup_ffp_script.sh /.setup_ffp_script.sh
COPY all_cron /.all_cron
COPY backup.sh /.backup.sh
COPY purge_backup.sh /.purge_backup.sh
COPY start_freeflowpages.sh /.start_freeflowpages.sh
COPY supervisor.conf /etc/supervisor/supervisord.conf 
RUN chmod +x /.*
ENTRYPOINT ["/.start_freeflowpages.sh"]
