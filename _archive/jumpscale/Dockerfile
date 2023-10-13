FROM builders_python

RUN apk --no-cache add alpine-sdk libffi-dev libressl-dev bash
RUN curl -sSL https://raw.githubusercontent.com/python-poetry/poetry/master/get-poetry.py | python -
ADD boot.sh /usr/local/bin
RUN chmod 770 /usr/local/bin/boot.sh

# make sure we get fresh keys
RUN rm -rf /etc/ssh/ssh_host_rsa_key /etc/ssh/ssh_host_dsa_key

# install jumpscale to create the venv with current deps
RUN echo "PATH=$PATH:/root/.poetry/bin/" > /etc/profile.d/poetry.sh
RUN mkdir -p /myhost/code
RUN /root/.poetry/bin/poetry config virtualenvs.create false
RUN cd /myhost/code && git clone https://github.com/threefoldtech/js-ng && \
    cd js-ng && /root/.poetry/bin/poetry install

EXPOSE 22

RUN echo 'THREEFOLD JUMPSCALE DEV ENV WELCOMES YOU' > /etc/motd

ENTRYPOINT ["/usr/bin/dumb-init", "--"]
CMD ["/usr/local/bin/boot.sh"]
