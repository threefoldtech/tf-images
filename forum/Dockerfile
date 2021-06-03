# NAME:     threefolddev/forum
# VERSION:  release
FROM ubuntu:20.04 as build-dep

RUN apt update && DEBIAN_FRONTEND=noninteractive apt install golang-go git -y
RUN git clone https://github.com/restic/restic \
    && cd restic \
    && go run build.go \
    && cp -p restic /usr/bin/restic \
    && rm -rf restic


FROM debian:buster-slim
ENV PG_MAJOR 12
ENV RUBY_ALLOCATOR /usr/lib/libjemalloc.so.1
ENV RAILS_ENV production
ENV FORUM_VERSION staging

#LABEL maintainer="Sam Saffron \"https://twitter.com/samsaffron\""

RUN echo 2.0.`date +%Y%m%d` > /VERSION

RUN apt update && apt install -y gnupg sudo curl
RUN echo "debconf debconf/frontend select Teletype" | debconf-set-selections
RUN apt update && apt -y install fping
RUN sh -c "fping proxy && echo 'Acquire { Retries \"0\"; HTTP { Proxy \"http://proxy:3128\";}; };' > /etc/apt/apt.conf.d/40proxy && apt update || true"
RUN apt -y install software-properties-common
RUN apt-mark hold initscripts
RUN apt -y upgrade

RUN apt install -y locales locales-all
ENV LC_ALL en_US.UTF-8
ENV LANG en_US.UTF-8
ENV LANGUAGE en_US.UTF-8

RUN curl https://apt.postgresql.org/pub/repos/apt/ACCC4CF8.asc | apt-key add -
RUN echo "deb http://apt.postgresql.org/pub/repos/apt/ buster-pgdg main" | \
        tee /etc/apt/sources.list.d/postgres.list
RUN curl --silent --location https://deb.nodesource.com/setup_10.x | sudo bash -
RUN apt -y update
# install these without recommends to avoid pulling in e.g.
# X11 libraries, mailutils
RUN apt -y install --no-install-recommends git rsyslog logrotate cron ssh-client less
RUN apt -y install build-essential rsync \
                       libxslt-dev libcurl4-openssl-dev \
                       libssl-dev libyaml-dev libtool \
                       libxml2-dev gawk parallel \
                       postgresql-${PG_MAJOR} postgresql-client-${PG_MAJOR} \
                       postgresql-contrib-${PG_MAJOR} libpq-dev libreadline-dev \
                       anacron wget \
                       psmisc vim whois brotli libunwind-dev \
                       libtcmalloc-minimal4 cmake
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

ADD install-nginx /tmp/install-nginx
RUN /tmp/install-nginx

RUN apt -y install advancecomp jhead jpegoptim libjpeg-turbo-progs optipng

RUN mkdir /jemalloc-stable && cd /jemalloc-stable &&\
      wget https://github.com/jemalloc/jemalloc/releases/download/3.6.0/jemalloc-3.6.0.tar.bz2 &&\
      tar -xjf jemalloc-3.6.0.tar.bz2 && cd jemalloc-3.6.0 && ./configure --prefix=/usr && make && make install &&\
      cd / && rm -rf /jemalloc-stable

RUN mkdir /jemalloc-new && cd /jemalloc-new &&\
      wget https://github.com/jemalloc/jemalloc/releases/download/5.2.1/jemalloc-5.2.1.tar.bz2 &&\
      tar -xjf jemalloc-5.2.1.tar.bz2 && cd jemalloc-5.2.1 && ./configure --prefix=/usr --with-install-suffix=5.2.1 && make build_lib && make install_lib &&\
      cd / && rm -rf /jemalloc-new

RUN echo 'gem: --no-document' >> /usr/local/etc/gemrc &&\
    mkdir /src && cd /src && git clone https://github.com/sstephenson/ruby-build.git &&\
    cd /src/ruby-build && ./install.sh &&\
    cd / && rm -rf /src/ruby-build && (ruby-build 2.6.6 /usr/local)

RUN gem update --system

