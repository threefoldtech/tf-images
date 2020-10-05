FROM promasu/cryptpad 

USER root
RUN apt-get update
RUN apt-get install -y openssh-client openssh-server restic cron openssl curl;

# Volume for data persistence
VOLUME /persistent-data
WORKDIR /persistent-data

# Create directories
RUN mkdir blob block customize data datastore

COPY start.sh /start.sh
RUN chmod +x /start.sh
COPY config.js /cryptpad/config/config.js
COPY backup_init.sh /backup_init.sh
RUN chmod +x /backup_init.sh
ENTRYPOINT ["/start.sh"]
