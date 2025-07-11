#!/bin/sh

set -e

export DB_HOST=$(cat /run/secrets/wp_host.txt)
export DB_USER=$(cat /run/secrets/db_user.txt)
export DB_PWD=$(cat /run/secrets/db_pwd.txt)
export DB_NAME=$(cat /run/secrets/db_name.txt)
export WP_URL=$(cat /run/secrets/wp_url.txt)
export WP_ADMIN=$(cat /run/secrets/wp_admin.txt)
export WP_PWD=$(cat /run/secrets/wp_pwd.txt)
export WP_MAIL=$(cat /run/secrets/wp_mail.txt)

for var in DB_HOST DB_USER DB_PWD DB_NAME WP_URL WP_ADMIN WP_PWD WP_MAIL; do
  eval value=\$$var
  [ -z "$value" ] && echo "❌ $var not set" && exit 1
done

echo "⌛ Waiting for MariaDB at $DB_HOST..."
until nc -z "$DB_HOST" 3306; do
  sleep 1
done

sed -i 's|127.0.0.1:9000|0.0.0.0:9000|' /etc/php*/php-fpm.d/www.conf

echo "⚙️ Configuring WordPress..."
sh /scripts/setup_wordpress.sh

echo "🚀 Starting php-fpm..."
exec php-fpm84 -F
