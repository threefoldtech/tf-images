FROM builders_base
RUN rm  -rf /tmp/* /var/cache/apk/*
RUN apk add --no-cache crystal crystal-bash-completion shards
RUN echo 'CRYSTAL LANG DEV ENV WELCOMES YOU' > /etc/motd
ENTRYPOINT ["/usr/bin/dumb-init", "--"]

CMD ["/usr/local/bin/boot.sh"]
