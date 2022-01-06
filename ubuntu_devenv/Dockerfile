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

COPY ./start.sh /start.sh
RUN chmod +x /start.sh

ENTRYPOINT ["/start.sh"]
