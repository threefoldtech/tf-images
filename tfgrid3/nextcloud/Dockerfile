FROM ubuntu:24.04 AS build

RUN apt update && \
  apt -y --no-install-recommends install wget golang ca-certificates #&& update-ca-certificates

RUN wget https://github.com/caddyserver/xcaddy/releases/download/v0.4.4/xcaddy_0.4.4_linux_amd64.tar.gz
RUN tar xf xcaddy_0.4.4_linux_amd64.tar.gz
RUN ./xcaddy build --with=github.com/caddyserver/replace-response

FROM ubuntu:24.04

COPY --from=build /caddy /usr/local/bin

RUN apt update && \
  apt -y --no-install-recommends install wget ca-certificates openssh-server ufw inotify-tools iproute2 bind9-dnsutils && \
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
RUN wget -O /sbin/zinit https://github.com/threefoldtech/zos_zinit/releases/download/v0.2.14/zinit && \
  chmod +x /sbin/zinit

COPY ./Caddyfile /etc/caddy/
COPY ./scripts/ /scripts/
COPY ./zinit/ /etc/zinit/
RUN chmod +x /scripts/*.sh

ENTRYPOINT ["/sbin/zinit", "init"]
