FROM ubuntu

ENV DEBIAN_FRONTEND=noninteractive

RUN apt update && apt -y install wget openssh-server

RUN wget https://github.com/prometheus/prometheus/releases/download/v2.33.5/prometheus-2.33.5.linux-amd64.tar.gz && \
    tar xvf /prometheus-2.33.5.linux-amd64.tar.gz && \
    useradd --no-create-home --shell /bin/false prometheus && \
    mv /prometheus-2.33.5.linux-amd64/prometheus /usr/local/bin/ && \
    chown prometheus:prometheus /usr/local/bin/prometheus && \
    mkdir /var/lib/prometheus && \
    chown prometheus:prometheus /var/lib/prometheus
    
RUN apt -y install adduser libfontconfig1 musl && \
    wget https://dl.grafana.com/enterprise/release/grafana-enterprise_11.1.3_amd64.deb && \
    dpkg -i grafana-enterprise_11.1.3_amd64.deb
    
RUN wget -O /sbin/zinit https://github.com/threefoldtech/zinit/releases/download/v0.2.5/zinit && \
    chmod +x /sbin/zinit

COPY rootfs .

ENTRYPOINT [ "/sbin/zinit", "init" ]