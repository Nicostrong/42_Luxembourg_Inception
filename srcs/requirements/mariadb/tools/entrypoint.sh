#!/bin/bash

set -e

export MYSQL_ROOT_PASSWORD=$(cat /run/secrets/db_root_password)
export MYSQL_PASSWORD=$(cat /run/secrets/db_password)

echo "🚀 Starting MariaDB daemon temporarily..."
mysqld --skip-networking --socket=/tmp/mysql.sock &
pid="$!"

echo "⌛ Waiting for MariaDB to be ready..."
until mysqladmin --socket=/tmp/mysql.sock ping --silent; do
  sleep 1
done
echo "✅ MariaDB is up."

sh /setup_mariadb.sh

mysqladmin --socket=/tmp/mysql.sock -u root -p"$MYSQL_ROOT_PASSWORD" shutdown

echo "🚀 Relaunching MariaDB daemon normally..."
exec mysqld
