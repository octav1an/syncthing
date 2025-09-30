#!/bin/bash
"""
This script restores Syncthing server data from a backup archive
"""

set -xeuo pipefail

source .env

BACKUP_DIR=backup
SYNCTHING_VOLUME_NAME="${COMPOSE_PROJECT_NAME}_${VOLUME_NAME}"

if [ ! -d $BACKUP_DIR ]; then
  echo "error: '$BACKUP_DIR' folder with backup artifacts doesn't exist"
  exit 0
fi

docker compose down

docker run \
  -v "${SYNCTHING_VOLUME_NAME}":/data \
  -v "$(pwd)/${BACKUP_DIR}":/${BACKUP_DIR} \
  --rm \
  busybox \
  tar -xzvf /${BACKUP_DIR}/data.tar.gz -C /data .

docker compose up -d
