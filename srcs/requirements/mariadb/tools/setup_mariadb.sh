#!/bin/bash

# Vérifier si la base de données existe déjà
if [ ! -d "/var/lib/mysql/$DB_NAME" ]; then
	echo "⚙️	Creating Database and User..."

	mysql -u root <<EOF
ALTER USER 'root'@'localhost' IDENTIFIED BY '${MYSQL_ROOT_PASSWORD}';
CREATE DATABASE IF NOT EXISTS ${DB_NAME};
CREATE USER IF NOT EXISTS '${DB_USER}'@'%' IDENTIFIED BY '${MYSQL_PASSWORD}';
GRANT ALL PRIVILEGES ON ${DB_NAME}.* TO '${DB_USER}'@'%';
FLUSH PRIVILEGES;
EOF

	echo "🚀	MariaDB setup complete!"
else
	echo "🚨	Database already exists, skipping setup."
fi
