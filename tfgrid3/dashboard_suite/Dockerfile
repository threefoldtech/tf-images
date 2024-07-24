FROM ubuntu:22.04

RUN apt update && \
  apt install -y git ufw openssh-server pv

RUN wget -O /sbin/zinit https://github.com/threefoldtech/zinit/releases/download/v0.2.5/zinit && \
  chmod +x /sbin/zinit

RUN wget -O /sbin/caddy 'https://caddyserver.com/api/download?os=linux&arch=amd64&p=github.com%2Fcaddyserver%2Freplace-response&idempotency=43631173212363' && \
  chmod +x /sbin/caddy

RUN curl -fsSL https://get.docker.com -o /usr/local/bin/install-docker.sh && \
  chmod +x /usr/local/bin/install-docker.sh

RUN sh /usr/local/bin/install-docker.sh

RUN mkdir -p /mnt/disk/code && \
  cd /mnt/disk/code && \
  git clone https://github.com/threefoldtech/grid_deployment

RUN mkdir -p /mnt/disk/docker

COPY ./Caddyfile /etc/caddy/
COPY ./scripts/ /scripts/
COPY ./zinit/ /etc/zinit/
RUN chmod +x /scripts/*.sh

ENTRYPOINT ["/sbin/zinit", "init"]