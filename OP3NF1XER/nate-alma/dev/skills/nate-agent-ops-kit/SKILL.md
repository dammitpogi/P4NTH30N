---
name: nate-agent-ops-kit
description: Parse Nate-agent chat memory for recurring requests and apply a deterministic OpenClaw baseline (group policy + multi-model agents) with pre/post self-audit.
---

# Nate Agent Ops Kit

Use this skill to turn chat-log requests into repeatable config operations.

## What it covers

- Extract recurring requests from workspace memory logs.
- Apply Nate baseline config in openclaw.json:
  - group reply policy (no @mention requirement)
  - named agents and model routing defaults
  - fallback chains for reliability/cost control
- Restart gateway and print post-audit evidence.

## Commands

```bash
# 1) Extract request signal from logs
python skills/nate-agent-ops-kit/scripts/extract_requests.py

# 2) Preview baseline config changes (no mutation)
python skills/nate-agent-ops-kit/scripts/apply_nate_baseline.py --group-id -5107377381

# 3) Apply baseline and restart
python skills/nate-agent-ops-kit/scripts/apply_nate_baseline.py --group-id -5107377381 --apply --restart

# 4) Run reusable workflow profiles
python skills/nate-agent-ops-kit/scripts/workflow_runner.py --profile heartbeat --group-id -5107377381
python skills/nate-agent-ops-kit/scripts/workflow_runner.py --profile apply --group-id -5107377381 --with-openai
python skills/nate-agent-ops-kit/scripts/workflow_runner.py --profile deploy-verify --base-url "https://clawdbot-railway-template-production-461f.up.railway.app"
```

## Output contract

The baseline script always emits:

1. `PRE-AUDIT` (current policy + planned config deltas)
2. `MUTATION REPORT` (exact paths changed)
3. `POST-AUDIT` (resulting config + restart/status output)

Do not claim completion unless all three blocks are present.
