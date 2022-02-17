FROM ubuntu:18.04

LABEL maintainer="abdul@incubaid.com"
WORKDIR /opt

ENV KNOWN_VALIDATOR_IP "3.14.161.135"

# The version of current official release of casperlabs binary
ENV DEBIAN_FRONTEND=noninteractive
ENV DEBCONF_NONINTERACTIVE_SEEN true


# Get Dependencies and zinit
RUN set -ex; \
    apt-get update; \
    apt-get install -y --no-install-recommends \
        wget \
        net-tools \
	cron \
	jq \
        curl \
        bash \
        iputils-ping \
        iproute2 \
        dnsutils \
        ca-certificates \
	apache2 \
	php \
        sudo \
        gnupg2 \
        logrotate \
        openssh-server \
        libssl-dev \
        libc6 \
        pkg-config \
        build-essential \
        cmake \
        make \
	netcat \
        dnsutils \
        software-properties-common \
        git \
        jq \
        ; \
    wget -O /sbin/zinit https://github.com/threefoldtech/zinit/releases/download/v0.2.5/zinit \
    && chmod +x /sbin/zinit \
    && mkdir -p /etc/zinit

COPY scripts /etc/zinit

# Set up Casper
COPY scripts/install_casper .
RUN /opt/install_casper
RUN mkdir -pv /casper
RUN ln -fs /usr/share/zoneinfo/Asia/Dubai /etc/localtime && dpkg-reconfigure -f noninteractive tzdata

# Set Casper Configuration
COPY config/cronjobs /opt
COPY config/init /tmp/
COPY scripts/start_casper /
COPY scripts/check* /usr/bin/
COPY config/casper /var/www/html/

# Set Casperlabs Startup Script
ENTRYPOINT ["/sbin/zinit", "init"]
VOLUME /var/lib/casper
WORKDIR /var/lib/casper

# Open P2P & RPC Port
EXPOSE 35000 7777 8888 9999
