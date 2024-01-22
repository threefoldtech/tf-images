FROM ubuntu:latest

ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get update && \
    apt-get upgrade -y && \
    apt-get install -y wget software-properties-common curl

# Download and install Bitcoin Core latest verson
RUN latest_release=$(curl -s https://api.github.com/repos/bitcoin/bitcoin/releases/latest | grep 'tag_name' | cut -d '"' -f 4 | sed 's/^v//') && \
    wget https://bitcoincore.org/bin/bitcoin-core-${latest_release}/bitcoin-${latest_release}-x86_64-linux-gnu.tar.gz && \
    tar -xzf bitcoin-${latest_release}-x86_64-linux-gnu.tar.gz && \
    install -m 0755 -o root -g root -t /usr/local/bin bitcoin-${latest_release}/bin/* && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* bitcoin-*

# Install myceilum
RUN mycelium_version=$(curl -s https://api.github.com/repos/threefoldtech/mycelium/releases/latest | grep 'tag_name' | cut -d '"' -f 4 ) && \
    wget "https://github.com/threefoldtech/mycelium/releases/download/${mycelium_version}/mycelium-x86_64-unknown-linux-musl.tar.gz" && \
    tar -xzf mycelium-x86_64-unknown-linux-musl.tar.gz -C /usr/local/bin/
ENV PATH="/usr/local/bin:${PATH}"

# Create a volume to persist data
VOLUME ["/root/.bitcoin"]

# Copy the bitcoin.conf file to the container
COPY bitcoin.conf /root/.bitcoin/bitcoin.conf

# Expose the port Bitcoin Core uses
EXPOSE 8333

# Command to run the Bitcoin Core daemon
CMD ["bitcoind"]
