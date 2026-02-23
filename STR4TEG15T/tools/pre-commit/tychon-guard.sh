#!/usr/bin/env bash
set -euo pipefail

REPO_ROOT="$(git rev-parse --show-toplevel 2>/dev/null || pwd)"
CONFIG_PATH="${REPO_ROOT}/STR4TEG15T/tools/ast-grep-rules/silent-failures.yml"

if ! command -v ast-grep >/dev/null 2>&1; then
  echo "TYCHON GUARD: ast-grep is not installed."
  echo "Install with: npm install -g @ast-grep/cli"
  exit 1
fi

if [ ! -f "${CONFIG_PATH}" ]; then
  echo "TYCHON GUARD: Rule config not found at ${CONFIG_PATH}"
  exit 1
fi

ast-grep scan --config "${CONFIG_PATH}" \
  "${REPO_ROOT}/H0UND" \
  "${REPO_ROOT}/H4ND" \
  "${REPO_ROOT}/C0MMON" \
  "${REPO_ROOT}/W4TCHD0G" \
  "${REPO_ROOT}/UNI7T35T"

if [ $? -ne 0 ]; then
  echo "TYCHON GUARD: Silent failure patterns detected. Commit blocked."
  exit 1
fi

echo "TYCHON GUARD: No silent-failure patterns detected."
exit 0
