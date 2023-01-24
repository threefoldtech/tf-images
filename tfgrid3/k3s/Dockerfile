FROM ubuntu:20.04
RUN export DEBIAN_FRONTEND=noninteractive && apt-get -qy update && \
    apt-get -qy install wget ssh iproute2 && \
    wget --progress=bar:force:noscroll -O /sbin/k3s https://github.com/k3s-io/k3s/releases/download/v1.26.0+k3s1/k3s && \
    chmod +x /sbin/k3s && \
    wget --progress=bar:force:noscroll -O /sbin/kubectl https://dl.k8s.io/release/v1.26.0/bin/linux/amd64/kubectl && \
    chmod +x /sbin/kubectl && \
    wget --progress=bar:force:noscroll -O /sbin/zinit https://github.com/threefoldtech/zinit/releases/download/v0.2.10/zinit && \
    chmod +x /sbin/zinit && \
    apt-get -qy remove wget && apt-get -qy autoremove && \
    rm -rf /var/lib/apt/lists/* && rm -rf /build/* && unset DEBIAN_FRONTEND

COPY rootfs /
COPY scripts /scripts
RUN chmod +x /scripts/*
COPY manifests /var/lib/rancher/k3s/server/manifests/
ENV KUBECONFIG="/etc/rancher/k3s/k3s.yaml"

ENTRYPOINT [ "zinit", "init" ]
