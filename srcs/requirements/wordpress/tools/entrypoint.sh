#!/bin/sh

host="mariadb"
port=3306
WP_DB_HOST=$(cat /run/secrets/wp_host.txt)
WP_DB_USER=$(cat /run/secrets/db_user.txt)
WP_DB_PASSWORD=$(cat /run/secrets/db_password.txt)
WP_DB_NAME=$(cat /run/secrets/db_name.txt)
WP_URL=$(cat /run/secrets/wp_url.txt)
WP_TITLE="My inception"
WP_ADMIN=$(cat /run/secrets/wp_admin.txt)
WP_ADMIN_PASSWORD=$(cat /run/secrets/wp_password.txt)
WP_ADMIN_EMAIL=$(cat /run/secrets/wp_mail.txt)

echo "⏳ Waitting deployement of MariaDB on $host:$port ..."
until ping -c 1 "$host" > /dev/null 2>&1; do
  echo "⏳ Still waiting for DNS resolution of $host ..."
  sleep 1
done

until mariadb --host="$host" --port="$port" --connect-timeout=2 -u"$WP_DB_USER" -p"$WP_DB_PASSWORD" -e "SELECT 1;" > /dev/null 2>&1; do
  echo "⌛ Waiting for MariaDB SQL port $port..."
  sleep 1
done

echo "✅ Mariadb deployed, launching of WordPress !"

echo "Setting up Wordpress ..."
sh setup_wordpress.sh

echo "Starting php-fpm84 ..."
exec php-fpm84 -F
