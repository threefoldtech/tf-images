#!/bin/bash

# Create funkwhale system user
sudo useradd --system --shell /bin/bash --create-home --home-dir /srv/funkwhale funkwhale

# Change to Funkwhale directory
cd /srv/funkwhale/

# Download the Docker Compose file and environment file for the specified Funkwhale version
curl -L -o /srv/funkwhale/docker-compose.yml "https://dev.funkwhale.audio/funkwhale/funkwhale/raw/${FUNKWHALE_VERSION}/deploy/docker-compose.yml"
curl -L -o /srv/funkwhale/.env "https://dev.funkwhale.audio/funkwhale/funkwhale/raw/${FUNKWHALE_VERSION}/deploy/env.prod.sample"

# Update the FUNKWHALE_VERSION in the .env file
sed -i "s/FUNKWHALE_VERSION=latest/FUNKWHALE_VERSION=$FUNKWHALE_VERSION/" .env

# Set appropriate permissions for the .env file
chmod 600 /srv/funkwhale/.env

# Generate a random Django secret key and update the .env file
DJANGO_SECRET=$(openssl rand -base64 45)
sed -i "/DJANGO_SECRET_KEY=/DJANGO_SECRET_KEY=$DJANGO_SECRET/" .env

# Pull the latest Docker images for Funkwhale
docker compose pull

# Start PostgreSQL service
docker compose up -d postgres

# Run database migrations
docker compose run --rm api funkwhale-manage migrate

# Create a superuser using the provided credentials
docker compose run --rm -T api funkwhale-manage fw users create --superuser << EOF
$FUNKWHALE_SUPERUSER_NAME
$FUNKWHALE_SUPERUSER_PASSWORD
$FUNKWHALE_SUPERUSER_EMAIL
EOF

# Start Funkwhale services
docker compose up -d

# Configure temporary Nginx config for Certbot verification
cat <<EOF | sudo tee /etc/nginx/sites-available/funkwhale
server {
    listen 80;
    server_name funkwhale.peter.ourworld.tf;

    location /.well-known/acme-challenge/ {
        root /var/www/html;
    }

    location / {
        return 301 https://\$host\$request_uri;
    }
}
EOF

# Enable the temporary Nginx site
ln -s /etc/nginx/sites-available/funkwhale /etc/nginx/sites-enabled/

# Generate SSL certificate using Certbot
certbot --nginx -d $Domain --non-interactive --agree-tos --register-unsafely-without-email --redirect

# Download and apply the Funkwhale Nginx proxy configuration
curl -L -o /etc/nginx/funkwhale_proxy.conf "https://dev.funkwhale.audio/funkwhale/funkwhale/raw/$FUNKWHALE_VERSION/deploy/funkwhale_proxy.conf"
curl -L -o /etc/nginx/sites-available/funkwhale.template "https://dev.funkwhale.audio/funkwhale/funkwhale/raw/$FUNKWHALE_VERSION/deploy/docker.proxy.template"

# Apply environment variables and substitute into the Nginx template
set -a && source /srv/funkwhale/.env && set +a
envsubst "`env | awk -F = '{printf \" $%s\", $$1}'`" < /etc/nginx/sites-available/funkwhale.template > /etc/nginx/sites-available/funkwhale.conf

# Enable the final Funkwhale Nginx site
ln -s /etc/nginx/sites-available/funkwhale.conf /etc/nginx/sites-enabled/


# Reload Nginx to apply SSL configuration
zinit stop nginx
zinit start nginx
