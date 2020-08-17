FROM ubuntu:bionic

# Avoid tzdata interactive dialog
ENV DEBIAN_FRONTEND=noninteractive

# Install PeerTube's dependencies.
# Packages are from https://github.com/Chocobozzz/PeerTube#dependencies
RUN apt-get update &&\
    apt-get install -y curl ffmpeg g++ git gnupg make nano openssl postgresql postgresql-contrib redis-server &&\
    curl -sL https://deb.nodesource.com/setup_10.x | bash - &&\
    curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add - &&\
    echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list &&\
    apt-get update &&\
    apt-get install -y nodejs yarn &&\
    rm -rf /var/lib/apt/lists/* &&\
    apt-get update &&\
    mkdir -p /var/www/peertube/config /var/www/peertube/storage

# Download PeerTube's source code.
RUN git clone -b release/2.3.0 https://github.com/Chocobozzz/PeerTube /var/www/peertube/peertube-latest
WORKDIR /var/www/peertube/peertube-latest

# Install Node.js dependencies and setup PostgreSQL
COPY setup_postgres.sql /tmp/

RUN  mkdir -p /root/.ssh/ &&\
     touch /root/.ssh/authorized_keys &&\
     yarn install --pure-lockfile &&\
     npm run build -- --light &&\
     rm -r ./node_modules ./client/node_modules &&\
     yarn install --pure-lockfile --production &&\
     yarn cache clean &&\
     service postgresql start &&\
     su postgres -c "psql --file=/tmp/setup_postgres.sql"

COPY production.yaml /var/www/peertube/config/production.yaml

# Expose PeerTube sources as a volume
VOLUME /var/www/peertube/peertube-latest

# Start PostgreSQL and Redis
RUN apt-get update &&\
    apt-get install -y openssh-server

# Copy startup script
COPY startup.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/startup.sh

# CMD service postgresql start; sleep 3; service postgresql start; redis-server --daemonize yes; NODE_OPTIONS="--max-old-space-size=4096" npm run dev
