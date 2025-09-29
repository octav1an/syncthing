#!/bin/bash
# Deploys app file from deploy.list to the target server
set -xeuo pipefail

source .deploy.env

: "${HOST:?HOST must be set in .deploy.env}"
: "${USER:?USER must be set in .deploy.env}"
: "${COMPOSE_PROJECT_NAME:?COMPOSE_PROJECT_NAME must be set in .deploy.env}"

if [ ! -e "deploy.list" ]; then 
  echo "error: 'deploy.list' file doesn't exist"
  exit 1
fi

DEST=$USER@$HOST:services/$COMPOSE_PROJECT_NAME
RSYNC_OPTS="-avz --progress --delete --relative"  # --delete to remove deleted files on server

while read -r item; do
  if [ -e "$item" ]; then
      echo "copying ${item} to remote..."
      rsync ${RSYNC_OPTS} "$item" "$DEST/"
  else
      echo "warning: '$item' does not exist locally, skipping."
  fi
done < deploy.list
