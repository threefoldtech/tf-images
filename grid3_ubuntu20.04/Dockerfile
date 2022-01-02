FROM ubuntu:20.04
RUN echo deb http://be.archive.ubuntu.com/ubuntu/ focal main restricted universe multiverse >> /etc/apt/sources.list
RUN apt-get update && DEBIAN_FRONTEND=noninteractive TZ=Europe/Belgium apt-get install -y openssh-client openssh-server git && rm -rf /var/lib/apt/lists/*
COPY init.sh /init.sh
RUN chmod +x /init.sh
ENTRYPOINT ["/init.sh"]
