#!/bin/bash

export WP_PATH="/var/www/html"

if [ ! -f "$WP_PATH/wp-config.php" ]; then

    echo "📥 Dowloading of WordPress..."
    wp core download --allow-root --path="$WP_PATH"

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
define('WP_HOME', '${WP_URL}');
define('WP_SITEURL', '${WP_URL}');
define('WP_CACHE_KEY_SALT', '${DOMAINE_NAME}');
define('WP_CACHE', true);
define('WP_REDIS_HOST', '${REDIS_HOST}');
define('WP_REDIS_PORT', ${REDIS_PORT});
define('WP_REDIS_DATABASE', ${REDIS_DB});
PHP

    if ! wp core is-installed --allow-root --path="$WP_PATH"; then
        echo "🚀 Installation of WordPress..."
        wp core install \
            --url="$WP_URL" \
            --title="Inception nfordoxc" \
            --admin_user="$WP_ADMIN" \
            --admin_password="$WP_ADMIN_PWD" \
            --admin_email="$WP_ADMIN_MAIL" \
            --allow-root --path="$WP_PATH"
        echo "👤 Creating second user..."
        wp user create "$WP_USER" "$WP_USER_MAIL" \
            --user_pass="$WP_USER_PWD" \
            --role="author" \
            --allow-root --path="$WP_PATH"
    fi

    echo "🛠️ Setting permissions..."
    chown -R www-data:www-data "$WP_PATH"
    chmod -R 750 "$WP_PATH"
fi

echo "👥 Listing WordPress users:"
wp user list --allow-root --path="$WP_PATH"
echo "ADMIN_PWD $WP_ADMIN_PWD"
echo "USER_PWD $WP_USER_PWD"

if wp redis status --allow-root --path="$WP_PATH" > /dev/null 2>&1; then
    echo "📦 Redis detected, enabling plugin..."
    wp plugin install redis-cache --activate --allow-root --path="$WP_PATH"
    wp config set WP_REDIS_HOST "$REDIS_HOST" --allow-root --path="$WP_PATH"
    wp config set WP_REDIS_PORT "$REDIS_PORT" --allow-root --path="$WP_PATH"
    wp config set WP_CACHE true --allow-root --path="$WP_PATH"
    wp redis enable --allow-root --path="$WP_PATH"
fi

echo "✅ Wordpress is running."
