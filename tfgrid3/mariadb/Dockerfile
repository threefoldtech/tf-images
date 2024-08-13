FROM mariadb

ENV DEBIAN_FRONTEND=noninteractive
RUN apt update && apt -y install wget openssh-server

RUN wget https://github.com/prometheus/node_exporter/releases/download/v1.8.2/node_exporter-1.8.2.linux-amd64.tar.gz && \
    tar xvfz node_exporter-1.8.2.linux-amd64.tar.gz && \
    mv node_exporter-1.8.2.linux-amd64/node_exporter /usr/local/bin

RUN wget https://github.com/prometheus/mysqld_exporter/releases/download/v0.15.1/mysqld_exporter-0.15.1.linux-amd64.tar.gz && \
    tar xvfz mysqld_exporter-0.15.1.linux-amd64.tar.gz && \
    mv mysqld_exporter-0.15.1.linux-amd64/mysqld_exporter /usr/local/bin
    
RUN wget -O /sbin/zinit https://github.com/threefoldtech/zinit/releases/download/v0.2.5/zinit && chmod +x /sbin/zinit
COPY rootfs /

EXPOSE 9500 9501
ENTRYPOINT [ "/sbin/zinit", "init" ]
