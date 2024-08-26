FROM ubuntu:22.04

ENV DEBIAN_FRONTEND=noninteractive

RUN apt update && \
  apt -y install wget openssh-server

RUN wget -O /sbin/zinit https://github.com/threefoldtech/zinit/releases/download/v0.2.5/zinit && \
  chmod +x /sbin/zinit

COPY zinit /etc/zinit
COPY start.sh /start.sh

RUN chmod +x /sbin/zinit && chmod +x /start.sh

COPY scripts /root/scripts

RUN chmod +x /root/scripts/*.sh

RUN /root/scripts/init.sh

ENTRYPOINT  ["zinit", "init"]