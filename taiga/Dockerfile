FROM  ubuntu:latest

RUN apt-get update \
&& DEBIAN_FRONTEND=noninteractive apt-get install -y \
build-essential binutils-doc autoconf flex bison \
libjpeg-dev libfreetype6-dev \
zlib1g-dev libzmq3-dev libgdbm-dev libncurses5-dev automake libtool \
curl git tmux gettext sudo \ 
nginx rabbitmq-server redis-server \
postgresql \
python3 python3-pip python3-dev virtualenv virtualenvwrapper \
libxml2-dev libxslt-dev libssl-dev libffi-dev

RUN pip3 install libtmux

# Create taiga user
RUN adduser taiga
RUN adduser taiga sudo
RUN sudo passwd -d taiga

####BACK-END INSTALLATION####
#Clone taiga-backend
RUN mkdir /taiga \
&& cd /taiga \
&& git clone https://github.com/taigaio/taiga-back.git --branch stable taiga-back

#Create virtualenv {taiga}
RUN su taiga \
&& cd /taiga/taiga-back \
&& sudo virtualenv -p /usr/bin/python3 taiga


####FRONT-END INSTALLATION####
#Clone taiga-frontend
RUN cd /taiga \
&& git clone https://github.com/taigaio/taiga-front-dist.git --branch stable taiga-front-dist \
&& cp /taiga/taiga-front-dist/dist/conf.example.json /taiga/taiga-front-dist/dist/conf.json


####Events INSTALLATION####
#Clone taiga-events
RUN cd /taiga \
&& git clone https://github.com/taigaio/taiga-events.git --branch master taiga-events
#Install nodejs and js dependencies
RUN su taiga \
&& cd /taiga/taiga-events \
&& curl -sL https://deb.nodesource.com/setup_8.x | sudo -E bash - \
&& sudo apt-get install -y nodejs \
&& npm install \
&& sudo npm audit fix -f\
&& npm install \
&& cp config.example.json config.json

RUN chown taiga:taiga /taiga -R

# COPY docker-entrypoint.sh /usr/local/bin/

# Copy required config files and docker entry_point
COPY root/cfg/media_conf.py /taiga/taiga-back/settings/local.py
COPY root/cfg/taiga.conf /etc/nginx/conf.d/taiga.conf

COPY root/opt/bin /opt/bin
EXPOSE 4321

ENTRYPOINT ["/bin/sh", "opt/bin/taiga_entry.sh"]
