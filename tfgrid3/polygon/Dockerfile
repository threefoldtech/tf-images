FROM golang:1.16 AS builder

SHELL ["/bin/bash", "-c"]

RUN apt update &&\
    apt -y install wget\
    git \
    curl \ 
    vim \
    net-tools \
    iputils-ping \
    openssh-server 

RUN cd src && git clone https://github.com/maticnetwork/bor &&\
    cd bor && git checkout v0.2.17 &&\
    make bor-all &&\
    mkdir /usr/bin/bor /usr/bin/bootnode &&\
    ln -nfs /go/src/bor/build/bin/bor /usr/bin/bor &&\
    ln -nfs /go1/src/bor/build/bin/bootnode /usr/bin/bootnode

RUN cd /root && git clone https://github.com/maticnetwork/launch &&\
    mkdir -p node/data

COPY scripts /etc/scripts

ENV BOR_DIR=/root/node

RUN echo export BOR_DIR=/root/node >> ~/.bashrc

RUN mkdir -p /etc/matic && chmod -R 777 /etc/matic/ && touch /etc/matic/metadata 

RUN wget -O /sbin/zinit https://github.com/threefoldtech/zinit/releases/download/v0.2.5/zinit && \
    chmod +x /sbin/zinit

RUN mkdir -p /etc/zinit

COPY zinit /etc/zinit

ENTRYPOINT [ "/sbin/zinit", "init" ]
# IMAGE_TAG: threefolddev/polygon:v1.0-all