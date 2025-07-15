#!/bin/bash

set -e

#	Check env variables
[ -z "$PORTAINER_PORT" ] && echo "❌ PORTAINER_PORT not set" && exit 1

echo "🚀 Starting Portainer..."
exec /usr/local/portainer/portainer --bind=:"$PORTAINER_PORT" --data=/var/lib/portainer
