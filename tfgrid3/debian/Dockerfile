FROM debian:12

ENV DEBIAN_FRONTEND=noninteractive 

RUN apt update
RUN apt install openssh-server -y

COPY entrypoint.sh /
RUN chmod +x /entrypoint.sh
RUN rm -f /run/nologin
RUN /bin/echo -e "LANG=\"en_US.UTF-8\"">/etc/default/local

ENTRYPOINT ["/entrypoint.sh"]