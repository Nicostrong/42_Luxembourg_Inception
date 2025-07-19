#!/bin/bash

set -e

#	Check secrets exist
[ ! -f /run/secrets/portainer_pwd.txt ] && echo "❌ Missing portainer_pwd.txt secret" && exit 1

#	Injection of secrets
export PORTAINER_PWD=$(cat /run/secrets/portainer_pwd.txt)

#	Check env variables
[ -z "$PORTAINER_PORT" ] && echo "❌ PORTAINER_PORT not set" && exit 1
[ -z "$PORTAINER_USER" ] && echo "❌ PORTAINER_USER not set" && exit 1
[ -z "$PORTAINER_MAIL" ] && echo "❌ PORTAINER_MAIL not set" && exit 1

echo -e "\e[1;32m🔐 Mot de passe utilise : \e[1;37m$PORTAINER_PWD\e[0m"

echo "🚀 Starting Portainer..."
exec    /usr/local/portainer/portainer \
        --bind=:"$PORTAINER_PORT" \
        --data=/var/lib/portainer
#        --session-timeout=168h
