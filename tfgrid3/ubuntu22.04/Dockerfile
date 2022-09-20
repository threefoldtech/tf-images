FROM ubuntu:22.04
RUN echo deb http://be.archive.ubuntu.com/ubuntu/ jammy main restricted universe multiverse > /etc/apt/sources.list
RUN apt update && \
  apt -y install wget curl vim net-tools iputils-ping openssh-client openssh-server docker.io

RUN wget -O /sbin/zinit https://github.com/threefoldtech/zinit/releases/download/v0.2.5/zinit && \
  chmod +x /sbin/zinit

COPY zinit /etc/zinit
COPY start.sh /start.sh

RUN chmod +x /sbin/zinit && chmod +x /start.sh
ENTRYPOINT  ["zinit", "init"]