FROM debian:12

RUN apt update && \
  apt -y install wget openssh-server

RUN wget -O /sbin/zinit https://github.com/threefoldtech/zinit/releases/download/v0.2.5/zinit && \
  chmod +x /sbin/zinit

COPY zinit /etc/zinit
COPY entrypoint.sh /entrypoint.sh

RUN chmod +x /sbin/zinit && chmod +x /entrypoint.sh
ENTRYPOINT  ["zinit", "init"]