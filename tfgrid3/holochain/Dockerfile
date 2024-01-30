FROM ubuntu:jammy

RUN apt update
RUN apt install curl xz-utils sudo -y

# Install myceilum
ENV MYCELIUM_VERSION v0.2.3
RUN curl -sSL "https://github.com/threefoldtech/mycelium/releases/download/${MYCELIUM_VERSION}/mycelium-x86_64-unknown-linux-musl.tar.gz" | tar -C /usr/local/bin/ -xz
ENV PATH="/usr/local/bin:${PATH}"

RUN curl https://holochain.github.io/holochain/setup.sh | bash

RUN apt install openssh-server -y
ENV PATH="/root/.nix-profile/bin:${PATH}"
RUN nix-env -iA nixpkgs.mc
RUN curl -fsSL https://code-server.dev/install.sh | sh

# Copy entrypoint script
COPY entrypoint.sh /usr/local/bin/entrypoint.sh
RUN chmod +x /usr/local/bin/entrypoint.sh
RUN echo PATH=${PATH} >> /root/.bashrc

# Expose SSH port
EXPOSE 22
# Expose code-server port
EXPOSE 8080

# Set the entry point to the custom script
ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]