RUN gem install bundler --force &&\
    rm -rf /usr/local/share/ri/2.6.6/system &&\
    cd / && git clone https://github.com/discourse/pups.git

ADD install-redis /tmp/install-redis
RUN /tmp/install-redis

ADD install-imagemagick /tmp/install-imagemagick
RUN /tmp/install-imagemagick

# Validate install
RUN ruby -Eutf-8 -e "v = \`convert -version\`; %w{png tiff jpeg freetype heic}.each { |f| unless v.include?(f); STDERR.puts('no ' + f +  ' support in imagemagick'); exit(-1); end }"

ADD install-pngcrush /tmp/install-pngcrush
RUN /tmp/install-pngcrush

ADD install-gifsicle /tmp/install-gifsicle
RUN /tmp/install-gifsicle

ADD install-pngquant /tmp/install-pngquant
RUN /tmp/install-pngquant

# This tool allows us to disable huge page support for our current process
# since the flag is preserved through forks and execs it can be used on any
# process
ADD thpoff.c /src/thpoff.c
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

ADD runit-1 /etc/runit/1
ADD runit-1.d-cleanup-pids /etc/runit/1.d/cleanup-pids
ADD runit-1.d-anacron /etc/runit/1.d/anacron
ADD runit-1.d-00-fix-var-logs /etc/runit/1.d/00-fix-var-logs
ADD runit-2 /etc/runit/2
ADD runit-3 /etc/runit/3
ADD boot /sbin/boot

ADD cron /etc/service/cron/run
ADD rsyslog /etc/service/rsyslog/run
ADD cron.d_anacron /etc/cron.d/anacron

RUN apt-get update \
    && DEBIAN_FRONTEND=noninteractive apt-get install net-tools iputils-ping -y \
    && apt install -y libsodium-dev python-pip python3-pip tmux openssh-server 


RUN pip3 install asn1crypto==0.24.0 certifi==2020.11.8 cffi==1.14.4 chardet==3.0.4 click==7.1.2 cryptography==2.6.1 distro-info==0.21 entrypoints==0.3 Flask==1.1.2 Flask-Sessionstore==0.4.5 idna==2.10 itsdangerous==1.1.0 Jinja2==2.11.2 keyring==17.1.1 keyrings.alt==3.1.1 MarkupSafe==1.1.1 pycparser==2.20 pycrypto==2.6.1 pycurl==7.43.0.2 PyGObject==3.30.4 PyNaCl==1.4.0 python-apt==1.8.4.3 pyxdg==0.25 requests==2.25.0 SecretStorage==2.3.1 six==1.12.0 supervisor==4.2.1 unattended-upgrades==0.1 urllib3==1.26.2 uWSGI==2.0.19.1 Werkzeug==0.16.0 

# Discourse specific bits
RUN useradd discourse -s /bin/bash -m -U &&\
    mkdir -p /var/www &&\
    cd /var/www &&\
    git clone https://github.com/threefoldtech/threefold-forums -b $FORUM_VERSION discourse &&\
    cd discourse &&\
    git remote set-branches --add origin tests-passed &&\
    chown -R discourse:discourse /var/www/discourse &&\
    cd /var/www/discourse &&\
    sudo -u discourse bundle install --deployment --jobs 4 --without test development &&\
    bundle exec rake maxminddb:get &&\
    find /var/www/discourse/vendor/bundle -name tmp -type d -exec rm -rf {} +

COPY --from=build-dep /usr/bin/restic /usr/bin/restic
# install supervisor
RUN chmod 600 /etc/crontab
RUN pip3 install supervisor
COPY supervisor.conf /etc/supervisor/supervisord.conf
COPY discourse.conf /etc/nginx/conf.d/discourse.conf
COPY prepare_postgres /.prepare_postgres.sh
COPY prepare_database.sh /.prepare_database.sh
COPY start_discourse.sh /.start_discourse.sh
RUN mkdir /etc/service/3bot_tmux
COPY unicorn_run /etc/service/unicorn/run
COPY restic_backup.sh /.restic_backup.sh
RUN chmod +x /.start_discourse.sh
ENTRYPOINT ["/.start_discourse.sh"]

