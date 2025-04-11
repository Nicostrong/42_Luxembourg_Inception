#!/bin/sh

WORDPRESS_DB_PASSWORD=$(cat /run/secrets/db_password.txt)

if [ -f /run/secrets/wp_settings ]; then
    export $(grep -v '^#' /run/secrets/wp_settings | xargs)
else
    echo "🚨 ERROR : Secrets file  /run/secrets/wp_settings notfund !" >&2
    exit 1
fi

echo "Setting up Wordpress ..."
sh /setup_wordpress.sh

echo "Starting php-fpm84 ..."
exec php-fpm84 -F
