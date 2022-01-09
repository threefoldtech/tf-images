FROM ubuntu:latest

LABEL maintainer="abdul@incubaid.com"
WORKDIR /opt

# Set Env
ENV DEBIAN_FRONTEND noninteractive
ENV DEBCONF_NONINTERACTIVE_SEEN true
ENV POLKA_DOT_RELEASE=0.9.8

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
RUN mkdir -pv /polkadot
RUN wget --no-check-certificate https://github.com/paritytech/polkadot/releases/download/v${POLKA_DOT_RELEASE}/polkadot

# Set Polka/Parity Configuration
COPY config/cronjobs /opt
COPY config/init /tmp/
COPY scripts/start_polkadot /
COPY scripts/check* /usr/bin/
COPY config/polkadot /var/www/html/

# Set Parity/Polkadot Startup Script
ENTRYPOINT ["/start_polkadot"]
VOLUME /polkadot
WORKDIR /polkadot

# Open P2P, RPC & WS Port
EXPOSE 30333 9933 9944
