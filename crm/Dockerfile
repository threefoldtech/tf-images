FROM ubuntu:18.04
ARG DEBIAN_FRONTEND=noninteractive
RUN apt-get update 
RUN apt-get install -y  curl git tmux python3 python3-pip python3-dev libffi-dev
RUN apt-get install -y redis-server sudo openssh-server  python-pip vim
#RUN apt-get install -y postgresql golang-go
RUN apt-get install -y postgresql 

# install supervisor

RUN pip3 install supervisor

# install nodejs
RUN curl -sL https://deb.nodesource.com/setup_8.x | sudo -E bash -


# install packages for crm

RUN set -ex; \
        [[ -d /opt/code/github/incubaid/crm ]] || mkdir -p /opt/code/github/incubaid/crm ;  \
        git clone https://github.com/Incubaid/crm.git /opt/code/github/incubaid/crm ; \
        cd /opt/code/github/incubaid/crm ; \
        sed -i "s/flask-shell-ipython==0.3.0/flask-shell-ipython==0.3.1/g" requirements.pip ; \
        pip3 install -r requirements.pip

ARG GOROOT=/usr/local/go
ARG GOPATH=/opt/iyo
ARG PATH=$GOPATH/bin:$GOROOT/bin:$PATH
# install latest go 
RUN set -ex; \
	wget https://dl.google.com/go/go1.13.7.linux-amd64.tar.gz; \
	tar -xvf go1.13.7.linux-amd64.tar.gz; \
	mv go /usr/local; \
	export GOROOT=/usr/local/go; \
	export GOPATH=/opt/iyo; \
	export PATH=$GOPATH/bin:$GOROOT/bin:$PATH ; \
	echo "export PATH=$GOPATH/bin:$GOROOT/bin:$PATH" >> /.profile
# install caddy WITH our iyo plugin
RUN set -ex;\
	export PATH=$GOPATH/bin:$GOROOT/bin:$PATH ; \
	git clone https://github.com/Incubaid/caddyman.git /opt/caddyman ; \
	cd /opt/caddyman; \
	bash caddyman.sh install iyo ; \
	#cp /opt/go/bin/caddy /opt/bin/caddy
#RUN curl https://getcaddy.com | bash -s personal

# install latest restic
RUN set -ex; \
        git clone https://github.com/restic/restic; \
        cd restic; \
        go run build.go; \
        cp -p restic /usr/bin/restic; \
        rm -rf restic

COPY supervisor.conf /etc/supervisor/supervisord.conf

COPY root/opt/bin /opt/bin

RUN chmod +x /opt/bin/*

# To do: initialize the database so it can run properly

ENTRYPOINT ["/opt/bin/run_all.sh" ]
