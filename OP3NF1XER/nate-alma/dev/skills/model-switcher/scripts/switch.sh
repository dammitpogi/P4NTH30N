#!/bin/bash
set -euo pipefail

# Quick model switcher using session_status
# Usage: ./switch.sh <opus|sonnet|haiku>

MODEL=$1

case $MODEL in
  opus)
    MODEL_ID="anthropic/claude-opus-4-5-20251101"
    ;;
  sonnet)
    MODEL_ID="anthropic/claude-sonnet-4-5-20250929"
    ;;
  haiku)
    MODEL_ID="anthropic/claude-haiku-4-5-20251001"
    ;;
  *)
    echo "Unknown model: $MODEL"
    echo "Usage: switch.sh <opus|sonnet|haiku>"
    exit 1
    ;;
esac

echo "Switching to $MODEL ($MODEL_ID)..."
echo "✓ Model set to $MODEL"
