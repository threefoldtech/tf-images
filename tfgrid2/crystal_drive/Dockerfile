FROM ubuntu:20.04 AS build-dep

ARG DEBIAN_FRONTEND=noninteractive

RUN apt-get update ; \
	apt-get install -y git build-essential musl-tools curl

RUN  cd ~ ; \
	git clone https://github.com/threefoldtech/0-db.git ; \
	cd 0-db && make ; \
	mkdir /root/zdb ; \
	mv bin/zdb /root/zdb/

RUN  curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs > rusetup.sh ; \
     bash rusetup.sh -q -y ; export PATH=$PATH:$HOME/.cargo/bin ; \
	cd ~ ; \
	git clone https://github.com/threefoldtech/bcdb.git /tmp/bcdb ; \
	cd /tmp/bcdb && make; \
	mkdir ~/bcdb; \
	cp target/x86_64-unknown-linux-musl/release/bcdb ~/bcdb/


FROM ubuntu:20.04

ARG DEBIAN_FRONTEND=noninteractive

RUN apt-get update ; \
    apt-get install -y  curl git wget ; \
    apt-get install -y python3 python3-pip python3-dev ; \
    apt-get install -y openssh-server vim

COPY --from=build-dep /root/zdb  /root/zdb
COPY --from=build-dep /root/bcdb /root/bcdb

RUN wget https://github.com/crystaluniverse/bcdb-client/releases/download/v0.1/tfuser -O /usr/local/bin/tfuser ; \
	chmod +x /usr/local/bin/tfuser

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

COPY supervisor.conf /etc/supervisor/supervisord.conf
COPY start_crystaldrive.sh /start_crystaldrive.sh
COPY bcdb.sh /root/bcdb/bcdb.sh
RUN chmod  +x  /start_crystaldrive.sh
ENTRYPOINT ["/start_crystaldrive.sh" ]

