#!/bin/sh

set -e

#	Check secrets exist
[ ! -f /run/secrets/db_pwd.txt ] && echo "❌ Missing db_pwd.txt secret" && exit 1
[ ! -f /run/secrets/wp_admin_pwd.txt ] && echo "❌ Missing wp_admin_pwd.txt secret" && exit 1
[ ! -f /run/secrets/wp_user_pwd.txt ] && echo "❌ Missing wp_user_pwd.txt secret" && exit 1

#	Injection of secrets
export DB_PWD=$(cat /run/secrets/db_pwd.txt)
export WP_ADMIN_PWD=$(cat /run/secrets/wp_admin_pwd.txt)
export WP_USER_PWD=$(cat /run/secrets/wp_user_pwd.txt)

#	Check env variables
[ -z "$DB_HOST" ] && echo "❌ DB_HOST not set" && exit 1
[ -z "$DB_NAME" ] && echo "❌ DB_NAME not set" && exit 1
[ -z "$DB_USER" ] && echo "❌ DB_USER not set" && exit 1
[ -z "$DB_PWD" ] && echo "❌ DB_PWD not set" && exit 1
[ -z "$DB_PORT" ] && echo "❌ DB_PORT not set" && exit 1
[ -z "$WP_ADMIN" ] && echo "❌ WP_ADMIN not set" && exit 1
[ -z "$WP_ADMIN_PWD" ] && echo "❌ WP_ADMIN_PWD not set" && exit 1
[ -z "$WP_USER" ] && echo "❌ WP_USER not set" && exit 1
[ -z "$WP_USER_PWD" ] && echo "❌ WP_USER_PWD not set" && exit 1
[ -z "$WP_URL" ] && echo "❌ WP_URL not set" && exit 1
[ -z "$WP_ADMIN_MAIL" ] && echo "❌ WP_ADMIN_MAIL not set" && exit 1
[ -z "$REDIS_HOST" ] && echo "❌ REDI_HOST not set" && exit 1
[ -z "$REDIS_PORT" ] && echo "❌ REDI_PORT not set" && exit 1
[ -z "$REDIS_DB" ] && echo "❌ REDI_DB not set" && exit 1

echo "⚙️ Configuring PHP-FPM..."
cp /scripts/php-pool.conf /usr/local/etc/php-fpm.d/www.conf

echo "🔧 Fixing ownership of WordPress folder..."
chown -R www-data:www-data /var/www/html
chmod -R 775 /var/www/html

echo "⚙️ Configuring WordPress..."
sh /scripts/setup_wordpress.sh

echo "🚀 Starting php-fpm..."
exec php-fpm -F
