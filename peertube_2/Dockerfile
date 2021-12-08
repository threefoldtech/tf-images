FROM ubuntu:latest

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update &&\
    apt-get install -y curl wget certbot vim unzip nginx sudo ffmpeg g++ make gnupg python python3-dev openssl postgresql postgresql-contrib redis-server &&\
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

RUN useradd -m -s /bin/bash -p peertube peertube &&\
    chown -Rc peertube /var/www/peertube/ &&\
    cd /var/www/peertube/peertube-latest &&\
    sudo -H -u peertube yarn install --production --pure-lockfile

RUN chown -Rc redis:redis /etc/redis &&\
    chown -Rc redis:redis /var/log/redis

COPY ./setup_postgres.sql /init/setup_postgres.sql

RUN service postgresql start &&\
    su postgres -c "psql --file=/init/setup_postgres.sql"

RUN cd /var/www/peertube/ &&\
    sudo -u peertube cp peertube-latest/config/default.yaml config/default.yaml &&\
    sudo -u peertube cp peertube-latest/config/production.yaml.example config/production.yaml &&\
    sudo -u peertube sed -zi "s/listen:\n  hostname: 'localhost'/listen:\n  hostname: '0.0.0.0'/" config/production.yaml &&\
    cd /etc/init.d/ &&\
    cp /var/www/peertube/peertube-latest/support/init.d/peertube . &&\
    chmod --reference=redis-server peertube

# # Skip nginx configrutions for now

# ENV PTHOST='peertube.test'

# RUN sudo cp /var/www/peertube/peertube-latest/support/nginx/peertube /etc/nginx/sites-available/peertube &&\
#     sudo sed -i 's/${WEBSERVER_HOST}/'$PTHOST'/g' /etc/nginx/sites-available/peertube &&\
#     sudo sed -i 's/${PEERTUBE_HOST}/127.0.0.1:9000/g' /etc/nginx/sites-available/peertube &&\
#     sudo ln -s /etc/nginx/sites-available/peertube /etc/nginx/sites-enabled/peertube &&\
#     echo "127.0.0.1  $PTHOST" >> /etc/hosts 

# RUN mkdir -p /etc/letsencrypt/live/$PTHOST/ &&\
#     openssl req -x509 -nodes -days 365 \
#     -subj  "/C=CA/ST=QC/O=Company Inc/CN=example.com" \
#     -newkey rsa:2048 -keyout /etc/letsencrypt/live/$PTHOST/privkey.pem \
#     -out /etc/letsencrypt/live/$PTHOST/fullchain.pem &&\
#     service nginx reload

COPY ./start.sh /start.sh

RUN chmod +x /start.sh

WORKDIR /var/www/peertube/peertube-latest

VOLUME /var/www/peertube/storage

EXPOSE 9000

CMD ["/start.sh"]
