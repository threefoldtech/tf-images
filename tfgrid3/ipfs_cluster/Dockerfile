
FROM ubuntu:20.04

ENV DEBIAN_FRONTEND=noninteractive
ENV MULTIADDRESS=""

RUN apt update && \
    apt -y install wget curl vim net-tools iputils-ping openssh-server tmux nano
RUN wget -O /sbin/zinit https://github.com/threefoldtech/zinit/releases/download/v0.2.5/zinit && \
    chmod +x /sbin/zinit
RUN wget https://dist.ipfs.io/go-ipfs/v0.10.0/go-ipfs_v0.10.0_linux-amd64.tar.gz && \
    tar -xvzf go-ipfs_v0.10.0_linux-amd64.tar.gz
RUN wget https://dist.ipfs.io/ipfs-cluster-service/v1.0.4/ipfs-cluster-service_v1.0.4_linux-amd64.tar.gz && \
    tar xvfz ipfs-cluster-service_v1.0.4_linux-amd64.tar.gz 
RUN cp /ipfs-cluster-service/ipfs-cluster-service /bin
RUN wget https://dist.ipfs.io/ipfs-cluster-ctl/v1.0.4/ipfs-cluster-ctl_v1.0.4_linux-amd64.tar.gz && \
    tar xvfz ipfs-cluster-ctl_v1.0.4_linux-amd64.tar.gz
RUN cp /ipfs-cluster-ctl/ipfs-cluster-ctl /bin
RUN wget https://dist.ipfs.io/ipfs-cluster-follow/v1.0.4/ipfs-cluster-follow_v1.0.4_linux-amd64.tar.gz && \
    tar xvfz ipfs-cluster-follow_v1.0.4_linux-amd64.tar.gz
RUN cp /ipfs-cluster-follow/ipfs-cluster-follow /bin
RUN cd go-ipfs && bash install.sh
RUN mkdir -p /etc/zinit

COPY zinit /etc/zinit

ENTRYPOINT [ "/sbin/zinit", "init" ]