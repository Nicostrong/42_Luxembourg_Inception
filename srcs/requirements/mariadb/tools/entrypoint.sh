#!/bin/bash

export MYSQL_ROOT_PASSWORD=$(cat /run/secrets/db_root_password)
export MYSQL_PASSWORD=$(cat /run/secrets/db_password)

mariadbd-safe --skip-networking &
sleep 5

sh /setup_mariadb.sh

mariadb-admin -u root -p"$MYSQL_ROOT_PASSWORD" shutdown
exec mariadbd-safe
