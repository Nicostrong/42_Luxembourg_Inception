#!/bin/sh

echo "⏳ Waitting on WordPress..."
until curl -s http://wordpress:9000 > /dev/null; do
  sleep 2
done
echo "✅ WordPress is done, starting of Nginx !"

sh /generate_ssl.sh

exec nginx -g "daemon off;"

echo "✅ Nginx is running."
