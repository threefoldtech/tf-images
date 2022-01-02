FROM ubuntu:latest
 
RUN apt-get update && apt-get upgrade --no-install-recommends -y && apt-get install --no-install-recommends -y openssh-server wget ca-certificates iptables ebtables iproute2 nano vim ipset conntrack
RUN mkdir -p /etc/zinit && cd /usr/bin && wget --no-check-certificate https://github.com/k3s-io/k3s/releases/download/v1.21.8%2Bk3s1/k3s
COPY entrypoint.sh /
COPY zinit /sbin
COPY init.yaml /etc/zinit
RUN chmod 700 /entrypoint.sh /usr/bin//k3s /sbin/zinit
ENTRYPOINT ["/sbin/zinit", "init"]
