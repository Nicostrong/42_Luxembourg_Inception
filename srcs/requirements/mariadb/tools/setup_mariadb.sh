#!/bin/bash
set -e

# DEBUG
echo "DB_ROOT_PASSWORD : $DB_ROOT_PASSWORD"
echo "DB_PASSWORD : $DB_PASSWORD"
echo "DB_USER : $DB_USER"
echo "DB_DATABASE : $DB_DATABASE"
# DEBUG
SOCKET="/run/mysqld/mysqld.sock"

if [ ! -d "/var/lib/mysql/$DB_DATABASE" ]; then
  echo "⚙️  Creating Database: $DB_DATABASE and User: $DB_USER..."

mariadb --user=root --password="$DB_ROOT_PASSWORD" --socket="$SOCKET" <<EOF
-- Configure root with password auth
ALTER USER 'root'@'localhost' IDENTIFIED BY '${DB_ROOT_PASSWORD}';
CREATE DATABASE IF NOT EXISTS \`${DB_DATABASE}\`;
CREATE USER IF NOT EXISTS '${DB_USER}'@'%' IDENTIFIED BY '${DB_PASSWORD}';
GRANT ALL PRIVILEGES ON \`${DB_DATABASE}\`.* TO '${DB_USER}'@'%';
FLUSH PRIVILEGES;

-- Afficher les bases de données existantes
SHOW DATABASES;
EOF

  echo "🚀  MariaDB setup complete!"
else
  echo "🚨  Database already exists, skipping setup."
fi
