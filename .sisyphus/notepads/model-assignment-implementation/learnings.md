# Learnings - OpenCode Configuration Setup

## Successful Approach
- Created `~/.opencode/config.json` (absolute path `C:/Users/paulc/.opencode/config.json`) following the strategic model assignment plan.
- Map of agents to models used kebab-case for agent keys to align with system conventions seen in `model-assignment-implementation.md`.
- Integrated comprehensive failover chains from `models.md` for all 13 defined agents.
- Specifically implemented `failover_triggers` for `coder-agent` and `task-manager` as requested in the task.

## Conventions Identified
- Root key `agent` (singular) is used for agent configurations in the schema example.
- `failover_triggers` is the preferred key for defining failover conditions.
- `opencode/big-pickle` is the primary FREE model for coding tasks.

