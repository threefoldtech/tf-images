FROM ubuntu:20.04

RUN apt-get update && \
    apt-get install -y apt-transport-https ca-certificates curl gnupg lsb-release && \
    curl -fsSL https://download.docker.com/linux/ubuntu/gpg | gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg && \
    echo "deb [arch=amd64 signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu \
    $(lsb_release -cs) stable" |  tee /etc/apt/sources.list.d/docker.list > /dev/null && \
    apt-get update && \
    DEBIAN_FRONTEND=noninteractive TZ=Europe/Belgium apt-get install -y docker-ce docker-ce-cli containerd.io \
    openssh-server sudo ufw nano vim

RUN curl -L "https://github.com/docker/compose/releases/download/1.29.2/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose && \
    chmod +x /usr/local/bin/docker-compose

RUN wget -O /sbin/zinit https://github.com/threefoldtech/zinit/releases/download/v0.2.5/zinit && \
    chmod +x /sbin/zinit 

RUN apt-get update && \ 
    apt-get install -y iproute2 htop net-tools rsync mc mcedit

RUN apt-get update && apt-get install -y software-properties-common &&\
    wget -q http://www.webmin.com/jcameron-key.asc -O- | apt-key add - &&\
    add-apt-repository "deb [arch=amd64] http://download.webmin.com/download/repository sarge contrib" &&\
    apt-get update && apt-get install -y webmin

RUN wget https://github.com/cdr/code-server/releases/download/v3.3.1/code-server-3.3.1-linux-amd64.tar.gz &&\
    tar -xzvf code-server-3.3.1-linux-amd64.tar.gz &&\
    cp -r code-server-3.3.1-linux-amd64 /usr/lib/code-server &&\
    ln -s /usr/lib/code-server/bin/code-server /usr/bin/code-server &&\
    mkdir /var/lib/code-server

RUN apt-get update && apt-get install -y debian-keyring debian-archive-keyring &&\
    curl -1sLf 'https://dl.cloudsmith.io/public/caddy/stable/gpg.key' | tee /etc/apt/trusted.gpg.d/caddy-stable.asc &&\
    curl -1sLf 'https://dl.cloudsmith.io/public/caddy/stable/debian.deb.txt' | tee /etc/apt/sources.list.d/caddy-stable.list &&\
    curl https://dl.cloudsmith.io/public/caddy/stable/gpg.key | gpg --yes --dearmor --output /usr/share/keyrings/caddy-stable-archive-keyring.gpg &&\
    echo 'deb [signed-by=/usr/share/keyrings/caddy-stable-archive-keyring.gpg] https://dl.cloudsmith.io/public/caddy/stable/deb/debian any-version main' | tee /etc/apt/sources.list.d/caddy-stable.list

RUN apt-get update && \ 
    apt-get install -y cron libsocket6-perl caddy && \
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