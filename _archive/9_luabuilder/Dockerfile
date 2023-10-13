FROM despiegk/vbuilder

RUN rm  -rf /tmp/* /var/cache/apk/*

ADD scripts/* /bin/

WORKDIR /tmp

RUN sh /bin/tmuxp_install.sh
RUN sh /bin/luarocks_install.sh
RUN sh /bin/luanats_install.sh

ADD conf.sh /
