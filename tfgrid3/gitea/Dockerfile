FROM ubuntu:22.04

# Install dependencies
RUN apt update && \
  apt -y install wget openssh-server sudo

# Install zinit
RUN wget -O /sbin/zinit https://github.com/threefoldtech/zinit/releases/download/v0.2.5/zinit && \
  chmod +x /sbin/zinit

# Copy zinit configuration and startup script
COPY zinit /etc/zinit
COPY start.sh /start.sh

# Set permissions for zinit and startup script
RUN chmod +x /sbin/zinit && chmod +x /start.sh

# Run zinit init as entrypoint
ENTRYPOINT ["zinit", "init"]

# Add the Gitea setup script
COPY setup-gitea.sh /setup-gitea.sh

# Run the Gitea setup script
RUN /bin/bash /setup-gitea.sh

# Expose ports for Gitea, SSH, and Nginx
EXPOSE 3000 22 80

# Set up UFW
RUN apt-get install -y ufw && \
    ufw default deny incoming && \
    ufw default allow outgoing && \
    ufw allow 22 && \
    ufw allow 80 && \
    yes | ufw enable

# Install Nginx
RUN apt-get install -y nginx

# Start Nginx on container startup
CMD ["nginx", "-g", "daemon off;"]
