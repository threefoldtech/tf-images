FROM ubuntu:18.04

ARG DEBIAN_FRONTEND=noninteractive

RUN apt-get update ; \
    apt-get install -y build-essential binutils-doc autoconf flex bison libjpeg-dev; \
    apt-get install -y libfreetype6-dev zlib1g-dev libzmq3-dev libgdbm-dev libncurses5-dev ; \
    apt-get install -y automake libtool curl git tmux gettext ; \
    apt-get install -y nginx postgresql ; \
    apt-get install -y rabbitmq-server redis-server ; \
    apt-get install -y python3 python3-pip python3-dev virtualenvwrapper; \
    apt-get install -y libxml2-dev libxslt-dev; \
    apt-get install -y libssl-dev libffi-dev; \
    apt-get install -y sudo openssh-server virtualenv python-pip vim zip nodejs npm

# install supervisor
RUN pip3 install supervisor

ARG GOROOT=/usr/local/go
ARG PATH=$GOROOT/bin:$PATH

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
    cp -p restic /usr/bin/restic; \
    rm -rf restic

# install nodejs and npm
RUN curl -sL https://deb.nodesource.com/setup_12.x | sudo -E bash -

# build postgres

# configure nginx
RUN rm /etc/nginx/sites-enabled/default
COPY nginx_conf  /etc/nginx/conf.d/taiga.conf
COPY start_circles.sh /.start_circles.sh
COPY setup_taiga.sh /.setup_taiga.sh
COPY prepare_taiga.sh /.prepare_taiga.sh
COPY supervisor.conf /etc/supervisor/supervisord.conf
COPY backup.sh /.backup.sh
COPY all_cron /.all_cron
COPY postgres_entry.sh /.postgres_entry.sh
COPY rabbitmq.sh  /.rabbitmq.sh 
RUN chmod +x /.*
ENTRYPOINT ["/.start_circles.sh"]

