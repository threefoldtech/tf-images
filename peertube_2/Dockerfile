FROM ubuntu:latest

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update &&\
    apt-get install -y curl openssl wget certbot vim unzip nginx sudo ffmpeg g++ make gnupg python python3-dev openssl postgresql postgresql-contrib redis-server &&\
    curl -sL https://deb.nodesource.com/setup_16.x | bash - &&\
    curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add - &&\
    echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list &&\
    apt-get update  &&\
    apt-get install -y nodejs yarn  &&\
    rm -rf /var/lib/apt/lists/*

RUN mkdir -p /var/www/peertube &&\
    cd /var/www/peertube &&\
    mkdir config storage versions &&\
    cd /var/www/peertube/versions &&\
    VERSION=$(curl -s https://api.github.com/repos/chocobozzz/peertube/releases/latest | grep tag_name | cut -d '"' -f 4) && echo "Latest Peertube version is $VERSION" &&\
    wget -q "https://github.com/Chocobozzz/PeerTube/releases/download/${VERSION}/peertube-${VERSION}.zip" &&\
    unzip peertube-${VERSION}.zip &&\
    rm peertube-${VERSION}.zip &&\
    cd /var/www/peertube &&\
    ln -s versions/peertube-${VERSION} ./peertube-latest


RUN chown -Rc redis:redis /etc/redis &&\
    chown -Rc redis:redis /var/log/redis

COPY ./setup_postgres.sql /init/setup_postgres.sql

RUN service postgresql start &&\
    su postgres -c "psql --file=/init/setup_postgres.sql"


RUN cd /var/www/peertube/ &&\
    useradd -m -s /bin/bash -p peertube peertube &&\
    chown -Rc peertube ../peertube/ &&\
    sudo -u peertube cp peertube-latest/config/default.yaml config/default.yaml &&\
    sudo -u peertube cp peertube-latest/config/production.yaml.example config/production.yaml &&\
    cd /etc/init.d/ &&\
    cp /var/www/peertube/peertube-latest/support/init.d/peertube . &&\
    chmod --reference=redis-server peertube

WORKDIR /var/www/peertube/peertube-latest

RUN sudo -H -u peertube yarn install --production --pure-lockfile

VOLUME /var/www/peertube/storage

COPY ./start.sh /start.sh

RUN chmod +x /start.sh

CMD ["/start.sh"]
