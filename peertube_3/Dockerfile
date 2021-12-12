
FROM node:12-buster-slim

# Allow to pass extra options to the npm run build
# eg: --light --light-fr to not build all client languages
#     (speed up build time if i18n is not required)
ARG NPM_RUN_BUILD_OPTS

# Install dependencies
RUN apt update \
    && apt install -y --no-install-recommends openssl ffmpeg python ca-certificates gnupg gosu build-essential \
    && gosu nobody true \
    && rm /var/lib/apt/lists/* -fR

# Add peertube user
RUN groupadd -r peertube \
    && useradd -r -g peertube -m peertube

# Install PeerTube
# change from where you copy the app
COPY --chown=peertube:peertube ./app /app 

WORKDIR /app

#USER peertube

RUN yarn install --pure-lockfile \
    && npm run build -- $NPM_RUN_BUILD_OPTS \
    && rm -r ./node_modules ./client/node_modules \
    && yarn install --pure-lockfile --production \
    && yarn cache clean

USER root

RUN mkdir /data /config
RUN chown -R peertube:peertube /data /config

ENV NODE_ENV production
ENV NODE_CONFIG_DIR /config

VOLUME /data
VOLUME /config


# # Custome config for redis & postgres & ssh

RUN apt-get update &&\
    apt-get install postgresql postgresql-contrib redis-server openssh-server sudo -y


RUN mkdir -p /root/.ssh/ &&\
    chmod 700 /root/.ssh &&\
    touch /root/.ssh/authorized_keys &&\
    chmod 600 /root/.ssh/authorized_keys


RUN chown -Rc redis:redis /etc/redis &&\
    chown -Rc redis:redis /var/log/redis

COPY ./setup_postgres.sql /tmp/setup_postgres.sql

RUN service postgresql start &&\
    su postgres -c "psql --file=/tmp/setup_postgres.sql"

# # Edits on entrypoint 
COPY ./entrypoint.sh /usr/local/bin/entrypoint.sh


ENV PEERTUBE_DB_SUFFIX=_prod
ENV PEERTUBE_DB_USERNAME=peertube
ENV PEERTUBE_DB_PASSWORD=peertube
ENV PEERTUBE_DB_HOSTNAME=localhost
ENV PEERTUBE_REDIS_HOSTNAME=localhost
ENV PEERTUBE_WEBSERVER_HOSTNAME=0.0.0.0
ENV PEERTUBE_WEBSERVER_PORT=9000
ENV PEERTUBE_ADMIN_EMAIL=abdulazizo@incubaid.com
ENV PEERTUBE_SIGNUP_ENABLED=true
ENV PATH=$PATH:/usr/local/bin

ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]

# Expose API and RTMP
EXPOSE 9000 1935

CMD ["npm", "start"]
