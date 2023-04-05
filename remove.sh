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

$DOCKER container rm "$ORACLE_CONTAINER_NAME"
