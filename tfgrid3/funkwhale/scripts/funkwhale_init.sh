echo "DATABASE_URL=postgresql://$FUNKWHALE_DB_USER:$FUNKWHALE_DB_PASSWORD@localhost/$FUNKWHALE_DB_NAME" >> /srv/funkwhale/config/.env
echo "FUNKWHALE_HOSTNAME=$FUNKWHALE_HOSTNAME" >> /srv/funkwhale/config/.env
# Set up database
sudo -u postgres psql -c "CREATE DATABASE $FUNKWHALE_DB_NAME WITH ENCODING 'UTF8';"
sudo -u postgres psql -c "CREATE USER $FUNKWHALE_DB_USER WITH ENCRYPTED PASSWORD '$FUNKWHALE_DB_PASSWORD';"
sudo -u postgres psql -c "GRANT ALL PRIVILEGES ON DATABASE $FUNKWHALE_DB_NAME TO $FUNKWHALE_DB_USER;"
sudo -u postgres psql $FUNKWHALE_DB_NAME -c 'CREATE EXTENSION "unaccent";'
sudo -u postgres psql $FUNKWHALE_DB_NAME -c 'CREATE EXTENSION "citext";'

# Set up funkwhale db, superuser, frontedn files
sudo -u funkwhale /srv/funkwhale/venv/bin/funkwhale-manage migrate
sudo -u funkwhale /srv/funkwhale/venv/bin/funkwhale-manage fw users create --superuser --username $SUPERUSER_USERNAME --email $SUPERUSER_EMAIL --password $SUPERUSER_PASSWORD
sudo -u funkwhale /srv/funkwhale/venv/bin/funkwhale-manage collectstatic
