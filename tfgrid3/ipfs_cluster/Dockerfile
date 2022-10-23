
FROM ubuntu:22.04

WORKDIR /build

RUN export DEBIAN_FRONTEND=noninteractive && apt-get -y update && \
    apt-get -y install wget openssh-server && \
    wget -O /sbin/zinit https://github.com/threefoldtech/zinit/releases/download/v0.2.9/zinit && \
    wget https://dist.ipfs.tech/kubo/v0.16.0/kubo_v0.16.0_linux-amd64.tar.gz && \
    wget https://dist.ipfs.tech/ipfs-cluster-service/v1.0.4/ipfs-cluster-service_v1.0.4_linux-amd64.tar.gz && \
    wget https://dist.ipfs.io/ipfs-cluster-ctl/v1.0.4/ipfs-cluster-ctl_v1.0.4_linux-amd64.tar.gz && \
    for file in *.tar.gz; do tar xzvf "${file}" && rm "${file}"; done && \
    chmod +x /sbin/zinit && \
    mv ./kubo/ipfs ./ipfs-cluster-service/ipfs-cluster-service ./ipfs-cluster-ctl/ipfs-cluster-ctl /usr/bin && \
    apt-get -y remove wget && apt-get -y autoremove && rm -rf /var/lib/apt/lists/* && rm -rf /build/*

RUN mkdir -p /etc/zinit

COPY zinit /etc/zinit

ENTRYPOINT [ "/sbin/zinit", "init" ]