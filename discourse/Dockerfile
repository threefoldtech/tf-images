FROM  bishoyabdo/tf_discourse:latest
RUN apt-get update \
    && DEBIAN_FRONTEND=noninteractive apt-get install net-tools iputils-ping -y \
    && apt install -y libsodium-dev 
COPY start_postgres /.start_postgres.sh
COPY prepare_database.sh /.prepare_database.sh
COPY start_discourse.sh /.start_discourse.sh
COPY backup.sh /.backup.sh
RUN chmod +x /.start_discourse.sh
ENTRYPOINT ["/.start_discourse.sh"]
