# User Documentation

This project runs a small Docker-based web stack.

## Services Provided

- `mariadb`: stores the WordPress database.
- `wordpress`: serves the website through PHP-FPM.
- `nginx`: the HTTPS entry point for the site.
- `adminer`: web interface for browsing and managing the MariaDB database.
- `ftp`: FTP access to the WordPress files.
- `netdata`: system and container monitoring dashboard.
- `redis`: caching service used by the stack.
- Static website: served by nginx from the `/static/` route.

## Start and Stop

From the repository root:

```bash
make
```

This creates the required data directories, updates `/etc/hosts` if needed, and starts the containers.

To stop the stack:

```bash
make down
```

Useful cleanup commands:

```bash
make stop   # stop containers without removing them
make fclean # remove containers, volumes, and local data
make re     # full cleanup and rebuild
```

## Access the Website

Add this line to `/etc/hosts` if it is not already present:

```text
127.0.0.1 khhihi.42.fr
```

Then open:

- Website: `https://khhihi.42.fr`
- WordPress admin panel: `https://khhihi.42.fr/wp-admin`
- Static website: `https://khhihi.42.fr/static/`
- Adminer: `http://localhost:8080`
- Netdata: `http://localhost:19999`

The browser will warn about a self-signed certificate on the HTTPS site.

## Credentials

Passwords and login data are stored in the `secrets/` directory:

- `secrets/db_password.txt`
- `secrets/db_root_password.txt`
- `secrets/credentials.txt`

The `.env` file in `srcs/.env` contains non-sensitive configuration such as the domain name, database name, and database user.

To change credentials, edit the files in `secrets/` and then rebuild the stack with `make re`.

## Check Service Health

You can verify that the stack is running with:

```bash
docker compose -f srcs/docker-compose.yml ps
```

You can also inspect logs for a specific service:

```bash
docker compose -f srcs/docker-compose.yml logs nginx
docker compose -f srcs/docker-compose.yml logs wordpress
```

If the website does not load, check that the containers are running and that `khhihi.42.fr` points to `127.0.0.1` in `/etc/hosts`.
