FROM ubuntu:23.10
ENV DEBIAN_FRONTEND=noninteractive

# Install pcakages
RUN apt update && \
    apt upgrade -y && \
    apt install -y wget curl git openssh-server ufw

# Download and install latest zinit
RUN curl -s https://api.github.com/repos/threefoldtech/zinit/releases/latest | \
    grep "browser_download_url" | \
    cut -d '"' -f 4 | \
    wget -qi - -O /sbin/zinit
    
RUN chmod +x /sbin/zinit
COPY scripts/ufw.sh /usr/local/bin/

# Adding zinit config files
ADD zinit  /etc/zinit/  

# Install latest myceilum
RUN mycelium_version=$(curl -s https://api.github.com/repos/threefoldtech/mycelium/releases/latest | grep 'tag_name' | cut -d '"' -f 4 ) && \
    wget "https://github.com/threefoldtech/mycelium/releases/download/${mycelium_version}/mycelium-x86_64-unknown-linux-musl.tar.gz" && \
    tar -xzf mycelium-x86_64-unknown-linux-musl.tar.gz -C /usr/local/bin/

# Cleaning up
RUN rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# Command to run the zinit
CMD ["/sbin/zinit", "init", "--container"]
