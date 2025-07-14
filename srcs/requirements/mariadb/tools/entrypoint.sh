#!/bin/bash

set -e

#	Check secrets exist
[ ! -f /run/secrets/db_pwd.txt ] && echo "❌ Missing db_pwd.txt secret" && exit 1
[ ! -f /run/secrets/db_root_pwd.txt ] && echo "❌ Missing db_root_pwd.txt secret" && exit 1

#	Injection of secrets
export DB_PWD=$(cat /run/secrets/db_pwd.txt)
export DB_ROOT_PWD=$(cat /run/secrets/db_root_pwd.txt)

#	Check env variables
[ -z "$DB_NAME" ] && echo "❌ DB_NAME not set" && exit 1
[ -z "$DB_USER" ] && echo "❌ DB_USER not set" && exit 1
[ -z "$DB_PWD" ] && echo "❌ DB_PWD not set" && exit 1
[ -z "$DB_ROOT_PWD" ] && echo "❌ DB_ROOT_PWD not set" && exit 1

#	Init base if empty
if [ -z "$(ls -A /var/lib/mysql)" ]; then
	echo "⚠️ First time setup - initializing DB"
	mariadb-install-db --user=mysql --datadir=/var/lib/mysql
	su-exec mysql mariadbd --skip-networking --socket=/run/mysqld/mysqld.sock & pid=$!

	echo "⌛ Waiting for MariaDB to be ready..."
	until mariadb-admin ping --socket=/run/mysqld/mysqld.sock --silent; do
		sleep 10
	done

	echo "🔧 Running setup script..."
	/scripts/setup_mariadb.sh

	su-exec mysql mariadb-admin --socket=/run/mysqld/mysqld.sock -u root -p"$DB_ROOT_PWD" shutdown
	echo "✅ MariaDB setup complete."
fi

#	Launching mariadb
echo "🚀 Launching MariaDB..."
exec su-exec mysql mariadbd
