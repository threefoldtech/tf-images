FROM ubuntu:18.04

ARG ZINITRAMFS_VERSION

RUN apt-get update
RUN apt-get upgrade -y
RUN apt-get install -y git wget
RUN wget "https://raw.githubusercontent.com/threefoldtech/0-initramfs/${ZINITRAMFS_VERSION}/autobuild/tf-build-deps.sh" -O /tmp/tf-build-deps.sh
RUN bash /tmp/tf-build-deps.sh

COPY --from=rustbuilder /bin/zinit /bin/zinit

ENTRYPOINT ["/bin/zinit","init","--container"]