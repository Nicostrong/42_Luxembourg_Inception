#!/bin/bash

echo "🔐 Generating secrets..."

mkdir -p ./secrets

echo "$(openssl rand -base64 32)" > ./secrets/db_root_pwd.txt
echo "$(openssl rand -base64 32)" > ./secrets/db_pwd.txt
echo "$(openssl rand -base64 32)" > ./secrets/wp_admin_pwd.txt
echo "$(openssl rand -base64 32)" > ./secrets/wp_user_pwd.txt
echo "$(openssl rand -base64 32)" > ./secrets/ftp_pwd.txt

chmod 600 ./secrets/*.txt

echo "✅ Secrets generated successfully!"
