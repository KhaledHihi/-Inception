# Developer Documentation

This project is a Docker Compose setup for the Inception stack.

## Prerequisites

- Docker and Docker Compose installed
- `sudo` access for `/etc/hosts` and local data directories
- Git

## Initial Setup

Clone the repository and create the required files:

```bash
git clone https://github.com/khaled/inception.git
cd inception
```

Create the secret files:

```bash
echo "your_wp_password" > secrets/db_password.txt
echo "your_root_password" > secrets/db_root_password.txt
cat > secrets/credentials.txt << 'CREDS'
wp_admin_user=your_admin_username
wp_admin_password=your_admin_password
wp_admin_email=your@email.com
CREDS
```

Create the environment file:

```bash
cat > srcs/.env << 'ENV'
DOMAIN_NAME=khaled.42.fr
MYSQL_USER=wpuser
MYSQL_DATABASE=wordpress
ENV
```

## Build and Launch

The Makefile is the normal entry point:

```bash
make
```

This runs `make setup` and then starts the stack with Docker Compose.

You can also use Docker Compose directly:

```bash
docker compose -f srcs/docker-compose.yml up -d --build
```

## Container Management

Common commands:

```bash
make down
make stop
make clean
make fclean
make re
```

Direct Docker Compose equivalents:

```bash
docker compose -f srcs/docker-compose.yml down
docker compose -f srcs/docker-compose.yml stop
docker compose -f srcs/docker-compose.yml logs
docker compose -f srcs/docker-compose.yml ps
```

To rebuild a single service during debugging:

```bash
docker compose -f srcs/docker-compose.yml up -d --build nginx
```

## Volumes and Persistence

Persistent data is stored on the host under `/home/khaled/data`.

- MariaDB data: `/home/khaled/data/db`
- WordPress files: `/home/khaled/data/wordpress`
- Static website files: `/home/khaled/data/static_website`

These directories are created by `make setup` and are mounted into the containers using Docker volumes with `driver_opts`.

This means the data survives container rebuilds and restarts.

To remove all local data:

```bash
make fclean
```

## Network and Access

The services run on the custom bridge network named `inception`.

If you need to access the site locally, ensure `/etc/hosts` contains:

```text
127.0.0.1 khaled.42.fr
```

## Notes for Development

- Static website content is copied into `/home//data/static_website/index.html` during `make setup`.
- The nginx container serves the static page under `/static/`.
- WordPress and MariaDB use named volumes backed by host directories, so clearing containers does not remove application data.
