*This project has been created as part of the 42 curriculum by khaled.*

# Inception

## Description

Inception is a system administration project from the 42 curriculum. The goal is to set up a small infrastructure composed of different services running in Docker containers, all orchestrated with Docker Compose.

The stack includes:
- **MariaDB** — database server storing all WordPress data
- **WordPress + PHP-FPM** — the web application, running without NGINX
- **NGINX** — reverse proxy, the only entry point via HTTPS (port 443)

All containers are built from scratch using custom Dockerfiles based on `debian:bullseye`. No pre-built images are used (except the base OS).

### Docker in This Project

Docker is used to isolate each service in its own container. Each container has a single responsibility, communicates with others via a private Docker network, and persists its data through named volumes.

#### Virtual Machines vs Docker

| | Virtual Machine | Docker Container |
|---|---|---|
| OS | Full guest OS per VM (kernel included) | Shares host kernel |
| Size | GBs | MBs |
| Startup | Minutes | Seconds |
| Isolation | Full hardware virtualization | Process-level isolation |
| Use case | Run different OS | Run isolated services |

This project runs inside a VM (as required by 42), and Docker runs inside that VM to isolate each service.

#### Secrets vs Environment Variables

| | `.env` file | Docker Secrets |
|---|---|---|
| Purpose | Non-sensitive config | Passwords, credentials |
| Visible in `docker inspect` | ✅ Yes | ❌ No |
| Mounted in container | As env vars | As files in `/run/secrets/` |
| Examples used | `DOMAIN_NAME`, `MYSQL_USER` | `db_password`, `db_root_password` |

Passwords are stored in `secrets/` files and never committed to Git. The `.env` file only contains non-sensitive configuration.

#### Docker Network vs Host Network

| | Docker Bridge Network | Host Network |
|---|---|---|
| Isolation | Containers isolated from host | Container shares host network stack |
| DNS | Container names resolve automatically | No built-in DNS |
| Security | ✅ Safer | ❌ Less secure |
| 42 rule | ✅ Required | ❌ Forbidden |

This project uses a custom bridge network named `inception`. Containers communicate using service names (e.g., `mariadb`, `wordpress`) — Docker resolves these automatically via its internal DNS.

#### Docker Volumes vs Bind Mounts

| | Named Volumes | Bind Mounts |
|---|---|---|
| Data location | Managed by Docker | Specific host path |
| Subject requirement | ✅ Required | ❌ Forbidden for persistent data |
| Used for | MariaDB data, WordPress files | Not used |
| Path | `/home/khaled/data/` | — |

This project uses named volumes with `driver_opts` to store data at `/home/khaled/data/db` and `/home/khaled/data/wordpress` on the host machine.

---

## Instructions

### Requirements

- Docker and Docker Compose installed
- `sudo` access (for `/etc/hosts` and volume directories)
- Git

### Installation

```bash
git clone https://github.com/khaled/inception.git
cd inception
```

Create the secrets files (never commit these):

```bash
echo "your_wp_password" > secrets/db_password.txt
echo "your_root_password" > secrets/db_root_password.txt
cat > secrets/credentials.txt << 'CREDS'
wp_admin_user=your_admin_username
wp_admin_password=your_admin_password
wp_admin_email=your@email.com
CREDS
```

Create the `.env` file:

```bash
cat > srcs/.env << 'ENV'
DOMAIN_NAME=khaled.42.fr
MYSQL_USER=wpuser
MYSQL_DATABASE=wordpress
ENV
```

### Running the Project

```bash
# Build and start all services
make

# Stop all containers
make down

# Full reset (removes all data)
make fclean

# Full reset and rebuild
make re
```

### Accessing the Site

Add to `/etc/hosts` (done automatically by `make`):
```
127.0.0.1 khaled.42.fr
```

- Website: `https://khaled.42.fr`
- Admin panel: `https://khaled.42.fr/wp-admin`

> Note: The browser will show an SSL warning because the certificate is self-signed. Click "Advanced" → "Accept Risk and Continue".

---

## Resources

### Documentation
- [Docker official docs](https://docs.docker.com/)
- [Docker Compose reference](https://docs.docker.com/compose/)
- [MariaDB Docker setup](https://mariadb.com/kb/en/installing-and-using-mariadb-via-docker/)
- [PHP-FPM configuration](https://www.php.net/manual/en/install.fpm.configuration.php)
- [NGINX reverse proxy guide](https://nginx.org/en/docs/http/ngx_http_fastcgi_module.html)
- [WP-CLI documentation](https://wp-cli.org/)
- [OpenSSL self-signed certificates](https://www.openssl.org/docs/)
- [Docker secrets](https://docs.docker.com/engine/swarm/secrets/)

### AI Usage

AI (Claude by Anthropic) was used during this project for:

- **Understanding concepts** — Docker layers, PID 1, FastCGI, TLS, socket files, and the difference between volumes/bind mounts/secrets/env vars.
- **Debugging** — identifying why MariaDB users were not being created (volume not being cleared between runs), why `mysqladmin` was not found in the WordPress container, and why PHP-FPM was failing without `/run/php/`.
- **Code explanation** — understanding each line of the Dockerfiles, `setup.sh` scripts, `nginx.conf`, and `docker-compose.yml` before writing them.
- **Architecture overview** — visualizing the full request flow from browser to MariaDB and back.

All AI-generated content was reviewed, tested, and understood before being included in the project.