FROM presearch/node:latest
LABEL maintainer="abdul@incubaid.com"
RUN apk update
RUN apk add --no-cache --upgrade bash 
RUN apk --no-cache add apache2 php7 php7-apache2 sudo curl jq 
COPY config/presearch /var/www/localhost/htdocs/
COPY config/cronjobs /tmp/
COPY scripts/check* /usr/bin/
COPY scripts/start_presearch.sh /
ENTRYPOINT ["/start_presearch.sh"]
