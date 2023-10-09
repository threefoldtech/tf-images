FROM golang:1.20-bullseye as aydo-builder

RUN git clone https://github.com/freeflowuniverse/aydo.git /aydo && cd /aydo && \
    go build -o sftpgo

FROM onlyoffice/documentserver:7.3

COPY zinit /etc/zinit
COPY sftpgo /var/lib/sftpgo
COPY ds.conf.tmpl /etc/onlyoffice/documentserver/nginx/ds.conf.tmpl
COPY --from=aydo-builder /aydo/sftpgo /usr/bin/
COPY --from=aydo-builder /aydo/templates /usr/share/sftpgo/templates
COPY --from=aydo-builder /aydo/static /usr/share/sftpgo/static
COPY --from=aydo-builder /aydo/openapi /usr/share/sftpgo/openapi

RUN apt update && apt install -y openssh-server dnsutils

RUN wget -O /sbin/zinit https://github.com/threefoldtech/zinit/releases/download/v0.2.11/zinit && \
    chmod +x /sbin/zinit

ENTRYPOINT ["zinit", "init"]
