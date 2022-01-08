FROM alpine:3
RUN apk add --no-cache openssh \
    && echo 'root:*' | chpasswd -e

COPY entrypoint.sh /
RUN chmod +x /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]