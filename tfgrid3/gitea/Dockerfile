FROM ubuntu:22.04

# Install dependencies
RUN apt update && \
  apt -y install wget openssh-server sudo sqlite3

# Install zinit
RUN wget -O /sbin/zinit https://github.com/threefoldtech/zinit/releases/download/v0.2.5/zinit && \
  chmod +x /sbin/zinit

# Install Caddy
RUN wget -O /usr/bin/caddy https://github.com/caddyserver/caddy/releases/download/v2.7.6/caddy_2.7.6_linux_amd64.tar.gz
RUN chmod +x /usr/bin/caddy

# Copy zinit configuration and startup script
COPY zinit /etc/zinit
COPY ssh-key.sh /ssh-key.sh

# Copy app.ini to Gitea data directory
COPY app.ini /data/gitea/conf/app.ini

# Set permissions for zinit and startup script
RUN chmod +x /sbin/zinit && chmod +x /ssh-key.sh

# Add the Gitea setup script 
COPY setup-gitea.sh /setup-gitea.sh
RUN chmod +x /setup-gitea.sh

# Expose ports for Gitea, SSH, and Caddy
EXPOSE 3000 22 80

# Run zinit init as entrypoint
ENTRYPOINT ["zinit", "init"]
