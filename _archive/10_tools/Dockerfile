FROM vbuilder

RUN rm  -rf /tmp/* /var/cache/apk/*

ADD scripts/* /bin/

WORKDIR /tmp

#this copies the nsc & nats tools
ADD myhost/bin/* /bin/

RUN sh /bin/tmuxp_install.sh

ADD conf.sh /
