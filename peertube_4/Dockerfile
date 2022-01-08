FROM node:12-buster-slim

RUN apt update &&\
    apt install -y --no-install-recommends sudo postgresql postgresql-contrib redis-server openssh-server openssl ffmpeg python ca-certificates gnupg gosu build-essential &&\
    rm /var/lib/apt/lists/* -fR

COPY ./app /app 

WORKDIR /app

ARG NPM_RUN_BUILD_OPTS

RUN yarn install --pure-lockfile \
    && npm run build -- $NPM_RUN_BUILD_OPTS \
    && rm -r ./node_modules ./client/node_modules \
    && yarn install --pure-lockfile --production \
    && yarn cache clean

RUN mkdir /data /config

ENV NODE_ENV production
ENV NODE_CONFIG_DIR /config

COPY ./entrypoint.sh /usr/local/bin/entrypoint.sh

VOLUME /data /config
EXPOSE 9000 1935

ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]