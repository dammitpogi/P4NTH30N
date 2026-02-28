#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ROOT_DIR="$(cd "$SCRIPT_DIR/.." && pwd)"

export MCP_AUTH_TOKEN="${MCP_AUTH_TOKEN:-$(node -e "console.log(require('crypto').randomBytes(32).toString('hex'))")}"
export MONGODB_URI="${MONGODB_URI:-mongodb://mongodb:27017/P4NTHE0N}"
export VECTOR_STORE_PATH="${VECTOR_STORE_PATH:-/data/vector-store}"
export EMBEDDING_MODEL="${EMBEDDING_MODEL:-text-embedding-3-small}"

"$SCRIPT_DIR/deploy.sh"

cd "$ROOT_DIR/tests"
npm install
npm run test:all

echo "Integration tests complete."
