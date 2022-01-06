FROM ubuntu:20.04

ARG DEBIAN_FRONTEND=noninteractive

RUN apt update && apt upgrade -y && apt install mc curl git sudo -y
RUN yes | unminimize
RUN curl https://raw.githubusercontent.com/freeflowuniverse/crystaltools/development/install.sh > /tmp/install.sh

ENV TERM=xterm
RUN bash /tmp/install.sh

SHELL ["/bin/bash", "-c"]
RUN source /root/env.sh

ENV PUBSITE=https://github.com/threefoldfoundation/info_threefold_pub/tree/development/wiki_config
RUN cd /root && publishtools flatten 
RUN curl -fsSL https://code-server.dev/install.sh | sh

RUN apt install openssh-server -y &&\
    mkdir -p /root/.ssh/ &&\
    chmod 700 /root/.ssh &&\
    touch /root/.ssh/authorized_keys &&\
    chmod 600 /root/.ssh/authorized_keys 

RUN curl -LO https://dl.google.com/go/go1.17.6.linux-amd64.tar.gz &&\
    rm -rf /usr/local/go && tar -C /usr/local -xzf go1.17.6.linux-amd64.tar.gz &&\
    mkdir -p $HOME/go/{bin,src} 

RUN git clone https://github.com/vlang/v &&\
    cd v &&\
    make 

RUN curl -sL https://deb.nodesource.com/setup_14.x  | bash - &&\
    apt -y install nodejs &&\
    npm install -g yarn

RUN sudo apt install -y debian-keyring debian-archive-keyring apt-transport-https &&\
    curl -1sLf 'https://dl.cloudsmith.io/public/caddy/stable/gpg.key' | sudo tee /etc/apt/trusted.gpg.d/caddy-stable.asc &&\
    curl -1sLf 'https://dl.cloudsmith.io/public/caddy/stable/debian.deb.txt' | sudo tee /etc/apt/sources.list.d/caddy-stable.list &&\
    sudo apt update &&\
    sudo apt install caddy

COPY ./start.sh /start.sh
RUN chmod +x /start.sh

ENTRYPOINT ["/start.sh"]
