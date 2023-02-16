FROM ubuntu:20.04

RUN apt-get update && apt-get install -y \
    curl \
    gnupg \
    lsb-release \
    wget \
    apt-transport-https \
    ca-certificates \
    ufw \
    vim \
    openssh-server \
    software-properties-common \
    lsb-release && \
    # Docker
    curl -fsSL https://download.docker.com/linux/ubuntu/gpg | gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg && \
    echo "deb [arch=amd64 signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu \
    $(lsb_release -cs) stable" | tee /etc/apt/sources.list.d/docker.list > /dev/null && \
    # Docker-compose
    curl -L "https://github.com/docker/compose/releases/download/1.29.2/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose && \
    chmod +x /usr/local/bin/docker-compose && \
    # Zinit
    wget -O /sbin/zinit https://github.com/threefoldtech/zinit/releases/download/v0.2.5/zinit && \
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
    curl -1sLf 'https://dl.cloudsmith.io/public/caddy/stable/gpg.key' | tee /etc/apt/trusted.gpg.d/caddy-stable.asc &&\
    curl -1sLf 'https://dl.cloudsmith.io/public/caddy/stable/debian.deb.txt' | tee /etc/apt/sources.list.d/caddy-stable.list &&\
    curl https://dl.cloudsmith.io/public/caddy/stable/gpg.key | gpg --yes --dearmor --output /usr/share/keyrings/caddy-stable-archive-keyring.gpg &&\
    echo 'deb [signed-by=/usr/share/keyrings/caddy-stable-archive-keyring.gpg] https://dl.cloudsmith.io/public/caddy/stable/deb/debian any-version main' | tee /etc/apt/sources.list.d/caddy-stable.list && \
    # Update and install all required packages.
    apt-get update --fix-missing && \
    DEBIAN_FRONTEND=noninteractive TZ=Europe/Belgium \
    apt-get -y install -y \
    webmin \
    docker-ce \
    docker-ce-cli \
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