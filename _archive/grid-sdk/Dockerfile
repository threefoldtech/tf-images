FROM builders_jumpscale

# for pillow
RUN apk --no-cache add jpeg-dev zlib-dev libjpeg
# for sdk
RUN apk --no-cache add tmux redis nginx
# install sdk
RUN mkdir -p /myhost/code
RUN cd /myhost/code && git clone https://github.com/threefoldtech/js-sdk && \
    cd js-ng && /root/.poetry/bin/poetry install && cd .. && \
    cd js-sdk && /root/.poetry/bin/poetry install

ADD boot.sh /usr/local/bin
RUN chmod 770 /usr/local/bin/boot.sh

EXPOSE 22

RUN echo 'THREEFOLD GRID SDK DEV ENV WELCOMES YOU' > /etc/motd

ENTRYPOINT ["/usr/bin/dumb-init", "--"]
CMD ["/usr/local/bin/boot.sh"]
