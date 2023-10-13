FROM rustlang/rust:nightly-slim AS build

RUN apt-get update
RUN apt-get install -y build-essential clang

RUN cargo install sonic-server
RUN strip /usr/local/cargo/bin/sonic

FROM alpine:3.11.5

WORKDIR /usr/src/sonic

COPY --from=build /usr/local/cargo/bin/sonic /usr/local/bin/sonic

COPY sonic.toml /etc/sonic.cfg

RUN rm -rf /myhost/sonic && mkdir -p /myhost/sonic && cp /usr/local/bin/sonic /myhost/sonic/sonic && cp /etc/sonic.cfg /myhost/sonic/sonic.cfg

# CMD [ "sonic", "-c", "/etc/sonic.cfg" ]

RUN rm  -rf /tmp/* /var/cache/apk/*
RUN apk add --no-cache mc htop openssh dumb-init rsync
RUN  rm  -rf /tmp/* /var/cache/apk/*

ADD boot.sh /usr/local/bin

#make sure we get fresh keys
RUN rm -rf /etc/ssh/ssh_host_rsa_key /etc/ssh/ssh_host_dsa_key
RUN chmod 770 /usr/local/bin/boot.sh


EXPOSE 22
EXPOSE 1491

RUN echo 'THREEFOLD SONIC BUILD ENV WELCOMES YOU\n\n' > /etc/motd


ENTRYPOINT ["/usr/bin/dumb-init", "--"]

CMD ["/usr/local/bin/boot.sh"]

