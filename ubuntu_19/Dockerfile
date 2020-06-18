FROM ubuntu:19.10
RUN apt-get update
RUN apt-get install -y openssh-client openssh-server
COPY start.sh /start.sh
RUN chmod +x /start.sh
ENTRYPOINT ["/start.sh"]

