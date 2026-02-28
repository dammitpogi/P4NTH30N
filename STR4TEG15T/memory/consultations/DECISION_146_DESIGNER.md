---
type: consultation
id: DECISION_146_DESIGNER
parent: DECISION_146
consultant: Designer
status: complete
created_at: '2026-02-27T00:40:00Z'
---

# DECISION_146 Designer Consultation (Architecture)

## Core Recommendation

- If shared persistence must be a POSIX filesystem under `/data`, the **merged container** approach is the correct Railway architecture.
- The only alternative is moving “shared persistence” to an external store (S3/R2) and splitting services, which changes the operator experience.

## Supervision

- Preferred: `s6-overlay` for deterministic supervision and clean shutdown.
- Acceptable: `supervisord` only with group stop settings (`stopasgroup=true`, `killasgroup=true`).
- Avoid: ad-hoc backgrounding in a shell script.

## Networking Notes

- OpenClaw wrapper should bind to `$PORT` (expected 8080) and proxy the internal gateway (loopback:18789).
- SFTPGo binds internal `0.0.0.0:2022`; external is via Railway TCP Proxy assigned host:port.
- Volume-backed SFTP implies replicas should remain `1`.

## RAG / Local Model Feasibility

- Phase 1: establish directory conventions and ingestion pipeline; avoid local LLM inference on Railway CPU unless budgeted.
- Defer local inference to Phase 2+; keep minimal embeddings and bounded batch ingestion if required.

## Recommended RAG Directory Layout

```
/data/workspace/rag/
  inbox/
  staging/
  corpus/
  archive/
  indexes/
  metadata/
  cache/
  logs/
  scripts/
  README.md
```

## Operator Kit Guidance

Prefill (stable, non-secret): URLs, paths, internal DNS patterns, validation commands.
Generate at runtime: SFTP host key fingerprints, user manifests.
