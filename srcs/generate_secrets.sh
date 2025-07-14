# **************************************************************************** #
#                                                                              #
#                                                         :::      ::::::::    #
#    generate_secrets.sh                                :+:      :+:    :+:    #
#                                                     +:+ +:+         +:+      #
#    By: nicostrong <nicostrong@student.42.fr>      +#+  +:+       +#+         #
#                                                 +#+#+#+#+#+   +#+            #
#    Created: 2025/07/13 18:20:02 by nicostrong        #+#    #+#              #
#    Updated: 2025/07/13 18:20:39 by nicostrong       ###   Luxembourg.lu      #
#                                                                              #
# **************************************************************************** #

#!/bin/bash

echo "🔐 Generating secrets..."

mkdir -p ../secrets

echo "$(openssl rand -base64 32)" > ../secrets/db_root_pwd.txt
echo "$(openssl rand -base64 32)" > ../secrets/db_pwd.txt  
echo "$(openssl rand -base64 32)" > ../secrets/wp_pwd.txt

echo "✅ Secrets generated successfully!"
echo "⚠️  Remember to add these files to .gitignore"
