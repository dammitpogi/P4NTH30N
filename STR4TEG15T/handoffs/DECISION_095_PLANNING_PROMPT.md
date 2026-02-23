---
agent: pyxis
type: planning-handoff
decision: DECISION_095
created: 2026-02-22
status: approved
tags:
  - rancher-desktop
  - toolhive
  - decisions-server
  - reliability
  - infrastructure
---

Planning Team,

You are planning implementation for DECISION_095: Rancher Desktop + ToolHive Hardening for Decisions-Server Reliability.

Context:
- Current failure modes include MCP stdio container exits, stale ToolHive workloads, proxy port collisions, and MongoDB URI/topology mismatch.
- Oracle approved at 84% with key concern around port/proxy contention and startup ordering.
- Designer approved at 85% with a three-phase rollout and strict validation gates.

Your objective:
- Produce a concrete implementation plan that can be executed by Fixers with minimal ambiguity.

Planning constraints:
- Treat Rancher Desktop + ToolHive as the target runtime.
- Prefer deterministic startup and explicit health gates over best-effort startup.
- Assume existing repo conventions and avoid introducing parallel config systems.
- Keep rollback path executable in under 60 seconds.

Required outputs:
1) Sequenced implementation plan by phase (Phase 1/2/3), each with entry/exit criteria.
2) File-by-file change plan for these targets at minimum:
   - T00L5ET/decisions-server-config/docker-compose.yml
   - tools/mcp-development/servers/toolhive-gateway/config/servers.json
   - tools/mcp-development/servers/toolhive-gateway/config/mongodb-p4nth30n.json
   - tools/mcp-development/servers/toolhive-gateway/scripts/deploy-config.ts
   - tools/mcp-development/servers/toolhive-gateway/scripts/discover-toolhive-desktop.ts
   - tools/mcp-development/servers/decisions-server/src/index.ts
3) Validation matrix mapping each requirement (REQ-095-001..008) to a command/probe and pass/fail threshold.
4) Rollback runbook with trigger thresholds and exact operator steps.
5) Risk register updates with top 5 residual risks after implementation.

Non-negotiable checks:
- MCP stdio workloads must not be considered healthy until protocol-level handshake succeeds.
- MongoDB connectivity must be validated with an actual query/ping, not only TCP socket checks.
- Port allocation must include collision preflight and recorded final bindings.
- Stale workload cleanup must run before deployment registration.

Success definition for planning complete:
- A Fixer can execute the plan start-to-finish without asking architecture questions.
- Every requirement in DECISION_095 has a measurable validation step.
- Rollback procedure is explicit, tested, and time-bounded.
