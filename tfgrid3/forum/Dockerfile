# NAME:     threefolddev/forum
# VERSION:  release
FROM ubuntu:20.04 as build-dep

RUN apt update &&  DEBIAN_FRONTEND=noninteractive apt install git curl -y

RUN curl -LO https://dl.google.com/go/go1.17.6.linux-amd64.tar.gz &&\
    rm -rf /usr/local/go && tar -C /usr/local -xzf go1.17.6.linux-amd64.tar.gz &&\
    mkdir -p $HOME/go/{bin,src}

ENV GOPATH=$HOME/go
ENV PATH=$PATH:$GOPATH/bin
ENV PATH=$PATH:$GOPATH/bin:/usr/local/go/bin

RUN git clone https://github.com/restic/restic \
    && cd restic \
    && go run build.go \
    && cp -p restic /usr/bin/restic \
    && rm -rf restic

FROM ubuntu:20.04

ENV DEBIAN_FRONTEND=noninteractive

RUN apt update &&\
    apt -y upgrade &&\
    apt -y install software-properties-common

RUN apt install -y gnupg sudo curl fping 

RUN echo "debconf debconf/frontend select Teletype" | debconf-set-selections
RUN sh -c "fping proxy && echo 'Acquire { Retries \"0\"; HTTP { Proxy \"http://proxy:3128\";}; };' > /etc/apt/apt.conf.d/40proxy && apt update || true"

RUN apt install -y locales locales-all
ENV LC_ALL en_US.UTF-8
ENV LANG en_US.UTF-8
ENV LANGUAGE en_US.UTF-8

RUN curl https://apt.postgresql.org/pub/repos/apt/ACCC4CF8.asc | apt-key add -
RUN echo "deb http://apt.postgresql.org/pub/repos/apt/ buster-pgdg main" | tee /etc/apt/sources.list.d/postgres.list

RUN curl --silent --location https://deb.nodesource.com/setup_10.x | sudo bash -

RUN apt update

RUN apt -y install --no-install-recommends git rsyslog logrotate cron ssh-client less wget && \
    wget http://ftp.de.debian.org/debian/pool/main/i/icu/libicu63_63.1-6+deb10u1_amd64.deb && \
    dpkg -i libicu63_63.1-6+deb10u1_amd64.deb

RUN apt -y install build-essential rsync \
    libxslt-dev libcurl4-openssl-dev \
    libssl-dev libyaml-dev libtool \
    libxml2-dev gawk parallel \
    libpq-dev libreadline-dev \
    anacron \
    psmisc vim whois brotli libunwind-dev \
    libtcmalloc-minimal4 cmake

ENV PG_MAJOR 12
RUN apt -y install postgresql-${PG_MAJOR} postgresql-client-${PG_MAJOR} postgresql-contrib-${PG_MAJOR}

RUN sed -i -e 's/start -q anacron/anacron -s/' /etc/cron.d/anacron
RUN sed -i.bak 's/$ModLoad imklog/#$ModLoad imklog/' /etc/rsyslog.conf
RUN dpkg-divert --local --rename --add /sbin/initctl
RUN sh -c "test -f /sbin/initctl || ln -s /bin/true /sbin/initctl"
RUN cd / &&\
    apt -y install runit socat &&\
    mkdir -p /etc/runit/1.d &&\
    apt clean &&\
    rm -f /etc/apt/apt.conf.d/40proxy &&\
    locale-gen en_US &&\
    apt install -y nodejs &&\
    npm install -g uglify-js &&\
    npm install -g svgo

ADD ./setup/install-nginx /tmp/install-nginx
RUN /tmp/install-nginx

ADD ./setup/install-redis /tmp/install-redis
RUN /tmp/install-redis

ADD ./setup/install-imagemagick /tmp/install-imagemagick
RUN /tmp/install-imagemagick

ADD ./setup/install-pngcrush /tmp/install-pngcrush
RUN bash /tmp/install-pngcrush

ADD ./setup/install-gifsicle /tmp/install-gifsicle
RUN /tmp/install-gifsicle

ADD ./setup/install-pngquant /tmp/install-pngquant
RUN /tmp/install-pngquant

RUN apt -y install advancecomp jhead jpegoptim libjpeg-turbo-progs optipng bzip2

RUN mkdir /jemalloc-stable && cd /jemalloc-stable &&\
    wget https://github.com/jemalloc/jemalloc/releases/download/3.6.0/jemalloc-3.6.0.tar.bz2 &&\
    tar -xjf jemalloc-3.6.0.tar.bz2 && cd jemalloc-3.6.0 && ./configure --prefix=/usr && make && make install &&\
    cd / && rm -rf /jemalloc-stable

RUN mkdir /jemalloc-new && cd /jemalloc-new &&\
    wget https://github.com/jemalloc/jemalloc/releases/download/5.2.1/jemalloc-5.2.1.tar.bz2 &&\
    tar -xjf jemalloc-5.2.1.tar.bz2 && cd jemalloc-5.2.1 && ./configure --prefix=/usr --with-install-suffix=5.2.1 && make build_lib && make install_lib &&\
    cd / && rm -rf /jemalloc-new

