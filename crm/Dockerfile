FROM ubuntu:18.04
ARG DEBIAN_FRONTEND=noninteractive
RUN apt-get update 
RUN apt-get install -y  curl git tmux python3 python3-pip python3-dev libffi-dev
RUN apt-get install -y redis-server sudo openssh-server  python-pip vim
RUN apt-get install -y postgresql golang-go

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

# install caddy WITH our modification
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
