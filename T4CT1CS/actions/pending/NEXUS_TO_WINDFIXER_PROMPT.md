# WindFixer Activation Prompt

**From**: Nexus
**To**: WindFixer (WindSurf)
**Date**: 2026-02-18

---

Execute the following Decisions from the P4NTH30N backlog.

## Target Decisions

Implement these in order:

1. **WIND-001**: Checkpoint Data Model
   - File: C0MMON/Entities/CheckpointData.cs
   - Create CheckpointData entity with SessionId, DecisionId, Status, Complexity, Cost, RetryHistory, ExpiresAt

2. **WIND-002**: ComplexityEstimator Service
   - Files: C0MMON/Services/ComplexityEstimator.cs, C0MMON/Configuration/ComplexityKeywords.json
   - Keyword-based scoring: Simple=1pt, Medium=2pts, Complex=3pts

3. **WIND-003**: RetryStrategy with Fallback Chain
   - File: C0MMON/Services/RetryStrategy.cs
   - Exponential backoff, max 3 attempts, max 5 min

4. **WIND-004**: WindFixerCheckpointManager
   - File: C0MMON/Checkpoint/WindFixerCheckpointManager.cs
   - Hybrid storage: File + MongoDB, 6 triggers, TTL

5. **FALLBACK-001**: Circuit Breaker Tuning
   - File: C:\Users\paulc\.config\opencode\oh-my-opencode-theseus.json
   - Phase 1: Tune circuit breaker

## Constraints

- Use model fallback chain: Opus 4.6 → 4.0 → Sonnet → Haiku
- Max $2.00 per Decision
- Max 10 minutes per Decision
- Save checkpoint after each completion

## Verification

Before completing each Decision:
- Code compiles
- Tests pass
- No new warnings

## Report To

When complete or blocked, reply to **Strategist** with:
- What was accomplished
- What was blocked
- Cost incurred
- Next steps recommended