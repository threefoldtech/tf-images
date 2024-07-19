FROM ubuntu:22.04

RUN dpkg --add-architecture i386

RUN apt update && \
  echo "2" | apt install -y python3-flask && \
  apt install -y mtools syslinux isolinux libc6-dev-i386 ufw \
  libc6-dbg:i386 git wget genisoimage liblzma-dev build-essential sqlite3

RUN wget -O /sbin/zinit https://github.com/threefoldtech/zinit/releases/download/v0.2.5/zinit && \
  chmod +x /sbin/zinit

RUN wget -O /sbin/caddy 'https://caddyserver.com/api/download?os=linux&arch=amd64&p=github.com%2Fcaddyserver%2Freplace-response&idempotency=43631173212363' && \
  chmod +x /sbin/caddy

COPY ./scripts/ /scripts/
COPY ./zinit/ /etc/zinit/
RUN chmod +x /scripts/*.sh

ENTRYPOINT ["/sbin/zinit", "init"]