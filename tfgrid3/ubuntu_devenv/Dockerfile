FROM ubuntu:20.04

ARG DEBIAN_FRONTEND=noninteractive

RUN apt update && apt upgrade -y && apt install mc curl git sudo tmux pen htop sudo net-tools screen rsync unzip vim -y
# RUN yes | unminimize

# INSTALL VLANG & PUBLISH TOOLS
RUN curl https://raw.githubusercontent.com/freeflowuniverse/crystaltools/development/install.sh > /tmp/install.sh
ENV TERM=xterm
RUN bash /tmp/install.sh

# INSTALL RMB and VGrid
RUN v install --git https://github.com/threefoldtech/rmb
RUN v install --git https://github.com/threefoldtech/vgrid

SHELL ["/bin/bash", "-c"]
RUN source /root/env.sh
# ENV PUBSITE=https://github.com/threefoldfoundation/info_threefold_pub/tree/development/wiki_config
# RUN cd /root && publishtools flatten 

RUN curl -fsSL https://code-server.dev/install.sh | sh

RUN apt install openssh-server -y &&\
    mkdir -p /root/.ssh/ &&\
    chmod 700 /root/.ssh &&\
    touch /root/.ssh/authorized_keys &&\
    chmod 600 /root/.ssh/authorized_keys     

RUN curl -LO https://dl.google.com/go/go1.17.6.linux-amd64.tar.gz &&\
    rm -rf /usr/local/go && tar -C /usr/local -xzf go1.17.6.linux-amd64.tar.gz &&\
    mkdir -p $HOME/go/{bin,src} 

# Install node v16
# Install yarn and grid3_client as global lib.
RUN curl -sL https://deb.nodesource.com/setup_16.x  | bash - &&\
    apt -y install nodejs &&\
    npm install -g yarn &&\
    npm install -g grid3_client

# Clone weblets_pocs, install packages and Build vserver
RUN cd && git clone -b development_poc2 https://github.com/threefoldtech/weblets_pocs.git &&\
    cd weblets_pocs/poc2/VServer && sh build_vserver.sh &&\
    cd ../VWeblet && npm install && npm run build

RUN cd /root/ &&\
    git clone -b development https://github.com/threefoldtech/weblets_pocs.git &&\
    cd weblets_pocs/poc1 && yarn install

# Download msgbus, extract it and move it to /usr/local/bin -- Using Go version for now
RUN curl -L https://github.com/threefoldtech/go-rmb/releases/download/v0.1.7/msgbusd.zip --output /tmp/msgbusd.zip &&\
    sudo unzip /tmp/msgbusd.zip -d /usr/local/bin

RUN sudo apt install -y debian-keyring debian-archive-keyring apt-transport-https &&\
    curl -1sLf 'https://dl.cloudsmith.io/public/caddy/stable/gpg.key' | sudo tee /etc/apt/trusted.gpg.d/caddy-stable.asc &&\
    curl -1sLf 'https://dl.cloudsmith.io/public/caddy/stable/debian.deb.txt' | sudo tee /etc/apt/sources.list.d/caddy-stable.list &&\
    sudo apt update &&\
    sudo apt install caddy

RUN apt-get autoremove && apt-get clean

COPY ./init.sh /init.sh
RUN chmod +x /init.sh

ENTRYPOINT ["/init.sh"]
