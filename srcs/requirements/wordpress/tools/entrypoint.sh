#!/bin/sh

sh /setup_wordpress.sh

exec php-fpm8 -F