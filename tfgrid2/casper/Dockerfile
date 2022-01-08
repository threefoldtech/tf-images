FROM ubuntu:18.04

LABEL maintainer="abdul@incubaid.com"
WORKDIR /opt

# The version of current official release of Digibyte binary
ENV DEBIAN_FRONTEND noninteractive
ENV DEBCONF_NONINTERACTIVE_SEEN true

# Get Dependencies
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
        ;

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

# Set Digibyte Startup Script
ENTRYPOINT ["/start_casper"]
VOLUME /var/lib/casper
WORKDIR /var/lib/casper

# Open P2P & RPC Port
EXPOSE 35000 7777 8888 9999
