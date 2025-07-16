#!/bin/bash

CERTS_DIR="/etc/nginx/ssl"

mkdir -p $CERTS_DIR

#	certificat for nfordoxc.42.fr
openssl req \
		-x509 \
		-nodes \
		-out /etc/nginx/ssl/nginx.crt \
		-keyout /etc/nginx/ssl/nginx.key \
		-subj "/C=LU/ST=IDF/L=Belval/O=42/OU=42/CN=nfordoxc.42.fr/UID=nfordoxc"

#	certificat for adminer.nfordoxc.42.fr
openssl req \
		-x509 \
		-nodes \
		-out /etc/nginx/ssl/adminer.crt \
		-keyout /etc/nginx/ssl/adminer.key \
		-subj "/C=LU/ST=IDF/L=Belval/O=42/OU=42/CN=adminer.nfordoxc.42.fr/UID=nfordoxc"

#	certificat for portainer.nfordoxc.42.fr
openssl req \
		-x509 \
		-nodes \
		-out /etc/nginx/ssl/portainer.crt \
		-keyout /etc/nginx/ssl/portainer.key \
		-subj "/C=LU/ST=IDF/L=Belval/O=42/OU=42/CN=portainer.nfordoxc.42.fr/UID=nfordoxc"

chmod 600 $CERTS_DIR/nginx.*
chmod 600 $CERTS_DIR/adminer.*
chmod 600 $CERTS_DIR/portainer.*
