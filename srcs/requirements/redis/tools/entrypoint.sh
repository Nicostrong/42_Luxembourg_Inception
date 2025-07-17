#!/bin/bash

set -e

echo "🚀 Starting Redis server..."
exec redis-server /etc/redis/redis.conf
