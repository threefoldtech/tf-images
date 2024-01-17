FROM ubuntu:jammy

RUN apt update
RUN apt install curl xz-utils sudo -y

RUN curl https://holochain.github.io/holochain/setup.sh | bash
