# OpenCode and Windsurf Research (2026-02-24)

## Scope

Research synthesis for strategist workflow continuity and tooling governance.

## Sources

- OpenCode config docs: `https://opencode.ai/docs/config/`
- Local OpenCode reference repo:
  - `References.Architecture/opencode-main/packages/web/src/content/docs/config.mdx`
- Windsurf public site: `https://windsurf.com`
- Windsurf docs root attempts:
  - `https://docs.windsurf.com` (unreachable in current environment)
  - `https://docs.codeium.com/windsurf` (unreachable in current environment)

## OpenCode Findings

1. Config precedence is layered and merged, not replaced.
2. Permissions are configurable globally and per-agent.
3. Agents can be defined in config and markdown files under `~/.config/opencode/agents/`.
4. Runtime behavior observed in this environment:
   - permission config may require OpenCode restart to refresh effective runtime cache.

## Windsurf Findings

1. Windsurf presents AI-first workflow features (Cascade, memories, rules, MCP support, terminal assistance, continue-work flow).
2. JetBrains plugin support exists via Windsurf plugin path.
3. Public site messaging emphasizes agentic coding workflows and MCP integration.
4. Detailed docs endpoints were not reachable from this session, so deeper config semantics remain partially unverified.

## Strategic Implications

1. For OpenCode permission audits, include explicit restart-aware validation steps.
2. For Windsurf integration decisions, treat docs reachability as a dependency gate before finalizing deep operational assumptions.
3. Keep research artifacts in `STR4TEG15T/memory/research/` and write durable operational rules into strategist agent prompt only when repeatedly validated.

## Follow-up

- Add Windsurf deep-doc research pass when docs endpoint access is stable.
- Cross-map OpenCode and Windsurf MCP operational differences in a future companion if dual-IDE workflows expand.
