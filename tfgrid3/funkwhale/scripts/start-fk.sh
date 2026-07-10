#!/bin/bash
set -ex

# Check if FUNKWHALE_VERSION is set, if not, default to 1.4.0
FUNKWHALE_VERSION=${FUNKWHALE_VERSION:-1.4.0}

# Change to Funkwhale directory
mkdir -p /srv/funkwhale/
cd /srv/funkwhale/

# Download the Docker Compose and environment files for the specified version
curl -L -o docker-compose.yml "https://dev.funkwhale.audio/funkwhale/funkwhale/raw/${FUNKWHALE_VERSION}/deploy/docker-compose.yml"
curl -L -o .env "https://dev.funkwhale.audio/funkwhale/funkwhale/raw/${FUNKWHALE_VERSION}/deploy/env.prod.sample"

# Set appropriate permissions for the .env file
chmod 600 .env

# Generate a random Django secret key and update the .env file
DJANGO_SECRET=$(openssl rand -base64 45)
sed -i "s#^DJANGO_SECRET_KEY=.*#DJANGO_SECRET_KEY=$DJANGO_SECRET#" .env

# Add environment variables to the .env file
sed -i "s#^FUNKWHALE_VERSION=.*#FUNKWHALE_VERSION=$FUNKWHALE_VERSION#" .env
sed -i "s#^FUNKWHALE_HOSTNAME=.*#FUNKWHALE_HOSTNAME=$domain#" .env
sed -i "s#^FUNKWHALE_HOSTNAME=.*#FUNKWHALE_HOSTNAME=$FUNKWHALE_HOSTNAME#" .env
sed -i "s#^FUNKWHALE_API_IP=.*#FUNKWHALE_API_IP=0.0.0.0#" .env
sed -i 's/^FUNKWHALE_API_PORT=.*/FUNKWHALE_API_PORT=80/' .env

# Pull the latest Docker images for Funkwhale
docker-compose pull

# Start PSQL service
docker-compose up -d postgres

# Waiting for postgres to be ready
echo "[INFO] Waiting for PostgreSQL to be ready..."
until docker-compose exec -T postgres pg_isready -U funkwhale > /dev/null 2>&1; do
  echo "[INFO] PostgreSQL not ready yet. Retrying in 5s..."
  sleep 5
done

echo "[SUCCESS] PostgreSQL is ready. Continuing..."

# Run database migrations
docker-compose run --rm api funkwhale-manage migrate

# Create a superuser using the provided credentials
USER_INPUT=$(printf "%s\n%s\n%s" \
  "$FUNKWHALE_SUPERUSER_NAME" \
  "$FUNKWHALE_SUPERUSER_PASSWORD" \
  "$FUNKWHALE_SUPERUSER_EMAIL")

echo "$USER_INPUT" | docker-compose run --rm -T api funkwhale-manage fw users create --superuser

# Start Funkwhale services
docker-compose up -d
