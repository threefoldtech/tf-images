FROM ubuntu:latest

# Install pcakages
RUN apt update && \
    apt upgrade -y && \
    apt install -y wget curl git build-essential gcc make librust-openssl-dev protobuf-compiler libprotobuf-dev openssh-server ufw

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

# Install Rust
RUN curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y

# Set environment variables for Rust and MyCelium
ENV PATH="/usr/local/bin:/root/.cargo/bin:${PATH}"

# Clone the Nostr relay repository and build
RUN mkdir /var/nostr && \
    cd /var/nostr/ && \
    git clone https://git.sr.ht/~gheartsfield/nostr-rs-relay && \
    cd nostr-rs-relay/ && \
    cargo build --release && \
    install target/release/nostr-rs-relay /usr/local/bin && \
    cargo clean


# Cleaning up
RUN rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*  mycelium-x86_64-unknown-linux-musl.tar.gz /root/.rustup

# Expose the port used by the Nostr relay
EXPOSE 8080

# Command to run the relay
CMD ["/sbin/zinit", "init", "--container"]
