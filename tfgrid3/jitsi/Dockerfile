
FROM ubuntu:20.04

ENV DEBIAN_FRONTEND=noninteractive

RUN apt update && \
    apt -y install wget curl vim net-tools iputils-ping openssh-server docker.io 

RUN curl -L "https://github.com/docker/compose/releases/download/1.29.2/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose && \
    chmod +x /usr/local/bin/docker-compose

RUN wget -O /sbin/zinit https://github.com/threefoldtech/zinit/releases/download/v0.2.5/zinit && \
    chmod +x /sbin/zinit
# RUN chmod +x /gen-passwords.sh 

RUN mkdir -p /etc/zinit

COPY zinit /etc/zinit

COPY docker-compose.yml /docker-compose.yml
COPY .env /.env
# RUN mkdir -p ~/.jitsi-meet-cfg/{web,transcripts,prosody/config,prosody/prosody-plugins-custom,jicofo,jvb,jigasi,jibri}


ENTRYPOINT [ "/sbin/zinit", "init" ]
