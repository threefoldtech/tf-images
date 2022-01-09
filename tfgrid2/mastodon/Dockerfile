FROM tootsuite/mastodon
# install postgress and redis
USER root
RUN mkdir  -p /var/cache/apt/archives/partial
RUN apt update && apt install -y redis-server redis-tools \
	postgresql postgresql-contrib vim sudo git nginx net-tools && \
    apt install -y python3 python3-pip openssh-server && \
	rm -rf /var/cache && \
	rm -rf /var/lib/apt/lists/*
# install supervisor
RUN pip3 install supervisor

RUN echo 'mastodon ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers
RUN [ -d  /var/log ] || mkdir -p  /var/log
RUN rm /etc/nginx/sites-available/default
RUN rm /etc/nginx/sites-enabled/default
RUN mkdir /etc/supervisor/
COPY supervisor.conf /etc/supervisor/supervisord.conf
COPY mastodon.conf /etc/nginx/sites-available/mastodon
COPY start_mastodon.sh /start_mastodon.sh
EXPOSE 3000 4000
RUN chmod +x /start_mastodon.sh
RUN chmod 777 /etc/hosts
ENTRYPOINT ["/start_mastodon.sh"]
