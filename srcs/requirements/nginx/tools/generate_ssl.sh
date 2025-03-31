# **************************************************************************** #
#                                                                              #
#                                                         :::      ::::::::    #
#    generate_ssl.sh                                    :+:      :+:    :+:    #
#                                                     +:+ +:+         +:+      #
#    By: nfordoxc <nfordoxc@42luxembourg.lu>        +#+  +:+       +#+         #
#                                                 +#+#+#+#+#+   +#+            #
#    Created: 2025/03/31 17:43:30 by nfordoxc          #+#    #+#              #
#    Updated: 2025/03/31 20:31:57 by nfordoxc         ###   Luxembourg.lu      #
#                                                                              #
# **************************************************************************** #

#!/bin/bash

CERTS_DIR="/etc/nginx/ssl"

mkdir -p "$CERTS_DIR"

openssl req -x509 -nodes -days 365 -newkey rsa:2048 \
    -keyout $CERTS_DIR/nginx.key \
    -out $CERTS_DIR/nginx.crt \
    -subj "/C=FR/ST=Paris/L=Paris/O=42/OU=Student/CN=localhost"
