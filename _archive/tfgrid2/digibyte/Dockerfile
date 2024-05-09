FROM ubuntu:latest

LABEL maintainer="abdul@incubaid.com"
WORKDIR /opt

# The version of current official release of Digibyte binary
ENV DEBIAN_FRONTEND noninteractive
ENV DEBCONF_NONINTERACTIVE_SEEN true
ENV DIGIBYTE=7.17.2

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
	apache2 \
	php \
        ;

# Get the Binary from github
RUN wget --no-check-certificate https://github.com/digibyte/digibyte/releases/download/v${DIGIBYTE}/digibyte-${DIGIBYTE}-x86_64-linux-gnu.tar.gz
RUN tar -xvzf digibyte-${DIGIBYTE}-x86_64-linux-gnu.tar.gz && rm -f *.tar.gz && mv * dgb
RUN mkdir -pv /dgb
RUN ln -fs /usr/share/zoneinfo/Asia/Dubai /etc/localtime && dpkg-reconfigure -f noninteractive tzdata

# Set Digibyte Configuration
COPY config/digibyte.conf /opt
COPY config/cronjobs /opt
COPY config/init /tmp/
COPY scripts/start_dgb.sh /
COPY scripts/check* /usr/bin/
COPY config/digibyte /var/www/html/

# Set Digibyte Startup Script
ENTRYPOINT ["/start_dgb.sh"]
VOLUME /dgb
WORKDIR /dgb

# Open P2P & RPC Port
EXPOSE 12024 14022
