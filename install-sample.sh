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

# health check
status="$($DOCKER inspect -f '{{.State.Status}}' "$ORACLE_CONTAINER_NAME")"
if [[ $status != "running" ]]; then
  echo -e "\n\e[31mContainer $ORACLE_CONTAINER_NAME is $status\e[0m"
  exit 1
fi
health="$($DOCKER inspect -f '{{.State.Health.Status}}' "$ORACLE_CONTAINER_NAME")"
if [[ $health != "healthy" ]]; then
  echo -e "\n\e[31mContainer $ORACLE_CONTAINER_NAME is $health\e[0m"
  exit 1
fi

$DOCKER container exec -i "$ORACLE_CONTAINER_NAME" bash <<EOT
curl -sSL https://github.com/oracle/db-sample-schemas/archive/refs/tags/v21.1.tar.gz | tar xzf -
cd db-sample-schemas-21.1
/opt/oracle/product/23c/dbhomeFree/perl/bin/perl -p -i.bak -e 's#__SUB__CWD__#'/home/oracle/db-sample-schemas-21.1'#g' ./*.sql ./*/*.sql ./*/*.dat
echo "@mksample $ORACLE_PWD $ORACLE_PWD $ORACLE_PWD $ORACLE_PWD $ORACLE_PWD $ORACLE_PWD $ORACLE_PWD $ORACLE_PWD users temp /home/oracle/log/ FREEPDB1" \
  | sqlplus system/"$ORACLE_PWD"@FREEPDB1
EOT
