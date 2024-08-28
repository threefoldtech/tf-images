FROM ubuntu:22.04

RUN apt update && \
  apt -y --no-install-recommends install wget ca-certificates openssh-server ufw inotify-tools iproute2 && \
  rm -rf /var/lib/apt/lists/*

# Prepare to install Docker by adding gpg keys
RUN install -m 0755 -d /etc/apt/keyrings && \
    wget https://download.docker.com/linux/ubuntu/gpg -O /etc/apt/keyrings/docker.asc && \
    chmod a+r /etc/apt/keyrings/docker.asc

# Add the Docker repository to Apt sources
RUN echo \
    "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu \
    $(. /etc/os-release && echo "$VERSION_CODENAME") stable" > /etc/apt/sources.list.d/docker.list

RUN apt update && \
    # Skip compose and buildx. Users can install later if needed
    apt install --no-install-recommends -y docker-ce docker-ce-cli containerd.io && \
    rm -rf /var/lib/apt/lists/*

# Install Zinit
RUN wget -O /sbin/zinit https://github.com/threefoldtech/zinit/releases/download/v0.2.14/zinit && \
  chmod +x /sbin/zinit

# Install Caddy
RUN wget -O /sbin/caddy 'https://caddyserver.com/api/download?os=linux&arch=amd64&p=github.com%2Fcaddyserver%2Freplace-response&idempotency=43631173212363' && \
  chmod +x /sbin/caddy

COPY ./Caddyfile /etc/caddy/
COPY ./scripts/ /scripts/
COPY ./zinit/ /etc/zinit/
RUN chmod +x /scripts/*.sh

ENTRYPOINT ["/sbin/zinit", "init"]
