FROM  bishoyabdo/tf_discourse:latest
RUN rm -rf /var/www/discourse
RUN apt-get update \
    && DEBIAN_FRONTEND=noninteractive apt-get install net-tools iputils-ping -y \
    && apt install -y libsodium-dev golang-go python-pip python3-pip tmux
RUN git clone https://github.com/restic/restic \
    && cd restic \
    && go run build.go \
    && cp -p restic /usr/bin/restic \
    && rm -rf restic 
RUN pip3 install uwsgi flask pynacl uwsgi requests flask_sessionstore
RUN pip3 install Werkzeug==0.16.0
# install supervisor
RUN pip3 install supervisor
COPY supervisor.conf /etc/supervisor/supervisord.conf
COPY discourse.conf /etc/nginx/conf.d/discourse.conf
COPY prepare_postgres /.prepare_postgres.sh
COPY prepare_database.sh /.prepare_database.sh
COPY start_discourse.sh /.start_discourse.sh
RUN mkdir /etc/service/3bot_tmux
COPY tmux_3bot.sh /etc/service/3bot_tmux/run
COPY restic_backup.sh /.restic_backup.sh
COPY unicorn_run /etc/service/unicorn/run
RUN chmod +x /.start_discourse.sh
ENTRYPOINT ["/.start_discourse.sh"]
