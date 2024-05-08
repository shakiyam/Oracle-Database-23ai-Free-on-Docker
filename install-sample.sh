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
curl -sSL https://github.com/oracle-samples/db-sample-schemas/archive/refs/tags/v23.3.tar.gz | tar xzf -
cd /home/oracle/db-sample-schemas-23.3/human_resources
sed -i "s/ACCEPT pass PROMPT/ACCEPT pass DEFAULT "$ORACLE_PWD" PROMPT/" hr_install.sql
echo -e "\n\n\n" | /opt/oracle/product/23ai/dbhomeFree/sqlcl/bin/sql system/"$ORACLE_PWD"@FREEPDB1 @hr_install.sql
cd /home/oracle/db-sample-schemas-23.3/customer_orders
sed -i "s/ACCEPT pass PROMPT/ACCEPT pass DEFAULT "$ORACLE_PWD" PROMPT/" co_install.sql
echo -e "\n\n\n" | /opt/oracle/product/23ai/dbhomeFree/sqlcl/bin/sql system/"$ORACLE_PWD"@FREEPDB1 @co_install.sql
cd /home/oracle/db-sample-schemas-23.3/sales_history
sed -i "s/ACCEPT pass PROMPT/ACCEPT pass DEFAULT "$ORACLE_PWD" PROMPT/" sh_install.sql
echo -e "\n\n\n" | /opt/oracle/product/23ai/dbhomeFree/sqlcl/bin/sql system/"$ORACLE_PWD"@FREEPDB1 @sh_install.sql
EOT
