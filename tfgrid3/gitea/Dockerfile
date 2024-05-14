FROM ubuntu:22.04

# Install dependencies
RUN apt update && \
  apt -y install wget openssh-server sudo sqlite3

# Install zinit
RUN wget -O /sbin/zinit https://github.com/threefoldtech/zinit/releases/download/v0.2.5/zinit && \
  chmod +x /sbin/zinit

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

# Expose ports for Gitea and SSH
EXPOSE 3000 22

# Run zinit init as entrypoint
ENTRYPOINT ["zinit", "init"]
