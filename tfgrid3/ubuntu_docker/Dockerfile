FROM ubuntu:20.04

ARG DEBIAN_FRONTEND=noninteractive

RUN apt update && apt upgrade -y && apt install mc curl git sudo tmux pen  htop sudo net-tools screen rsync -y
# RUN yes | unminimize

RUN apt install openssh-server -y &&\
    mkdir -p /root/.ssh/ &&\
    chmod 700 /root/.ssh &&\
    touch /root/.ssh/authorized_keys &&\
    chmod 600 /root/.ssh/authorized_keys 

ADD dockerinstall.sh /tmp/dockerinstall.sh

RUN bash /tmp/dockerinstall.sh

RUN apt-get autoremove && apt-get clean

COPY ./init.sh /init.sh
RUN chmod +x /init.sh

ENTRYPOINT ["/init.sh"]