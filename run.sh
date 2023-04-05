#!/bin/bash
set -eu -o pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
readonly SCRIPT_DIR

# load environment variables from .env
if [ -e "$SCRIPT_DIR"/.env ]; then
  # shellcheck disable=SC1091
  . "$SCRIPT_DIR"/.env
else
  echo -e '\e[33mEnvironment file .env not found. Therefore, dotenv.sample will be used.\e[0m'
  # shellcheck disable=SC1091
  . "$SCRIPT_DIR"/dotenv.sample
fi

if [[ $(command -v docker) ]]; then
  DOCKER=docker
elif [[ $(command -v podman) ]]; then
  DOCKER=podman
else
  echo -e '\n\e[31mNeither docker nor podman is installed.\e[0m'
  exit 1
fi
readonly DOCKER

echo 'Starting an Oracle Database Server Instance.'
$DOCKER container run \
  -d \
  --name "$ORACLE_CONTAINER_NAME" \
  -p "$ORACLE_LISTENER_PORT":1521 \
  -e ORACLE_PWD="$ORACLE_PWD" \
  container-registry.oracle.com/database/free:23.2.0.0

echo -n "Waiting for $ORACLE_CONTAINER_NAME to get healthy ..."
while true; do
  status="$($DOCKER inspect -f '{{.State.Status}}' "$ORACLE_CONTAINER_NAME")"
  if [[ $status != "running" ]]; then
    echo -e "\n\e[31mContainer $ORACLE_CONTAINER_NAME is $status\e[0m"
    exit 1
  fi
  if [[ "$($DOCKER inspect -f '{{.State.Health.Status}}' "$ORACLE_CONTAINER_NAME")" == "healthy" ]]; then
    break
  fi
  sleep 1
  echo -n .
done
echo -e " \e[32mdone\e[0m"
