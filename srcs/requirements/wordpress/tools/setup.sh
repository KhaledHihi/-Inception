#!/bin/bash
set -e

# Read secrets
DB_PASSWORD=$(cat /run/secrets/db_password)
ADMIN_USER=$(grep wp_admin_user /run/secrets/credentials | cut -d= -f2)
ADMIN_PASSWORD=$(grep wp_admin_password /run/secrets/credentials | cut -d= -f2)
ADMIN_EMAIL=$(grep wp_admin_email /run/secrets/credentials | cut -d= -f2)

# Wait for MariaDB to be ready
until mysqladmin ping -h mariadb -u"${MYSQL_USER}" -p"${DB_PASSWORD}" --silent; do
    echo "Waiting for MariaDB..."
    sleep 2
done

cd /var/www/html #standard web root f Linux

# Download WordPress files only when they are not present
if [ ! -f wp-load.php ]; then
    wp core download --allow-root
fi

# Create wp-config only once
if [ ! -f wp-config.php ]; then
    wp config create --allow-root \
        --dbname=${MYSQL_DATABASE} \
        --dbuser=${MYSQL_USER} \
        --dbpass=${DB_PASSWORD} \
        --dbhost=mariadb
fi

# Install WordPress only once
if ! wp core is-installed --allow-root; then
    wp core install --allow-root \
        --url=https://${DOMAIN_NAME} \
        --title="Inception" \
        --admin_user=${ADMIN_USER} \
        --admin_password=${ADMIN_PASSWORD} \
        --admin_email=${ADMIN_EMAIL} \
        --skip-email
fi

# Create second user (non-admin) only if missing
if ! wp user get wpeditor --field=ID --allow-root > /dev/null 2>&1; then
    wp user create --allow-root \
        wpeditor editor@${DOMAIN_NAME} \
        --role=editor \
        --user_pass=Editor@2026
fi

# Start PHP-FPM in foreground
mkdir -p /run/php
exec php-fpm7.4 -F