FROM ubuntu:20.04
RUN echo deb http://be.archive.ubuntu.com/ubuntu/ focal main restricted universe multiverse > /etc/apt/sources.list

RUN apt-get update
RUN apt-get install -y openssh-client openssh-server bind9-dnsutils iputils-ping curl wget iputils-tracepath iputils-arping
RUN apt install -y vim 
COPY start.sh /start.sh
RUN chmod +x /start.sh
ENTRYPOINT ["/start.sh"]
