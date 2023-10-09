FROM ubuntu:20.04

ENV DEBIAN_FRONTEND=noninteractive

RUN apt update && \
    apt -y install wget ca-certificates curl gnupg openssh-server unzip iproute2 netcat

RUN wget https://releases.hashicorp.com/nomad/1.6.2/nomad_1.6.2_linux_amd64.zip && unzip nomad_1.6.2_linux_amd64.zip && \
    mv nomad /usr/bin && rm nomad_1.6.2_linux_amd64.zip

RUN install -m 0755 -d /etc/apt/keyrings

RUN curl -fsSL https://download.docker.com/linux/ubuntu/gpg | gpg --dearmor -o /etc/apt/keyrings/docker.gpg

RUN chmod a+r /etc/apt/keyrings/docker.gpg

RUN echo \
  "deb [arch="$(dpkg --print-architecture)" signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
  "$(. /etc/os-release && echo "$VERSION_CODENAME")" stable" | \
  tee /etc/apt/sources.list.d/docker.list > /dev/null

RUN apt update

RUN apt install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin -y

RUN wget -O /sbin/zinit https://github.com/threefoldtech/zinit/releases/download/v0.2.12/zinit && \
    chmod +x /sbin/zinit

RUN mkdir -p /etc/zinit
COPY ps /etc/zinit

ENTRYPOINT [ "/sbin/zinit", "init" ]
