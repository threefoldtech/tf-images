FROM ubuntu:22.04
ENV DEBIAN_FRONTEND=noninteractive

# Install necessary packages
RUN apt-get update && \
    apt-get upgrade -y && \
    apt-get install -y --no-install-recommends \
    wget \
    ca-certificates \
    curl \
    gnupg \
    openssh-server \
    ufw \
    nginx \
    certbot \
    python3-certbot-nginx && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# Download and install the latest Zinit
RUN curl -s https://api.github.com/repos/threefoldtech/zinit/releases/latest | \
    grep "browser_download_url" | \
    cut -d '"' -f 4 | \
    wget -qi - -O /sbin/zinit && \
    chmod +x /sbin/zinit

# Copy configuration scripts
COPY scripts/ufw.sh /usr/local/bin/
COPY scripts/dockerd.sh /usr/local/bin/
COPY scripts/start-fk.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/ufw.sh /usr/local/bin/dockerd.sh /usr/local/bin/start-fk.sh

# Add Zinit configuration files
ADD zinit /etc/zinit/

# Install Docker, Buildx, and Docker Compose
RUN mkdir -p /etc/apt/keyrings && \
    curl -fsSL https://download.docker.com/linux/ubuntu/gpg | gpg --dearmor -o /etc/apt/keyrings/docker.gpg && \
    echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu $(. /etc/os-release && echo \"$VERSION_CODENAME\") stable" | \
    tee /etc/apt/sources.list.d/docker.list > /dev/null && \
    apt-get update && \
    apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin


# Clean up any remaining temporary files
RUN apt-get clean && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# Expose ports for HTTP and SSH access
EXPOSE 3000 222

# Command to run Zinit in the container
CMD ["/sbin/zinit", "init", "--container"]
