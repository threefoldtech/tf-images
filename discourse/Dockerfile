FROM  bishoyabdo/tf_discourse:latest
RUN apt-get update \
    && DEBIAN_FRONTEND=noninteractive apt-get install net-tools -y
COPY start_postgres /.start_postgres.sh
COPY prepare_database.sh /.prepare_database.sh
COPY start_discourse.sh /.start_discourse.sh
RUN chmod +x /.discourse_startup.sh
ENTRYPOINT ["/.start_discourse.sh"]
