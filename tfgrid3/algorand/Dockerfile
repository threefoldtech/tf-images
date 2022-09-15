
FROM ubuntu:20.04

ENV DEBIAN_FRONTEND=noninteractive

RUN apt update && \
    apt -y install wget curl vim net-tools iputils-ping openssh-server

RUN wget -O /sbin/zinit https://github.com/threefoldtech/zinit/releases/download/v0.2.5/zinit && \
    chmod +x /sbin/zinit

ENV ALGORAND_DATA=/var/lib/algorand
RUN echo export ALGORAND_DATA=/var/lib/algorand >> ~/.bashrc

RUN curl -O https://releases.algorand.com/key.pub &&\
    apt-get update &&\
    apt-get install -y gnupg2 software-properties-common &&\
    apt-key add key.pub &&\
    add-apt-repository "deb [arch=amd64] https://releases.algorand.com/deb/ stable main" &&\
    apt-get update &&\
    apt-get install -y algorand-devtools algorand

RUN apt update && \
    apt -y install expect 

COPY exp /exp
RUN chmod -R +x /exp

RUN mkdir -p /etc/zinit
COPY ps /etc/zinit

ENTRYPOINT [ "/sbin/zinit", "init" ]
