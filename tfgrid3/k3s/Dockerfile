FROM ubuntu:20.04
RUN apt-get update && apt-get install -y wget ssh curl

RUN wget https://github.com/k3s-io/k3s/releases/download/v1.22.7+k3s1/k3s --no-check-certificate -O /sbin/k3s &&  \
   chmod +x /sbin/k3s

RUN curl -L -o /sbin/kubectl "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl" \
    && chmod +x /sbin/kubectl


RUN wget https://github.com/threefoldtech/zinit/releases/download/v0.2.6/zinit --no-check-certificate -O /sbin/zinit \
    && chmod +x /sbin/zinit

COPY rootfs /
COPY scripts /scripts
COPY manifests /var/lib/rancher/k3s/server/manifests/

ENTRYPOINT [ "zinit", "init" ]
