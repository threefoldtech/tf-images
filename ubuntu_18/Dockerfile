FROM ubuntu:18.04
RUN apt-get update
RUN echo deb http://be.archive.ubuntu.com/ubuntu/ bionic main restricted universe multiverse > /etc/apt/sources.list
RUN apt-get install -y openssh-client openssh-server
COPY start.sh /start.sh
RUN chmod +x /start.sh
ENTRYPOINT ["/start.sh"]