# install ruby
RUN echo 'gem: --no-document' >> /usr/local/etc/gemrc &&\
    mkdir /src && cd /src && git clone https://github.com/sstephenson/ruby-build.git &&\
    cd /src/ruby-build && ./install.sh &&\
    cd / && rm -rf /src/ruby-build && (ruby-build 2.6.6 /usr/local)

RUN gem update --system

RUN gem install bundler --force &&\
    rm -rf /usr/local/share/ri/2.6.6/system &&\
    cd / && git clone https://github.com/discourse/pups.git

# Validate install
RUN ruby -Eutf-8 -e "v = \`convert -version\`; %w{png tiff jpeg freetype heic}.each { |f| unless v.include?(f); STDERR.puts('no ' + f +  ' support in imagemagick'); exit(-1); end }"


# This tool allows us to disable huge page support for our current process
# since the flag is preserved through forks and execs it can be used on any
# process
ADD ./setup/thpoff.c /src/thpoff.c
RUN gcc -o /usr/local/sbin/thpoff /src/thpoff.c && rm /src/thpoff.c

# clean up for docker squash
RUN   rm -fr /usr/share/man &&\
    rm -fr /usr/share/doc &&\
    rm -fr /usr/share/vim/vim74/tutor &&\
    rm -fr /usr/share/vim/vim74/doc &&\
    rm -fr /usr/share/vim/vim74/lang &&\
    rm -fr /usr/local/share/doc &&\
    rm -fr /usr/local/share/ruby-build &&\
    rm -fr /root/.gem &&\
    rm -fr /root/.npm &&\
    rm -fr /tmp/* &&\
    rm -fr /usr/share/vim/vim74/spell/en*


# this can probably be done, but I worry that people changing PG locales will have issues
# cd /usr/share/locale && rm -fr `ls -d */ | grep -v en`

RUN mkdir -p /etc/runit/3.d

ADD ./setup/runit-1 /etc/runit/1
ADD ./setup/runit-1.d-cleanup-pids /etc/runit/1.d/cleanup-pids
ADD ./setup/runit-1.d-anacron /etc/runit/1.d/anacron
ADD ./setup/runit-1.d-00-fix-var-logs /etc/runit/1.d/00-fix-var-logs
ADD ./setup/runit-2 /etc/runit/2
ADD ./setup/runit-3 /etc/runit/3
ADD setup/boot /sbin/boot

ADD ./setup/cron /etc/service/cron/run
ADD ./setup/rsyslog /etc/service/rsyslog/run
ADD ./setup/cron.d_anacron /etc/cron.d/anacron

RUN apt-get update && \
    apt-get install net-tools iputils-ping -y && \
    apt install -y libsodium-dev python python3-pip tmux openssh-server

RUN apt-get install -y python3-apt python3-cairo python3-cairo-dev libglib2.0-dev libgirepository1.0-dev libcairo2-dev python-gobject ufw
COPY ./setup/requirements.txt /tmp/requirements.txt
RUN pip3 install --no-cache-dir -r /tmp/requirements.txt 

RUN chmod 600 /etc/crontab
RUN mkdir /etc/service/3bot_tmux

COPY --from=build-dep /usr/bin/restic /usr/bin/restic

# Install & Config Discourse server

ENV RAILS_ENV production
ENV RUBY_ALLOCATOR /usr/lib/libjemalloc.so.1
ENV FORUM_VERSION staging

RUN useradd discourse -s /bin/bash -m -U &&\
    mkdir -p /var/www &&\
    cd /var/www &&\
    git clone https://github.com/threefoldtech/threefold-forums -b $FORUM_VERSION discourse &&\
    cd discourse &&\
    git remote set-branches --add origin tests-passed &&\
    chown -R discourse:discourse /var/www/discourse &&\
    cd /var/www/discourse &&\
    sudo bundle install --deployment --jobs 4 --without test development &&\
    bundle exec rake maxminddb:get &&\
    find /var/www/discourse/vendor/bundle -name tmp -type d -exec rm -rf {} +

SHELL ["/bin/bash", "-c"]

# Create database
COPY ./conf/prepare_postgres /.prepare_postgres.sh
COPY ./conf/prepare_database.sh /.prepare_database.sh

ENV home=/var/www/discourse
RUN cd $home && find $home ! -user discourse -exec chown discourse {} \+ 

RUN mkdir -p /var/log/{ssh,postgres,redis}

RUN bash /.prepare_postgres.sh && \
    /etc/init.d/postgresql start && \
    /usr/bin/redis-server  --daemonize yes && \
    bash /.prepare_database.sh && \
    cd $home && \
    su discourse -c 'RAILS_ENV=production bundle exec rake  db:migrate ;bundle exec rails assets:precompile '

COPY ./conf/custom-loading.html /var/www/discourse/public/
COPY ./conf/unicorn_run /etc/service/unicorn/run
COPY ./setup/restic_backup.sh /.restic_backup.sh
COPY ./conf/supervisor.conf /etc/supervisor/supervisord.conf
COPY ./conf/discourse.conf /etc/nginx/conf.d/discourse.conf

COPY start_discourse.sh /.start_discourse.sh

RUN chmod +x /etc/service/unicorn/run &&\
    chmod +x /.start_discourse.sh

ENTRYPOINT ["/.start_discourse.sh"]
