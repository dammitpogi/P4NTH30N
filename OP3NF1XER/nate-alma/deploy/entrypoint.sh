#!/bin/bash
set -e

chown -R openclaw:openclaw /data
chmod 700 /data

if [ ! -d /data/.linuxbrew ]; then
  cp -a /home/linuxbrew/.linuxbrew /data/.linuxbrew
fi

rm -rf /home/linuxbrew/.linuxbrew
ln -sfn /data/.linuxbrew /home/linuxbrew/.linuxbrew

# Seed workspace on first deploy only (don't overwrite existing data)
WORKSPACE_DIR="${OPENCLAW_WORKSPACE_DIR:-/data/workspace}"
if [ -d /app/workspace-seed ] && [ ! -f "$WORKSPACE_DIR/.seeded" ]; then
  echo "[entrypoint] Seeding workspace from baked image..."
  mkdir -p "$WORKSPACE_DIR"
  cp -rn /app/workspace-seed/. "$WORKSPACE_DIR/"
  chown -R openclaw:openclaw "$WORKSPACE_DIR"
  date -u > "$WORKSPACE_DIR/.seeded"
  echo "[entrypoint] Workspace seeded successfully."
fi

exec gosu openclaw node src/server.js
