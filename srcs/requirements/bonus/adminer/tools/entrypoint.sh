#!/bin/bash

set -e

#	Check env variables
[ -z "$ADMINER_PORTT" ] && echo "❌ ADMINER_PORT not set" && exit 1

echo "🚀 Starting PHP server for Adminer..."
exec php -S 0.0.0.0:$ADMINER_PORT -t /var/www/html
