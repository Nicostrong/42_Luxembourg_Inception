<?php
define('DB_NAME', getenv('WORDPRESS_DB_NAME'));
define('DB_USER', getenv('WORDPRESS_DB_USER'));
define('DB_PASSWORD', getenv('WORDPRESS_DB_PASSWORD'));
define('DB_HOST', getenv('WORDPRESS_DB_HOST'));

define('WP_DEBUG', false);
define('ABSPATH', dirname(__FILE__) . '/');
require_once ABSPATH . 'wp-settings.php';
?>