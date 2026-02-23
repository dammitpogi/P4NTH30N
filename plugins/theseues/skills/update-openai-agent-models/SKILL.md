---
name: update-openai-agent-models
description: Fast-path OpenAI-only agent chain update. Use when user says "update agent models for OpenAI" or asks to adjust OpenAI tiers by current usage.
---

# Update OpenAI Agent Models Skill

Use this skill for requests like:
- "update agent models for OpenAI"
- "adjust OpenAI models based on usage"
- "re-tier OpenAI models"

## Required Behavior

- Run the OpenAI-only workflow path.
- Do not run full benchmark research/interview workflow.
- Keep proposal-only behavior (no direct config writes).

## Command

- Standard:
  - `node skills/update-agent-models/run-workflow.js --openai-only`
- Dry-run:
  - `node skills/update-agent-models/run-workflow.js --openai-only --dry-run`

## Expected Output

- Refreshes OpenAI usage/rate-limit snapshot.
- Re-optimizes chains with OpenAI tier limits for current health stage.
- Writes proposal in `skills/update-agent-models/proposals/theseus-update.*.json`.
