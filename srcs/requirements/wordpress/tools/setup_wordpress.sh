#!/bin/bash

export WP_PATH="/var/www/html"

if [ ! -f "$WP_PATH/wp-config.php" ]; then

    echo "📥 Dowloading of WordPress..."
    i=0
    until wp core download --allow-root --path="$WP_PATH"; do
        i=$((i+1))
        [ $i -gt 5 ] && echo "❌ Failed to download WordPress after 5 tries" && exit 1
        sleep 2
    done

    echo "⚙️ Configuration of WordPress..."
    wp config create \
        --dbname="$DB_NAME" \
        --dbuser="$DB_USER" \
        --dbpass="$DB_PWD" \
        --dbhost="$DB_HOST:$DB_PORT" \
        --allow-root --path="$WP_PATH" \
        --extra-php <<PHP
define( 'WP_DEBUG', false );
define( 'DISALLOW_FILE_EDIT', true );
define( 'AUTOMATIC_UPDATER_DISABLED', true );
define('WP_HOME', 'https://nfordoxc.42.fr');
define('WP_SITEURL', 'https://nfordoxc.42.fr');
PHP

    if ! wp core is-installed --allow-root --path="$WP_PATH"; then
        echo "🚀 Installation of WordPress..."
        wp core install \
            --url="$WP_URL" \
            --title="Inception nfordoxc" \
            --admin_user="$WP_ADMIN" \
            --admin_password="$WP_PWD" \
            --admin_email="$WP_MAIL" \
            --allow-root --path="$WP_PATH"
    fi

    echo "🛠️ Setting permissions..."
    chown -R www-data:www-data "$WP_PATH"
    chmod -R 750 "$WP_PATH"
fi

echo "✅ Wordpress is running."
