FROM ubuntu:22.04

RUN apt-get update
RUN apt-get upgrade -y
RUN apt-get install -y git wget


RUN apt-get install -y build-essential git libsnappy-dev libz-dev libtar-dev libb2-dev autoconf libtool libjansson-dev libhiredis-dev libsqlite3-dev libssl-dev

COPY --from=rustbuilder /bin/zinit /bin/zinit

ENTRYPOINT ["/bin/zinit","init","--container"]