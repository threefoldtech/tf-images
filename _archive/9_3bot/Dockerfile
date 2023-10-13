<<<<<<< HEAD
FROM despiegk/natstools as builder

ADD conf.sh /


FROM despiegk/vbuilder as final
=======
FROM vbuilder
>>>>>>> master

RUN rm  -rf /tmp/* /var/cache/apk/*

ADD scripts/* /bin/

# Copy the binaries from the builder image.
COPY --from=builder /bin/nsc /bin/
COPY --from=builder /bin/nats /bin/

WORKDIR /tmp

RUN sh /bin/nodejs_install.sh
RUN sh /bin/tfgrid_v_install.sh

RUN apk add --no-cache tmux zsh bash \
    && apk add --no-cache python3 \
    && apk add --no-cache py3-pip \
    && pip install -e git+https://github.com/tmux-python/tmuxp.git#egg=tmuxp

ADD conf.sh /
