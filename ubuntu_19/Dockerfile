FROM ubuntu:19.10
RUN apt-get update
RUN echo deb http://be.archive.ubuntu.com/ubuntu/ eoan main restricted universe multiverse > /etc/apt/sources.list
RUN apt-get install -y openssh-client openssh-server
COPY start.sh /start.sh
RUN chmod +x /start.sh
ENTRYPOINT ["/start.sh"]

