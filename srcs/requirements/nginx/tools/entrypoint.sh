#!/bin/sh

set -e

host="wordpress"

echo "⏳ Waiting for WordPress ("$host":"$WP_PORT")..."
timeout=0
while ! nc -z "$host" "$WP_PORT"; do
  echo "⌛ Waiting for "$host":"$WP_PORT"..."
  sleep 2
  timeout=$((timeout+2))
  [ $timeout -gt 60 ] && echo "❌ Timeout waiting for WordPress" && exit 1
done

if [ -f /scripts/generate_ssl.sh ]; then
  echo "⚙️ Generating SSL..."
  sh /scripts/generate_ssl.sh
else
  echo "⚠️ No SSL script found. Skipping SSL generation." && exit 1
fi

echo "✅ SSL ready. Testing nginx config..."
nginx -t

echo "✅ Rename the hostname..."
echo "127.0.0.1 "$DOMAIN_NAME"" >> /etc/hosts
echo "🚀 Launching nginx..."
exec nginx -g "daemon off;"
