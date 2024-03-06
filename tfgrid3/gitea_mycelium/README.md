# Deploying Gitea FList

This guide provides instructions on how to deploy Gitea, a self-hosted Git service, on the Grid using an FList image. This deployment leverages environment variables to configure Gitea and uses Docker Compose to manage the service components, including the Gitea server and a PostgreSQL database.

## Overview

The deployment process involves:
1. Creating an `.env` file from environment variables prefixed with `GITEA__`.
2. Starting the Docker daemon.
3. Using Docker Compose to start Gitea and PostgreSQL containers with configurations defined in `.env`.

## Step 1: Preparing the Environment Variables

Gitea's configuration is driven by environment variables. A special script (`gitea_env_init.yaml`) collects these variables and stores them in an `.env` file, which Docker Compose will later use.

### Environment Variables

The environment variables are derived from Gitea's documentation and should be prefixed with `GITEA__`. For a comprehensive list, refer to [Gitea's environment-to-ini documentation](https://github.com/go-gitea/gitea/tree/main/contrib/environment-to-ini).

Example variables include:
- `GITEA__database__DB_TYPE`: The type of database, e.g., `postgres`.
- `GITEA__database__HOST`: The database host, e.g., `db:5432`.
- `GITEA__server__HTTP_PORT`: The HTTP port Gitea should listen on.

## Step 2: Deploying the FList

Deploy the FList on the Grid, ensuring you pass the necessary `GITEA__` prefixed environment variables based on your configuration requirements.

### Zinit Configuration

1. **Gitea Environment Initialization**: A `gitea_env_init.yaml` script prepares the `.env` file by collecting all relevant environment variables.

   ```yaml
   exec: bash -c 'env | grep "GITEA__" > /docker/.env'
   oneshot: true
   ```

2. **Gitea Service Start**: The `gitea.yaml` script utilizes Docker Compose to launch the Gitea service, waiting for the Docker daemon to start.

   ```yaml
   exec: docker-compose -f /docker/docker-compose.yaml up -d
   after:
       - dockerd
   oneshot: true
   ```

### Docker Compose Configuration

The `docker-compose.yaml` defines the Gitea and PostgreSQL services, utilizing the `.env` file for configuration, with defaults provided for a streamlined setup process:

- Gitea service setup includes volume mappings for persistence, port configurations, and dependency on the PostgreSQL database.
- PostgreSQL service setup includes environment variables for the database configuration.

### Handling Default Settings
The Docker Compose file intelligently defaults unspecified environment variables to ensure Gitea and PostgreSQL services are correctly configured without requiring exhaustive manual settings.


#### Gitea Service Defaults

HTTP Port: If `GITEA__server__HTTP_PORT` is not set, Gitea will default to listening on port `3000`.

SSH Port: If `GITEA__server__SSH_PORT` is not set, Gitea will default to listening on port `222`.

#### Gitea Database Configuration:

`GITEA__database__DB_TYPE`: Defaults to `postgres` if not specified.

`GITEA__database__NAME, GITEA__database__USER`, and `GITEA__database__PASSWD`: Default to `gitea` if not provided.

#### PostgreSQL Service Defaults :

Database Name: If `GITEA__database__NAME` is not set, the PostgreSQL service will use `gitea` as the default database name.

User and Password: If `GITEA__database__USER` and `GITEA__database__PASSWD` are not provided, both will default to `gitea`, ensuring that the database service can start without requiring explicit configuration.


```yaml
version: "3"

networks:
  gitea:
    external: false

services:
  server:
    image: gitea/gitea:latest
    container_name: gitea
    environment:
      - USER_UID=1000
      - USER_GID=1000
      - GITEA__database__DB_TYPE=postgres
      - GITEA__database__HOST=db:5432
      - GITEA__database__NAME=${GITEA_DATABASE_DB:-gitea}
      - GITEA__database__USER=${GITEA_DATABASE_USER:-gitea}
      - GITEA__database__PASSWD=${GITEA_DATABASE_PASSWORD:-gitea}
    restart: always
    networks:
      - gitea
    volumes:
      - ./gitea:/data
      - /etc/timezone:/etc/timezone:ro
      - /etc/localtime:/etc/localtime:ro
    ports:
      - "${GITEA__server__HTTP_PORT:-3000}:3000"
      - "${GITEA__server__SSH_PORT:-222}:22"
    env_file:
      - .env
    depends_on:
      - db

  db:
    image: postgres:14
    restart: always
    environment:
      - POSTGRES_DB=${GITEA__database__NAME:-gitea}
      - POSTGRES_USER=${GITEA__database__USER:-gitea}
      - POSTGRES_PASSWORD=${GITEA__database__PASSWD:-gitea}
    networks:
      - gitea
    volumes:
      - ./postgres:/var/lib/postgresql/data
    env

_file:
      - .env
```


