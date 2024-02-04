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

# Copy app.ini to Gitea data directory
COPY app.ini /data/gitea/conf/app.ini

# Set permissions for zinit and startup script
RUN chmod +x /sbin/zinit && chmod +x /start.sh && chmod +x /setup-gitea.sh

# Run zinit init as entrypoint
ENTRYPOINT ["zinit", "init"]

# Add the Gitea setup script 
COPY setup-gitea.sh /setup-gitea.sh

# Run the Gitea setup script
RUN /bin/bash /setup-gitea.sh

# Expose ports for Gitea, SSH, and Nginx
EXPOSE 3000 22 80

# Switch to the non-root user
USER git


# Set working directory
WORKDIR /data/gitea

# Command to start Gitea with SQLite
CMD ["/usr/local/bin/gitea", "web", "--config", "/data/gitea/conf/app.ini"]

# Install Nginx
RUN apt-get install -y nginx

# Start Nginx on container startup
CMD ["nginx", "-g", "daemon off;"]
