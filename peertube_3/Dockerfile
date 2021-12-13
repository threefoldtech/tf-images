
FROM node:12-buster-slim

# Allow to pass extra options to the npm run build
# eg: --light --light-fr to not build all client languages
#     (speed up build time if i18n is not required)
ARG NPM_RUN_BUILD_OPTS

# Install dependencies
RUN apt update \
    && apt install -y --no-install-recommends openssl ffmpeg python ca-certificates gnupg gosu build-essential postgresql postgresql-contrib redis-server openssh-server sudo\
    && rm /var/lib/apt/lists/* -fR

COPY ./app /app 

WORKDIR /app


RUN yarn install --pure-lockfile \
    && npm run build -- $NPM_RUN_BUILD_OPTS \
    && rm -r ./node_modules ./client/node_modules \
    && yarn install --pure-lockfile --production \
    && yarn cache clean


RUN mkdir /data /config

ENV NODE_ENV production
ENV NODE_CONFIG_DIR /config

VOLUME /data
VOLUME /config


# # Custome config for redis & postgres & ssh
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



ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]

# Expose API and RTMP
EXPOSE 9000 1935

CMD ["npm", "start"]
