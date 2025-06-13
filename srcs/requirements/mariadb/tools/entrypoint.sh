#!/bin/bash

set -e

export DB_NAME=$(cat /run/secrets/db_name)
export DB_USER=$(cat /run/secrets/db_user)
export DB_PWD=$(cat /run/secrets/db_pwd)
export DB_ROOT_PWD=$(cat /run/secrets/db_root_pwd)

# DEBUG
[ -z "$DB_NAME" ]      && echo "🚨 ERROR: DB_NAME not defined!" && exit 1
[ -z "$DB_USER" ]      && echo "🚨 ERROR: DB_USER not defined!" && exit 1
[ -z "$DB_PWD" ]       && echo "🚨 ERROR: DB_PWD not defined!" && exit 1
[ -z "$DB_ROOT_PWD" ]  && echo "🚨 ERROR: DB_ROOT_PWD not defined!" && exit 1

# Init base si vide
if [ -z "$(ls -A /var/lib/mysql)" ]; then
  echo "⚠️ First time setup - initializing DB"
  mariadb-install-db --user=mysql --datadir=/var/lib/mysql
  su-exec mysql mariadbd --skip-networking --socket=/run/mysqld/mysqld.sock & pid=$!

  echo "⌛ Waiting for MariaDB to be ready..."
  until mariadb-admin ping --socket=/run/mysqld/mysqld.sock --silent; do sleep 1; done

  /scripts/setup_mariadb.sh

  su-exec mysql mariadb-admin --socket=/run/mysqld/mysqld.sock -u root -p"$DB_ROOT_PWD" shutdown
  echo "✅ MariaDB setup complete."
fi

# Final launch
echo "🚀 Launching MariaDB normally as mysql"
exec su-exec mysql mariadbd
