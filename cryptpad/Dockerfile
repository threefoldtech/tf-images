FROM gcrkrause/cryptpad
USER root
RUN apt-get update
RUN apt-get install -y openssh-client openssh-server
COPY start.sh /start.sh
RUN chmod +x /start.sh
COPY config.js /cryptpad/config/config.js
ENTRYPOINT ["/start.sh"]
