FROM ubuntu:latest

LABEL maintainer="abdul@incubaid.com"
WORKDIR /opt

# Set Env
ENV DEBIAN_FRONTEND noninteractive
ENV DEBCONF_NONINTERACTIVE_SEEN true

# Get Dependencies
RUN set -ex; \
    apt-get update; \
    apt-get install -y --no-install-recommends \
        wget \
	curl \
        net-tools \
	cron \
	jq \
        iputils-ping \
        iproute2 \
        dnsutils \
        tree \
	apache2 \
	php \
        ;

# Optionally set timezone
RUN ln -fs /usr/share/zoneinfo/Asia/Dubai /etc/localtime && dpkg-reconfigure -f noninteractive tzdata
RUN mkdir -pv /substrate

# Set Polka/Substrate Configuration
COPY config/cronjobs /opt
COPY config/init /tmp/
COPY scripts/start_substrate /
COPY scripts/check* /usr/bin/
COPY config/substrate /var/www/html/
COPY scripts/substrate .

# Set Parity/Substrate Startup Script
ENTRYPOINT ["/start_substrate"]
VOLUME /substrate
WORKDIR /substrate

# Open P2P, RPC & WS Port
EXPOSE 30333 9933 9944
