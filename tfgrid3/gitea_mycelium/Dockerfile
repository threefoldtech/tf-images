FROM ubuntu:20.04
ENV DEBIAN_FRONTEND=noninteractive

# Install pcakages
RUN apt update && \
    apt upgrade -y && \
    apt install -y --no-install-recommends wget ca-certificates curl gnupg openssh-server ufw

# Download and install latest zinit
RUN curl -s https://api.github.com/repos/threefoldtech/zinit/releases/latest | \
    grep "browser_download_url" | \
    cut -d '"' -f 4 | \
    wget -qi - -O /sbin/zinit

# init config files
COPY scripts/ufw.sh /usr/local/bin/
COPY scripts/dockerd.sh /usr/local/bin/
RUN chmod +x /sbin/zinit /usr/local/bin/ufw.sh /usr/local/bin/dockerd.sh

# Adding docker config files
ADD docker /docker

# Adding zinit config files
ADD zinit  /etc/zinit/  

# Install Docker
RUN mkdir -p /etc/apt/keyrings && \
    curl -fsSL https://download.docker.com/linux/ubuntu/gpg | gpg --dearmor -o /etc/apt/keyrings/docker.gpg && \
    chmod a+r /etc/apt/keyrings/docker.gpg && \
    echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
    tee /etc/apt/sources.list.d/docker.list > /dev/null && \
    apt-get update && \
    apt-get install -y docker-ce docker-ce-cli containerd.io

# Install Docker Compose
RUN DOCKER_CONFIG=${DOCKER_CONFIG:-/usr/local/lib/docker/cli-plugins} && \
    mkdir -p $DOCKER_CONFIG && \
    curl -SL https://github.com/docker/compose/releases/latest/download/docker-compose-$(uname -s)-$(uname -m) -o $DOCKER_CONFIG/docker-compose && \
    chmod +x $DOCKER_CONFIG/docker-compose && \
    ln -s $DOCKER_CONFIG/docker-compose /usr/local/bin/docker-compose

# Cleaning up
RUN rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* mycelium-x86_64-unknown-linux-musl.tar.gz

# Expose ports for HTTP and SSH access
EXPOSE 3000 222

# Command to run the zinit
CMD ["/sbin/zinit", "init", "--container"]
