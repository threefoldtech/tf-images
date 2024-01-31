FROM ubuntu:22.04

# Set environment variables
ENV DEBIAN_FRONTEND=noninteractive

# Update and install necessary packages
RUN apt-get update && apt-get install -y \
    openssh-server \
    build-essential \
    curl \
    git \
    unzip \
    vim \
    libgc-dev \
    make

# Install Golang
ENV GOLANG_VERSION 1.17
RUN curl -sSL "https://golang.org/dl/go${GOLANG_VERSION}.linux-amd64.tar.gz" | tar -C /usr/local -xz
ENV PATH="/usr/local/go/bin:${PATH}"

# Install Rust
RUN curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y

# Set Rust environment variables
ENV PATH="/root/.cargo/bin:${PATH}"

# Install myceilum
ENV MYCELIUM_VERSION v0.2.3
RUN curl -sSL "https://github.com/threefoldtech/mycelium/releases/download/${MYCELIUM_VERSION}/mycelium-x86_64-unknown-linux-musl.tar.gz" | tar -C /usr/local/bin/ -xz
ENV PATH="/usr/local/bin:${PATH}"

# Install hero
RUN curl https://raw.githubusercontent.com/freeflowuniverse/crystallib/development/scripts/installer_hero.sh > /tmp/hero_install.sh
RUN bash /tmp/hero_install.sh
#to debug
RUN bash -x /tmp/hero_install.sh

# Copy entrypoint script
COPY entrypoint.sh /usr/local/bin/entrypoint.sh
RUN chmod +x /usr/local/bin/entrypoint.sh
ENV PATH="/usr/local/go/bin:${PATH}"
RUN echo PATH=${PATH} >> /root/.bashrc

# Expose SSH port
EXPOSE 22

# Set the entry point to the custom script
ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]
