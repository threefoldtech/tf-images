FROM rancher/rancher:latest
RUN apt-get update && apt-get install -y wget ssh

RUN wget https://github.com/threefoldtech/zinit/releases/download/v0.1/zinit --no-check-certificate -O /sbin/zinit \
    && chmod +x /sbin/zinit

COPY rootfs /
COPY entrypoint.sh /
COPY manifests /var/lib/rancher/k3s/server/manifests/

ENTRYPOINT [ "zinit", "init" ]
