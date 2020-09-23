FROM ubuntu:bionic
RUN mkdir /config &&\
    mkdir /etc/zinit

COPY zinit /sbin/zinit
COPY trc /usr/local/bin
COPY trc.yaml /etc/zinit
RUN  chmod +x /usr/local/bin/trc
ENTRYPOINT ["/sbin/zinit", "init"] 
