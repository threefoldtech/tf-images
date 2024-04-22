FROM ubuntu:latest

ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get update && \
    apt-get upgrade -y && \
    apt-get install -y wget software-properties-common curl openssh-server ufw

# Download and install latest zinit
RUN curl -s https://api.github.com/repos/threefoldtech/zinit/releases/latest | \
    grep "browser_download_url" | \
    cut -d '"' -f 4 | \
    wget -qi - -O /sbin/zinit
    
RUN chmod +x /sbin/zinit
COPY scripts/ufw.sh /usr/local/bin/

# Adding zinit config files
ADD zinit  /etc/zinit/    

# Download and install latest Bitcoin Core latest verson
RUN latest_release=$(curl -s https://api.github.com/repos/bitcoin/bitcoin/releases/latest | grep 'tag_name' | cut -d '"' -f 4 | sed 's/^v//') && \
    wget https://bitcoincore.org/bin/bitcoin-core-${latest_release}/bitcoin-${latest_release}-x86_64-linux-gnu.tar.gz && \
    tar -xzf bitcoin-${latest_release}-x86_64-linux-gnu.tar.gz && \
    install -m 0755 -o root -g root -t /usr/local/bin bitcoin-${latest_release}/bin/*

# Install latest myceilum
RUN mycelium_version=$(curl -s https://api.github.com/repos/threefoldtech/mycelium/releases/latest | grep 'tag_name' | cut -d '"' -f 4 ) && \
    wget "https://github.com/threefoldtech/mycelium/releases/download/${mycelium_version}/mycelium-x86_64-unknown-linux-musl.tar.gz" && \
    tar -xzf mycelium-x86_64-unknown-linux-musl.tar.gz -C /usr/local/bin/
ENV PATH="/usr/local/bin:${PATH}"

# Cleaning up
RUN rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*  mycelium-x86_64-unknown-linux-musl.tar.gz bitcoin-*

# Copy the bitcoin.conf file to the container
COPY bitcoin.conf /root/.bitcoin/bitcoin.conf

# Starting Command to run Bitcoind and ssh 
CMD ["/sbin/zinit", "init", "--container"]
