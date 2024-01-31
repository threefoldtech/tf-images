FROM ubuntu:jammy

RUN apt update &&\ 
    apt install curl xz-utils sudo openssh-server vim libatomic1 redis-server -y

# Installing hero
RUN curl -fsSL https://raw.githubusercontent.com/freeflowuniverse/crystallib/development/scripts/installer_hero.sh | bash
ENV PATH="/root/hero/bin:${PATH}"
# install holo chain
# remove lines from 46-48 which checks for systemd
RUN curl  https://holochain.github.io/holochain/setup.sh  | sed -e '42,49d'  | bash

ENV PATH="/root/.nix-profile/bin:${PATH}"
RUN nix-env -iA nixpkgs.mc
RUN curl -fsSL https://code-server.dev/install.sh | sh

# Copy entrypoint script
RUN  curl -sSL "https://github.com/threefoldtech/zinit/releases/download/v0.2.14/zinit" -o /sbin/zinit &&\
    chmod +x /sbin/zinit
RUN echo PATH=${PATH} >> /root/.bashrc

COPY ./scripts/ /scripts/
COPY ./zinit_services/ /etc/zinit/
RUN chmod +x /scripts/*.sh

# Expose SSH port
EXPOSE 22
# Expose code-server port
EXPOSE 8080

ENTRYPOINT ["/sbin/zinit", "init"]

