# Tool Gateway Policy (v1)

## Purpose
Define hard constraints for any tool execution environment.
The Tool Gateway enforces authority boundaries, allowlists, and auditing.

## Deny-by-default
- All tools are **disabled** unless explicitly allowed by policy.
- Each tool must declare allowed targets, schema, and expected side effects.

## Allowlist Requirements
Each tool allowlist entry **must** include:
- **Intent**: what the tool is allowed to do.
- **Targets**: explicit hosts, paths, or resources.
- **Schema**: strict input schema; reject unknown fields.
- **Side-effects**: write boundaries and maximum scope.
- **Rate limits**: per-tool call limits and timeouts.

## Forbidden Capabilities
- Self-modification of gateway policy or allowlists.
- Hidden persistence outside Forge/Vault.
- Network hopping or unsanctioned external calls.
- Any action without a scoped, logged authorization.

## Enforcement & Logging
- All tool calls are logged to Vault (inputs, parameters, artifacts, logs).
- Violations trigger a mode transition to **Constrained** or **Evidence**.
- Blocks emit a **Blocked-Action Revision Capsule** and halt further attempts.

## Degraded Modes
- **Normal**: allowlist enforced; full logging.
- **Constrained**: read-only tooling; no writes.
- **Evidence**: capture-only; emit capsule and stop.
