#!/bin/bash

CERTS_DIR="/etc/nginx/ssl"

mkdir -p $CERTS_DIR

openssl req -x509 -nodes -days 365 \
    -newkey rsa:2048 \
    -keyout $CERTS_DIR/nginx.key \
    -out $CERTS_DIR/nginx.crt \
    -subj "/C=FR/ST=Luxembourg/L=Luxembourg/O=42/OU=Student/CN=localhost"

chmod 600 $CERTS_DIR/nginx.*
