FROM ubuntu:latest

LABEL maintainer="abdul@incubaid.com"
WORKDIR /opt

# The version of current official release of Dash binary
ENV DEBIAN_FRONTEND noninteractive
ENV DEBCONF_NONINTERACTIVE_SEEN true
ENV DASH=0.16.1.1

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

# Get the Binary from github // This link can change in the future
RUN wget --no-check-certificate https://github.com/dashpay/dash/releases/download/v${DASH}/dashcore-${DASH}-x86_64-linux-gnu.tar.gz
RUN tar -xvzf *.tar.gz && rm -f *.tar.gz && mv * dash

# Set Digibyte Data Directory
RUN mkdir -pv /dash
RUN ln -fs /usr/share/zoneinfo/Asia/Dubai /etc/localtime && dpkg-reconfigure -f noninteractive tzdata

# Set Dash Configuration
# Create dash.conf file
COPY config/dash.conf /opt
COPY scripts/start_dash.sh /
COPY config/cronjobs /opt
COPY config/init /tmp/
COPY scripts/check* /usr/bin/
COPY config/dash /var/www/html/

# Set Dash Startup Script
ENTRYPOINT ["/start_dash.sh"]
VOLUME /dash
WORKDIR /dash

# Open P2P & RPC Port
EXPOSE 9998 9999
