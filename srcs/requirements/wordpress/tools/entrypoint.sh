#!/bin/sh

echo "⏳ Waitting deployement of MariaDB..."
until nc -z mariadb 3306; do
  sleep 2
done
echo "✅ Mariadb deploed, launching of WordPress !"
WORDPRESS_DB_PASSWORD=$(cat /run/secrets/db_password.txt)

echo "Setting up Wordpress ..."
sh setup_wordpress.sh

echo "Starting php-fpm84 ..."
exec php-fpm84 -F
