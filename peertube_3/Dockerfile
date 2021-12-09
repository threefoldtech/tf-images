
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

USER peertube

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

ENV PUB_KEY="ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDZnBgLQt77C1suFHsBH5sNdbTxcCCiowDPB+U8h0OsT7onOg/HCYGEguUh9yl5VlacODXSexBhg9LsFTDuO/nBTf/DQVpjqRGQs1QenoGrpaxxaI5Svo5GBLE3Jogva/fhbJtwK9yEgW+1zltO3rTp+sdQ7JFG3uZGnlLSN1U+PCJVzONM2BaAGkQ6XHHuCCiisMlNgWXUzN3T+DjkzHWbXyqPEoK/gSkV20QzWbDRzxM/FJNIOZZh70H+n3QcSl9Q5VTfhc2K1rMNnGRQrl2QHcBsPoO/8dYJxKGt/u9pZI3wkE5C0coYtNvfXIcNj7cSsSJIvCdYYl6x4LkxXhwrOomOwmtZTmJEewe0nhClDU4gMm4s3eET7j2GPe73Ft2OVuF9j+3z0K3jUFQ/2m3HmDDtNVYlB7IOL5479cLRfBBvvQuNpd0p1yBUopxoBureFdqgZYa5887BcUENOKiR58JgF1mZ15g4nnUrdkXqm7KhQgniAp9E68MdsJEg9t0= omar@jarvis"

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
#COPY ./startup.sh /app

ENV PEERTUBE_DB_SUFFIX=_prod
ENV PEERTUBE_DB_USERNAME=peertube
ENV PEERTUBE_DB_PASSWORD=peertube
ENV PEERTUBE_DB_HOSTNAME=localhost
ENV PEERTUBE_REDIS_HOSTNAME=localhost
ENV PEERTUBE_WEBSERVER_HOSTNAME=0.0.0.0
ENV PEERTUBE_WEBSERVER_PORT=9000
# ENV PEERTUBE_SMTP_HOSTNAME=incubaid.com
# ENV PEERTUBE_SMTP_PORT=25
# ENV PEERTUBE_SMTP_FROM=noreply@incubaid.com
# ENV PEERTUBE_SMTP_TLS=false
# ENV PEERTUBE_SMTP_DISABLE_STARTTLS=false
ENV PEERTUBE_ADMIN_EMAIL=abdulazizo@incubaid.com
ENV PEERTUBE_SIGNUP_ENABLED=true

ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]

# Expose API and RTMP
EXPOSE 9000 1935
# RUN update-rc.d redis-server defaults
# RUN update-rc.d postgresql defaults
# RUN update-rc.d ssh defaults
# Run the application


CMD ["npm", "start"]
#CMD ["bash", "startup.sh"]
# CMD sleep infinity
