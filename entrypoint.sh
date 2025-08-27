#!/usr/bin/env bash
set -e

# Falhas mais comuns – validações úteis
: "${N8N_ENCRYPTION_KEY:?Defina N8N_ENCRYPTION_KEY}"
: "${DB_TYPE:?Defina DB_TYPE=postgresdb}"
: "${DB_POSTGRESDB_HOST:?Defina DB_POSTGRESDB_HOST}"
: "${DB_POSTGRESDB_DATABASE:?Defina DB_POSTGRESDB_DATABASE}"
: "${DB_POSTGRESDB_USER:?Defina DB_POSTGRESDB_USER}"
: "${DB_POSTGRESDB_PASSWORD:?Defina DB_POSTGRESDB_PASSWORD}"

if [ "${EXECUTIONS_MODE:-regular}" = "queue" ]; then
  : "${QUEUE_BULL_REDIS_HOST:?Defina QUEUE_BULL_REDIS_HOST}"
  : "${QUEUE_BULL_REDIS_PORT:?Defina QUEUE_BULL_REDIS_PORT}"
fi

# ROLE=web (padrão) | worker
ROLE="${ROLE:-web}"

echo "Starting n8n with ROLE=$ROLE, MODE=${EXECUTIONS_MODE:-regular}"
if [ "$ROLE" = "worker" ]; then
  exec n8n worker
else
  exec n8n start
fi
