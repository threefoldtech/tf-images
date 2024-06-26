FROM ubuntu:20.04

ENV DEBIAN_FRONTEND=noninteractive

RUN apt update && \
    apt -y install wget curl vim net-tools iputils-ping openssh-server docker.io git nginx

RUN wget -O /sbin/zinit https://github.com/threefoldtech/zinit/releases/download/v0.2.14/zinit && \
    chmod +x /sbin/zinit

RUN mkdir -p /etc/zinit
COPY zinit /etc/zinit

RUN git clone https://github.com/threefoldtech/discourse_docker.git /var/discourse &&\
    cd /var/discourse &&\
    chmod 700 containers

COPY scripts /var/discourse
COPY nginx/* /etc/nginx/conf.d/
RUN  rm -rf /etc/nginx/sites-*

WORKDIR /var/discourse

EXPOSE 80 443

ENTRYPOINT [ "/sbin/zinit", "init" ]
