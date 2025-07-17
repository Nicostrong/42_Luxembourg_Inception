#!/bin/bash

set -e

#	Check env variables
[ -z "$ADMINER_PORT" ] && echo "❌ ADMINER_PORT not set" && exit 1

echo "🚀 Starting PHP server for Adminer..."
echo "🌐 Adminer is available at http://adminer:$ADMINER_PORT"

exec php82 -S 0.0.0.0:$ADMINER_PORT -t /var/www/html/
