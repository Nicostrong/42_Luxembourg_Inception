#!/bin/sh

set -e

if [ -f /run/secrets/.env ]; then
    set -a
    . /run/secrets/.env
    set +a
fi

export DB_PWD=$(cat /run/secrets/db_pwd.txt)
export WP_PWD=$(cat /run/secrets/wp_pwd.txt)

for var in DB_HOST DB_USER DB_NAME WP_URL WP_ADMIN WP_MAIL; do
    eval value=\$$var
    [ -z "$value" ] && echo "❌ $var not set in .env" && exit 1
done

[ -z "$DB_PWD" ] && echo "❌ DB_PWD not found in secrets" && exit 1
[ -z "$WP_PWD" ] && echo "❌ WP_PWD not found in secrets" && exit 1


echo "⌛ Waiting for MariaDB at $DB_HOST..."
until nc -z "$DB_HOST" 3306; do
  sleep 1
done

sed -i 's|127.0.0.1:9000|0.0.0.0:9000|' /etc/php*/php-fpm.d/www.conf

echo "⚙️ Configuring WordPress..."
sh /scripts/setup_wordpress.sh

echo "🚀 Starting php-fpm..."
exec php-fpm84 -F
