FROM ubuntu:20.04

ARG DEBIAN_FRONTEND=noninteractive

RUN apt update &&\
    apt -y install apt-transport-https ca-certificates software-properties-common sudo curl openssh-server

RUN curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add - &&\
    sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu focal stable"

RUN apt update &&\
    apt -y install docker-ce docker-ce-cli containerd.io &&\
    apt-cache madison docker-ce

RUN mkdir -p /root/.ssh/ &&\
    chmod 700 /root/.ssh &&\
    touch /root/.ssh/authorized_keys &&\
    chmod 600 /root/.ssh/authorized_keys &&\
    mkdir -p /var/run/sshd

COPY ./init.sh /.init.sh
RUN chmod +x /.init.sh

ENTRYPOINT [ "/.init.sh" ]