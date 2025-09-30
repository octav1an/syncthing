#!/bin/bash
"""
This script creates a backup archive of Syncthing server data from a Docker volume
"""

set -xeuo pipefail

source .env

BACKUP_DIR=backup
SYNCTHING_VOLUME_NAME="${COMPOSE_PROJECT_NAME}_${VOLUME_NAME}"

[ ! -d ${BACKUP_DIR} ] && mkdir ${BACKUP_DIR}

docker compose down

docker run \
  -v "${SYNCTHING_VOLUME_NAME}":/data \
  -v "$(pwd)/${BACKUP_DIR}":/${BACKUP_DIR} \
  --rm \
  busybox \
  tar -czvf /${BACKUP_DIR}/data.tar.gz -C /data .

docker compose up -d
