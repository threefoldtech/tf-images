# Use the official Ubuntu as the base image
FROM ubuntu:jammy

# Install essential tools
RUN apt-get update \
    && apt-get install -y \
    curl \
    wget \
    git \
    sudo \
    xz-utils\
    openssh-server\
    # Add any other essential tools here \
    && rm -rf /var/lib/apt/lists/*

# Install Nix
RUN curl -L https://nixos.org/nix/install | sh -s -- --daemon

ENV PATH="/root/.nix-profile/bin:${PATH}"

COPY holo-nixpkgs /holo-nixpkgs
WORKDIR /holo-nixpkgs
RUN nix-shell
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