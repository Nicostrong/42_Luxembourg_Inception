#!/bin/bash

export WP_PATH="/var/www/html"

if [ ! -f "$WP_PATH/wp-config.php" ]; then
    echo "📥 Dowloading of WordPress..."
    wp core download --allow-root --path=$WP_PATH

    echo "⚙️ Configuration of WordPress..."
    wp config create \
        --dbname="$DB_NAME" \
        --dbuser="$DB_USER" \
        --dbpass="$DB_PWD" \
        --dbhost="$DB_HOST:3306" \
        --allow-root --path=$WP_PATH

    echo "🚀 Installation of WordPress..."
    wp core install \
        --url="$WP_URL" \
        --title="Inception nfordoxc" \
        --admin_user="$WP_ADMIN" \
        --admin_password="$WP_PWD" \
        --admin_email="$WP_MAIL" \
        --allow-root --path=$WP_PATH

    echo "🛠️ Setting permissions..."
    chown -R www-data:www-data $WP_PATH
    chmod -R 750 $WP_PATH
fi
echo "✅ Wordpress is running."
