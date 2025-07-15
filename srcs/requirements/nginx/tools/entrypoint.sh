#!/bin/sh

set -e

host="wordpress"

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


echo "✅ Let's go you can visit nfordoxc.42.fr"