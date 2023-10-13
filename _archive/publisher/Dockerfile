FROM builders_vlang AS builder

RUN rm  -rf /tmp/* /var/cache/apk/*

WORKDIR /opt/vlang

ENV VVV  /opt/vlang
ENV PATH /opt/vlang:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin
ENV VFLAGS -cc gcc


RUN --mount=type=ssh ssh-add -l

RUN --mount=type=ssh mkdir -p /opt

RUN mkdir -p -m 0600 ~/.ssh && ssh-keyscan github.com >> ~/.ssh/known_hosts

RUN --mount=type=ssh git clone git@github.com:crystaluniverse/vlang_tools.git /opt/vlangtools

# RUN cd /opt/vlangtools && ./build.sh

#to test do:
#export VFLAGS=-cc gcc

# FROM builders_base
# RUN mkdir -p /out
# COPY --from=builder /opt/v/v /vlang/v
# RUN /vlang/v -version

RUN echo 'PUBLISHER DEV ENV WELCOMES YOU' > /etc/motd

ENTRYPOINT ["/usr/bin/dumb-init", "--"]

# CMD ["/usr/local/bin/boot.sh"]
