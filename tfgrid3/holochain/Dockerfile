FROM ubuntu:jammy

RUN apt update
RUN apt install curl xz-utils sudo -y

# Install myceilum
ENV MYCELIUM_VERSION v0.2.3
RUN curl -sSL "https://github.com/threefoldtech/mycelium/releases/download/${MYCELIUM_VERSION}/mycelium-x86_64-unknown-linux-musl.tar.gz" | tar -C /usr/local/bin/ -xz
ENV PATH="/usr/local/bin:${PATH}"

RUN curl https://holochain.github.io/holochain/setup.sh | bash
