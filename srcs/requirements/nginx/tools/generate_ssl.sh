#!/bin/bash

CERTS_DIR="/etc/nginx/ssl"

mkdir -p $CERTS_DIR

openssl req \
        -x509 \
        -nodes \
        -out /etc/nginx/ssl/nginx.crt \
        -keyout /etc/nginx/ssl/nginx.key \
        -subj "/C=LU/ST=IDF/L=Belval/O=42/OU=42/CN=nfordoxc.42.fr/UID=nfordoxc"

chmod 600 $CERTS_DIR/nginx.*
