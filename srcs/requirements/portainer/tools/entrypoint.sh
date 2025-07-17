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

# Inject into config file (inline sed or jq)
CONFIG_PATH=/etc/portainer-config.json
if [ -f "$CONFIG_PATH" ]; then
    sed -i "s|{{ADMIN_NAME}}|$PORTAINER_USER|" "$CONFIG_PATH"
    sed -i "s|{{ADMIN_PASSWORD}}|$PORTAINER_PWD|" "$CONFIG_PATH"
    sed -i "s|{{ADMIN_EMAIL}}|$PORTAINER_MAIL|" "$CONFIG_PATH"
fi

echo "🚀 Starting Portainer..."
exec    /usr/local/portainer/portainer \
        --bind=:"$PORTAINER_PORT" \
        --data=/var/lib/portainer \
        --admin-password="$ADMIN_PASSWORD"
