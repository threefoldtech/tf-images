FROM ubuntu:20.04

ENV DEBIAN_FRONTEND=noninteractive

RUN apt update && \
    apt -y install wget openssh-server unzip netcat

RUN wget https://releases.hashicorp.com/nomad/1.6.2/nomad_1.6.2_linux_amd64.zip && unzip nomad_1.6.2_linux_amd64.zip && \
    mv nomad /usr/bin && rm nomad_1.6.2_linux_amd64.zip

RUN wget -O /sbin/zinit https://github.com/threefoldtech/zinit/releases/download/v0.2.12/zinit && \
    chmod +x /sbin/zinit

RUN mkdir -p /etc/zinit
COPY ps /etc/zinit

ENTRYPOINT [ "/sbin/zinit", "init" ]
