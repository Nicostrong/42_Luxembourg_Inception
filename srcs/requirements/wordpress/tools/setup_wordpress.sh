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
define('WP_DEBUG', false );
define('DISALLOW_FILE_EDIT', true );
define('AUTOMATIC_UPDATER_DISABLED', true );
define('WP_HOME', '${WP_URL}');
define('WP_SITEURL', '${WP_URL}');
define('WP_CACHE', true);
define('WP_REDIS_HOST', '${REDIS_HOST}');
define('WP_REDIS_PORT', ${REDIS_PORT});
define('WP_REDIS_DATABASE', ${REDIS_DB});
PHP

    wp config delete WP_CACHE_KEY_SALT --allow-root --path="$WP_PATH" || true
    wp config set WP_CACHE_KEY_SALT "${DOMAINE_NAME}" --allow-root --path="$WP_PATH"
    
    echo "🚀 Installing of WordPress..."
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

    echo "🛠️ Setting permissions..."
    chown -R www-data:www-data "$WP_PATH"
    chmod -R 775 "$WP_PATH"
fi

echo "👥 Listing WordPress users:"
wp user list --allow-root --path="$WP_PATH"
echo "ADMIN $WP_ADMIN   | ADMIN_PWD $WP_ADMIN_PWD"
echo "USER  $WP_USER        | USER_PWD $WP_USER_PWD"

echo "📦 Install and activate of plugin Redis Object Cache..."
wp plugin install redis-cache --activate --allow-root --path="$WP_PATH"

echo "⚙️ Configuration of Redis on WordPress..."
wp config set WP_REDIS_HOST "$REDIS_HOST" --allow-root --path="$WP_PATH"
wp config set WP_REDIS_PORT "$REDIS_PORT" --allow-root --path="$WP_PATH"
wp config set WP_CACHE true --allow-root --path="$WP_PATH"

echo "🔌 Activate cache of Redis..."
wp redis enable --allow-root --path="$WP_PATH"
wp redis status --allow-root --path="$WP_PATH"
wp plugin activate redis-cache --allow-root

echo "✅ Wordpress is running with plugin redis."
