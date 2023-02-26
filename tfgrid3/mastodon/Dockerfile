FROM ubuntu:20.04

RUN apt-get update && apt-get install -y \
    gnupg \
    lsb-release \
    wget \
    apt-transport-https \
    ca-certificates \
    ufw \
    openssh-server \
    software-properties-common \
    lsb-release && \
    # Docker
    wget -qO- https://download.docker.com/linux/ubuntu/gpg | gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg && \
    echo "deb [arch=amd64 signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | tee /etc/apt/sources.list.d/docker.list >/dev/null && \
    # Zinit
    wget -O /sbin/zinit https://github.com/threefoldtech/zinit/releases/download/v0.2.10/zinit && \
    chmod +x /sbin/zinit && \
    # Webmin
    wget -q http://www.webmin.com/jcameron-key.asc -O- | apt-key add - && \
    add-apt-repository "deb [arch=amd64] http://download.webmin.com/download/repository sarge contrib" && \
    # Codeserver
    wget https://github.com/cdr/code-server/releases/download/v3.3.1/code-server-3.3.1-linux-amd64.tar.gz &&\
    tar -xzvf code-server-3.3.1-linux-amd64.tar.gz &&\
    cp -r code-server-3.3.1-linux-amd64 /usr/lib/code-server &&\
    ln -s /usr/lib/code-server/bin/code-server /usr/bin/code-server &&\
    mkdir /var/lib/code-server && \
    # Cady 
    wget -qO - https://dl.cloudsmith.io/public/caddy/stable/gpg.key | apt-key add - && \
    echo "deb [trusted=yes] https://dl.cloudsmith.io/public/caddy/stable/deb/debian any-version main" | tee -a /etc/apt/sources.list.d/caddy-stable.list && \
    # Update and install all required packages.
    apt-get update && \
    DEBIAN_FRONTEND=noninteractive TZ=Europe/Belgium \
    apt-get -y install \
    webmin \
    docker-ce \
    docker-ce-cli \
    docker-compose-plugin \
    containerd.io \
    iproute2 \
    htop \
    net-tools \
    rsync \
    mc \ 
    mcedit \
    cron \
    libsocket6-perl \
    caddy && \
    apt-get -y remove wget && \
    rm -rf /var/lib/apt/lists/*

COPY ./scripts/ /scripts/
COPY ./zinit/ /etc/zinit/
COPY ./docker /docker/
COPY Caddyfile /etc/caddy/Caddyfile
RUN chmod +x /scripts/*.sh

ENTRYPOINT  ["zinit", "init"]

# mastodon
EXPOSE 3000
# code-server
EXPOSE 8001
# webmin
EXPOSE 8002