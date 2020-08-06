
FROM ruby
RUN apt-get -y update && apt-get -y install git nginx openssh-server certbot python-certbot-nginx libicu-dev cmake && rm -rf /var/lib/apt/lists/*

RUN gem install github-linguist
RUN gem install gollum
RUN gem install org-ruby  # optional

# gollum scripts
COPY config.rb /tmp/config.rb
COPY post-commit /tmp/post-commit

# nginx server for serving gollum
COPY nginx.conf /etc/nginx/sites-available/gollum.conf

COPY start.sh /start.sh
RUN chmod +x /start.sh
# start.sh will be run in entrypoint provided on container deploy
