#!/bin/bash

# Pastikan variabel DOCKER_COMPOSE_FILE diatur sebelumnya, misalnya:
# export DOCKER_COMPOSE_FILE=docker-compose.yml

# Periksa apakah variabel DOCKER_COMPOSE_FILE sudah diatur
if [ -z "$DOCKER_COMPOSE_FILE" ]; then
  echo "ERROR: DOCKER_COMPOSE_FILE is not set."
  exit 1
fi

# Jalankan docker-compose build
echo "Building Docker containers using file: ${DOCKER_COMPOSE_FILE}..."
time docker-compose -f ${DOCKER_COMPOSE_FILE} build
