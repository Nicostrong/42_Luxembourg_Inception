#!/bin/sh
set -e

host="wordpress"
port=9000

echo "⏳ Waiting for WordPress ($host:$port)..."
until nc -z "$host" "$port"; do
  echo "⌛ Waiting for $host:$port..."
  sleep 30
done

echo "⚙️ Generating SSL..."
sh /scripts/generate_ssl.sh

echo "✅ SSL ready. Testing nginx config..."
nginx -t

echo "🚀 Launching nginx..."
exec nginx -g "daemon off;"
