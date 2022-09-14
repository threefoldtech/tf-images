
FROM ubuntu:20.04

ENV DEBIAN_FRONTEND=noninteractive

RUN apt update && \
    apt -y install wget curl vim net-tools iputils-ping openssh-server tmux nano

RUN wget -O /sbin/zinit https://github.com/threefoldtech/zinit/releases/download/v0.2.5/zinit && \
    chmod +x /sbin/zinit

RUN wget https://dist.ipfs.io/go-ipfs/v0.10.0/go-ipfs_v0.10.0_linux-amd64.tar.gz && \
    tar -xvzf go-ipfs_v0.10.0_linux-amd64.tar.gz
RUN cd go-ipfs && bash install.sh
RUN ipfs init

RUN mkdir -p /etc/zinit
COPY ps /etc/zinit

ENTRYPOINT [ "/sbin/zinit", "init" ]