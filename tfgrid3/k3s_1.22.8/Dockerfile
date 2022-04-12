FROM ubuntu:latest
 
RUN apt-get update && apt-get upgrade --no-install-recommends -y && apt-get install --no-install-recommends -y openssh-server wget ca-certificates iptables ebtables iproute2 nano vim ipset conntrack
RUN mkdir -p /opt/k3s /etc/zinit && cd /opt/k3s && wget --no-check-certificate https://github.com/k3s-io/k3s/releases/download/v1.22.8%2Bk3s1/k3s
COPY entrypoint.sh /
COPY zinit /sbin
COPY init.yaml /etc/zinit
RUN chmod 700 /entrypoint.sh /opt/k3s/k3s /sbin/zinit
ENTRYPOINT ["/sbin/zinit", "init"]
