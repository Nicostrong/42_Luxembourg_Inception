#!/bin/bash
set -e

# DEBUG
: "${DB_ROOT_PWD:?Missing DB_ROOT_PWD}"
: "${DB_PWD:?Missing DB_PWD}"
: "${DB_USER:?Missing DB_USER}"
: "${DB_NAME:?Missing DB_NAME}"
# DEBUG

SOCKET="/run/mysqld/mysqld.sock"

if [ ! -d "/var/lib/mysql/$DB_NAME" ]; then
  echo "⚙️  Creating Database: $DB_NAME and User: $DB_USER..."

  mariadb -u root -p"$DB_ROOT_PWD" --socket="$SOCKET" <<EOF
-- Ensure root user
CREATE USER IF NOT EXISTS 'root'@'localhost' IDENTIFIED BY '${DB_ROOT_PWD}';
ALTER USER 'root'@'localhost' IDENTIFIED BY '${DB_ROOT_PWD}';

-- Create DB and user
CREATE DATABASE IF NOT EXISTS \`${DB_NAME}\`;
CREATE USER IF NOT EXISTS '${DB_USER}'@'%' IDENTIFIED BY '${DB_PWD}';
GRANT ALL PRIVILEGES ON \`${DB_NAME}\`.* TO '${DB_USER}'@'%';
FLUSH PRIVILEGES;
EOF

  echo "🚀  MariaDB setup complete!"
else
  echo "🚨  Database '$DB_NAME' already exists, skipping setup."
fi
