#!/bin/sh

WP_PATH="/var/www/html"

REQUIRED_VARS=("WORDPRESS_DB_HOST" "WORDPRESS_DB_USER" "WORDPRESS_DB_PASSWORD" "WORDPRESS_DB_NAME" "WP_URL" "WP_TITLE" "WP_ADMIN" "WP_ADMIN_PASSWORD" "WP_ADMIN_EMAIL")

for var in "${REQUIRED_VARS[@]}"; do
	if [ -z "$(eval echo \$$var ]; then
		echo "🚨	Error: Environment variable $var is not set."
		exit 1
	fi
done

if [ ! -f "$WP_PATH/wp-config.php" ]; then
    echo "📥	Dowloading of WordPress..."
    wp core download --allow-root --path=$WP_PATH

    echo "⚙️	Configuration of WordPress..."
    wp config create \
        --dbname="$WORDPRESS_DB_NAME" \
        --dbuser="$WORDPRESS_DB_USER" \
        --dbpass="$WORDPRESS_DB_PASSWORD" \
        --dbhost="$WORDPRESS_DB_HOST" \
        --allow-root --path=$WP_PATH

    echo "🚀	Installation of WordPress..."
    wp core install \
        --url="$WP_URL" \
        --title="$WP_TITLE" \
        --admin_user="$WP_ADMIN" \
        --admin_password="$WP_ADMIN_PASSWORD" \
        --admin_email="$WP_ADMIN_EMAIL" \
        --allow-root --path=$WP_PATH

    echo "🛠️	Puting some permissions..."
    chown -R www-data:www-data $WP_PATH
    chmod -R 755 $WP_PATH
fi