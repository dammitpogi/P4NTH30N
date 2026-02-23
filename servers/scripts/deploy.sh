#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ROOT_DIR="$(cd "$SCRIPT_DIR/.." && pwd)"
COMPOSE_FILE="$ROOT_DIR/docker-compose.production.yml"

if [[ -f "$ROOT_DIR/.env" ]]; then
  # shellcheck disable=SC1091
  source "$ROOT_DIR/.env"
fi

if [[ -z "${MCP_AUTH_TOKEN:-}" ]]; then
  MCP_AUTH_TOKEN="$(node -e "console.log(require('crypto').randomBytes(32).toString('hex'))")"
  export MCP_AUTH_TOKEN
  echo "MCP_AUTH_TOKEN was not set; generated ephemeral token for this deployment."
fi

if [[ -z "${MONGODB_URI:-}" ]]; then
  export MONGODB_URI="mongodb://mongodb:27017/P4NTH30N"
fi

if [[ -z "${VECTOR_STORE_PATH:-}" ]]; then
  export VECTOR_STORE_PATH="/data/vector-store"
fi

if [[ -z "${EMBEDDING_MODEL:-}" ]]; then
  export EMBEDDING_MODEL="text-embedding-3-small"
fi

echo "=== P4NTH30N MCP Servers Deployment ==="
docker compose -f "$COMPOSE_FILE" build
docker compose -f "$COMPOSE_FILE" up -d

echo "Waiting for services to become healthy..."
sleep 6

for port in 3000 3001 3002; do
  if curl -fsS -H "Origin: http://localhost:5173" "http://localhost:${port}/health" >/dev/null; then
    echo "[OK] Port ${port} health endpoint responding"
  else
    echo "[FAIL] Port ${port} health endpoint not responding"
    docker compose -f "$COMPOSE_FILE" ps
    exit 1
  fi
done

echo "Deployment complete."
