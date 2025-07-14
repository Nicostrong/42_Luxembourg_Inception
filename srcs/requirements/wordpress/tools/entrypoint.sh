#!/bin/sh

set -e

#	Check secrets exist
[ ! -f /run/secrets/db_pwd.txt ] && echo "❌ Missing db_pwd.txt secret" && exit 1
[ ! -f /run/secrets/wp_pwd.txt ] && echo "❌ Missing wp_pwd.txt secret" && exit 1

#	Injection of secrets
export DB_PWD=$(cat /run/secrets/db_pwd.txt)
export WP_PWD=$(cat /run/secrets/wp_pwd.txt)

#	Check env variables
[ -z "$DB_HOST" ] && echo "❌ DB_HOST not set" && exit 1
[ -z "$DB_NAME" ] && echo "❌ DB_NAME not set" && exit 1
[ -z "$DB_USER" ] && echo "❌ DB_USER not set" && exit 1
[ -z "$DB_PWD" ] && echo "❌ DB_PWD not set" && exit 1
[ -z "$DB_PORT" ] && echo "❌ DB_PORT not set" && exit 1
[ -z "$WP_ADMIN" ] && echo "❌ WP_ADMIN not set" && exit 1
[ -z "$WP_PWD" ] && echo "❌ WP_PWD not set" && exit 1
[ -z "$WP_URL" ] && echo "❌ WP_URL not set" && exit 1
[ -z "$WP_MAIL" ] && echo "❌ WP_MAIL not set" && exit 1


echo "⌛ Waiting for MariaDB at $DB_HOST:$DB_PORT..."
i=0
while ! nc -z "$DB_HOST" "$DB_PORT"; do
	sleep 10
	i=$((i+1))
	[ $i -gt 30 ] && echo "❌ Timeout waiting for DB" && exit 1
done

sed -i 's|127.0.0.1:9000|0.0.0.0:9000|' /etc/php84/php-fpm.d/www.conf

echo "⚙️ Configuring WordPress..."
sh /scripts/setup_wordpress.sh

echo "🚀 Starting php-fpm..."
exec php-fpm84 -F
