FROM ubuntu:18.04

ARG DEBIAN_FRONTEND=noninteractive

RUN apt-get update ; \
    apt-get install -y  curl git tmux ; \
    apt-get install -y python3 python3-pip python3-dev ; \
    apt-get install -y sudo openssh-server vim net-tools

# install supervisor
RUN pip3 install supervisor

# install crystal-lang.org



RUN curl -sSL https://dist.crystal-lang.org/apt/setup.sh |  bash ; \
	curl -sL "https://keybase.io/crystal/pgp_keys.asc" |  apt-key add - ; \
	echo "deb https://dist.crystal-lang.org/apt crystal main" > /etc/apt/sources.list.d/crystal.list  ; \
	apt-get update  ; \
	apt install crystal -y 

	# nstall Latest Node.js and NPM on Ubuntu with PPA
RUN     curl -sL https://deb.nodesource.com/setup_14.x | bash -  ; \
	apt-get install nodejs -y

RUN apt remove crystal -y

RUN wget https://github.com/crystal-lang/crystal/releases/download/0.34.0/crystal_0.34.0-1_amd64.deb
RUN dpkg -i crystal_0.34.0-1_amd64.deb && rm crystal_0.34.0-1_amd64.deb


COPY supervisor.conf /etc/supervisor/supervisord.conf
COPY start_conscious_internet.sh /start_conscious_internet.sh

RUN chmod  +x  /start_conscious_internet.sh
ENTRYPOINT ["/start_conscious_internet.sh" ]

# to support zosv1 , can removed later
COPY startup.toml /.startup.toml
RUN chmod  +x  /.startup.toml

