#!/bin/sh

sh ./generate_ssl.sh

echo "Starting Nginx..."
exec nginx -g "daemon off;"