# Use an official Ubuntu base image
FROM ubuntu:latest

# Set environment variables
ENV DEBIAN_FRONTEND=noninteractive

# Update and install necessary packages
RUN apt-get update && apt-get install -y \
    openssh-server \
    build-essential \
    curl \
    git \
    unzip

# Install Golang
ENV GOLANG_VERSION 1.17
RUN curl -sSL "https://golang.org/dl/go${GOLANG_VERSION}.linux-amd64.tar.gz" | tar -C /usr/local -xz
ENV PATH="/usr/local/go/bin:${PATH}"

# Install Vlang
ENV VLANG_VERSION 0.4.4
RUN curl -sSL "https://github.com/vlang/v/releases/download/${VLANG_VERSION}/v_linux.zip" -o v_linux.zip && \
    unzip v_linux.zip -d /root && \
    rm v_linux.zip
RUN ln -s /root/v/v /usr/local/bin/v

# Install Rust
RUN curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y

# Set Rust environment variables
ENV PATH="/root/.cargo/bin:${PATH}"

# Install myceilum
ENV MYCELIUM_VERSION v0.2.3
RUN curl -sSL "https://github.com/threefoldtech/mycelium/releases/download/${MYCELIUM_VERSION}/mycelium-x86_64-unknown-linux-musl.tar.gz" | tar -C /usr/local/bin/ -xz
ENV PATH="/usr/local/bin:${PATH}"

# Copy entrypoint script
COPY entrypoint.sh /usr/local/bin/entrypoint.sh
RUN chmod +x /usr/local/bin/entrypoint.sh
ENV PATH="/usr/local/go/bin:${PATH}"
RUN echo PATH=${PATH} >> /root/.bashrc
# Expose SSH port
EXPOSE 22

# Set the entry point to the custom script
ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]