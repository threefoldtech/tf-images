
FROM despiegk/gobuilder as builder

RUN rm  -rf /tmp/* /var/cache/apk/*

WORKDIR /app
ENV GOPATH /app

RUN cd /tmp && curl -LO https://raw.githubusercontent.com/nats-io/nsc/main/install.sh
RUN cd /tmp && sh ./install.sh
RUN mv ~/.nsccli/bin/nsc /bin && rm -rf ~/.nsccli

#install nats
RUN CGO_ENABLED=1 GOOS=linux go install github.com/nats-io/natscli/nats@latest

# Start a new, final image.
FROM despiegk/base as final

# install tmuxp
ADD scripts/* /bin/
WORKDIR /tmp
RUN sh /bin/tmuxp_install.sh

# Copy the binaries from the builder image.
COPY --from=builder /bin/nsc /bin/
COPY --from=builder /app/bin/nats /bin/

ADD conf.sh /

