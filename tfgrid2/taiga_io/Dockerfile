FROM ubuntu:18.04

ARG DEBIAN_FRONTEND=noninteractive

RUN apt-get update ; \
    apt-get install -y build-essential binutils-doc autoconf flex bison libjpeg-dev; \
    apt-get install -y libfreetype6-dev zlib1g-dev libzmq3-dev libgdbm-dev libncurses5-dev ; \
    apt-get install -y automake libtool curl git tmux gettext ; \
    apt-get install -y nginx postgresql ; \
    apt-get install -y rabbitmq-server redis-server ; \
    apt-get install -y python3 python3-pip python3-dev python3-venv virtualenvwrapper; \
    apt-get install -y libxml2-dev libxslt-dev; \
    apt-get install -y libssl-dev libffi-dev; \
    apt-get install -y sudo openssh-server vim zip nodejs npm restic cron; \
    pip3 install supervisor

# install nodejs and npm
RUN curl -sL https://deb.nodesource.com/setup_12.x | sudo -E bash -

# Cloning Repos
RUN mkdir -p /home/taiga && cd /home/taiga && git clone -b production https://github.com/threefoldtech/Threefold-Circles.git taiga-back
RUN wget https://raw.githubusercontent.com/threefoldtech/tf-images/master/circles/local.py -O /home/taiga/taiga-back/settings/local.py
RUN cd /home/taiga && git clone -b production https://github.com/threefoldtech/Threefold-Circles-front-dist.git taiga-front-dist
RUN wget https://raw.githubusercontent.com/threefoldtech/tf-images/master/circles/taiga-front-dist.conf -O /home/taiga/taiga-front-dist/dist/conf.json
RUN cd /home/taiga && git clone https://github.com/threefoldtech/Threefold-Circles-events.git taiga-events -b master

RUN useradd -d /home/taiga -s /bin/bash taiga && passwd -d taiga
RUN mkdir -p /home/taiga/.npm
RUN chown -R taiga:taiga /home/taiga 
RUN cd /home/taiga/taiga-events && su taiga -c "npm install && cp config.example.json config.json"

RUN virtualenv -p /usr/bin/python3 taiga
RUN chown -R taiga:taiga /taiga 

COPY prepare_taiga.sh /.prepare_taiga.sh
RUN su taiga -c "cd /home/taiga/taiga-back; /taiga/bin/pip3 install -r requirements.txt"

# configure nginx
RUN rm /etc/nginx/sites-enabled/default
COPY nginx_conf  /etc/nginx/conf.d/taiga.conf 
COPY nginx_conf  /tmp/taiga.conf 
COPY supervisor.conf /etc/supervisor/supervisord.conf
COPY postgres_entry.sh /.postgres_entry.sh
COPY rabbitmq.sh  /.rabbitmq.sh 
RUN chmod +x /.*

COPY backup_init.sh /backup_init.sh
RUN chmod +x /backup_init.sh

COPY start_taiga.sh /start_taiga.sh
RUN chmod +x /start_taiga.sh
ENTRYPOINT ["/start_taiga.sh"]

