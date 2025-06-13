#!/bin/bash

set -e

export DB_ROOT_PASSWORD=$(cat /run/secrets/db_root_password)
export DB_PASSWORD=$(cat /run/secrets/db_password)
export DB_USER=$(cat /run/secrets/db_user)
export DB_DATABASE=$(cat /run/secrets/db_name)

# DEBUG
if [ -z "$DB_ROOT_PASSWORD" ]; then
    echo "🚨 ERROR: DB_ROOT_PASSWORD not defined !"
    exit 1
fi
if [ -z "$DB_PASSWORD" ]; then
    echo "🚨 ERROR: DB_PASSWORD not defined !"
    exit 1
fi
if [ -z "$DB_USER" ]; then
    echo "🚨 ERROR: DB_USER not defined !"
    exit 1
fi
if [ -z "$DB_DATABASE" ]; then
    echo "🚨 ERROR: DB_DATABASE not defined !"
    exit 1
fi

# Init base si vide
if [ ! -f /var/lib/mysql/mysql/db.MYD ]; then
  echo "⚠️ First time setup - initializing DB"
  mariadb-install-db --user=mysql --datadir=/var/lib/mysql
  su-exec mysql mariadbd --skip-networking --socket=/run/mysqld/mysqld.sock & pid=$!

  echo "⌛ Waiting for MariaDB to be ready..."
  until mariadb-admin ping --socket=/run/mysqld/mysqld.sock --silent; do
    sleep 1
  done

  /scripts/setup_mariadb.sh

  su-exec mysql mariadb-admin --socket=/run/mysqld/mysqld.sock -u root -p"$DB_ROOT_PASSWORD" shutdown
  echo "✅ MariaDB setup complete."
fi

# Démarrage final en tant que mysql
echo "🚀 Launching MariaDB normally as mysql"
exec su-exec mysql mariadbd
