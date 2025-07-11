#!/bin/bash

echo "📝 Generating .env file..."

# Créer un fichier .env à partir des fichiers de secrets
{
  echo "DB_NAME=$(cat secrets/db_name.txt)"
  echo "DB_USER=$(cat secrets/db_user.txt)"
  echo "DB_PWD=$(cat secrets/db_pwd.txt)"
  echo "DB_ROOT_PWD=$(cat secrets/db_root_pwd.txt)"

  echo "WP_ADMIN=$(cat secrets/wp_admin.txt)"
  echo "WP_HOST=$(cat secrets/wp_host.txt)"
  echo "WP_MAIL=$(cat secrets/wp_mail.txt)"
  echo "WP_URL=$(cat secrets/wp_url.txt)"
  echo "WP_PWD=$(cat secrets/wp_pwd.txt)"
} > .env

echo "✅ .env file created successfully."
