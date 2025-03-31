#!/bin/sh

if [ ! -f /var/www/html/wp-config.php ]; then
	echo "Downloading WordPress..."
	wp core download --allow-root

	echo "Configuring WordPress..."
	wp config create --dbname=$DB_NAME --dbuser=$DB_USER --dbpass=$DB_PASSWORD --dbhost=$DB_HOST --allow-root
	wp core install --url=$WP_URL --title="$WP_TITLE" --admin_user=$WP_ADMIN --admin_password=$WP_ADMIN_PASS --admin_email=$WP_ADMIN_EMAIL --allow-root
fi