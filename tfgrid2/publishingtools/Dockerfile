FROM threefoldtech/phusion:19.10
RUN apt update && apt install -y build-essential curl libevent-dev libssl-dev libxml2-dev libyaml-dev libgmp-dev git libssh2.1 libssh2.1-dev
RUN curl -sSL https://dist.crystal-lang.org/apt/setup.sh | bash
RUN curl -sL "https://keybase.io/crystal/pgp_keys.asc" | apt-key add -
RUN echo "deb https://dist.crystal-lang.org/apt crystal main" | tee /etc/apt/sources.list.d/crystal.list
RUN apt-get update
RUN apt install -y crystal
RUN mkdir -p /sandbox/code/github/crystaluniverse/publishingtools
RUN git clone https://github.com/crystaluniverse/publishingtools.git /sandbox/code/github/crystaluniverse/publishingtools
WORKDIR /sandbox/code/github/crystaluniverse/publishingtools
RUN shards update crystaltools
RUN shards build
RUN cp bin/tfweb /usr/local/bin/
COPY start.sh /start.sh
COPY caddy /caddy
COPY trc /trc
RUN chmod +x /start.sh
RUN chmod +x /caddy
RUN chmod +x /trc
ENTRYPOINT ["/start.sh"]
