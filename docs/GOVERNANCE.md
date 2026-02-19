# P4NTH30N Governance Framework

> **Owner**: Oracle Decision Board
> **Staleness**: 90 days (architecture-tier)
> **Last Reviewed**: 2026-02-18
> **Next Review**: 2026-05-19

---

## 1. Ownership Matrix

| Domain | Owner | Backup | Review Cycle |
|--------|-------|--------|-------------|
| **H0UND** (polling, analytics, signals) | Oracle | WindFixer | 30 days |
| **H4ND** (automation, browser, spin) | Oracle | WindFixer | 30 days |
| **C0MMON** (shared entities, DB, infra) | Oracle | WindFixer | 60 days |
| **W4TCHD0G** (vision, OBS) | Oracle | — | 90 days |
| **PROF3T** (autonomous learning) | Oracle | — | 90 days |
| **RUL3S** (resource overrides, extensions) | Oracle | — | 60 days |
| **UNI7T35T** (test platform) | WindFixer | — | 30 days |
| **Infrastructure** (MongoDB, CI/CD) | Oracle | WindFixer | 60 days |
| **Documentation** (docs/, AGENTS.md) | Librarian | WindFixer | 30-90 days (tier-based) |
| **Decisions** (T4CT1CS/) | Oracle | — | Per-decision |

## 2. Review Cycles

### Staleness Tiers

| Tier | Max Age | Scope | Action on Expiry |
|------|---------|-------|-----------------|
| **Runbooks** | 30 days | `docs/runbooks/`, agent AGENTS.md | Flag for review, block deployment if critical |
| **Components** | 60 days | `docs/components/`, C0MMON/H0UND/H4ND docs | Flag for review |
| **Architecture** | 90 days | `docs/architecture/`, GOVERNANCE.md, strategies | Schedule Oracle review session |

### Review Triggers (non-scheduled)
- **Code change**: Any PR touching >50 lines in a component triggers component doc review
- **Incident**: Post-mortem triggers runbook review for affected systems
- **Dependency update**: Major version bumps trigger architecture review
- **Decision completion**: Oracle decisions trigger relevant doc updates

## 3. Oracle Escalation Protocol

### Decision Severity Levels

| Level | Threshold | Escalation Path | Response SLA |
|-------|-----------|-----------------|-------------|
| **P0 - Critical** | Production down, data loss risk | Immediate Oracle review | 1 hour |
| **P1 - High** | Degraded performance, signal accuracy impact | Oracle review within session | 4 hours |
| **P2 - Medium** | Non-blocking improvements, test failures | Next Oracle cycle | 24 hours |
| **P3 - Low** | Documentation, cleanup, cosmetic | Batch in weekly review | 7 days |

### Escalation Flow

```
Agent detects issue
  → Logs to ERR0R collection (severity tagged)
  → If P0/P1: Creates T4CT1CS/decisions/active/ entry
  → Oracle reviews with ≥90% approval threshold
  → WindFixer/agent executes approved decision
  → Decision status updated to Completed
```

### Decision Lifecycle

```
PROPOSED → APPROVED (≥90%) → IN_PROGRESS → COMPLETED
                ↓                  ↓
            REJECTED          BLOCKED (with blocker note)
```

## 4. Agent Behavior Contracts

### H0UND Contract
- **MUST**: Poll credentials within configured interval
- **MUST**: Validate all DPD/jackpot data via `IsValid(IStoreErrors)`
- **MUST**: Respect circuit breaker state transitions
- **MUST NOT**: Mutate invalid data (log to ERR0R, skip)
- **MUST NOT**: Generate signals when circuit is Open (fallback to unprotected)

### H4ND Contract
- **MUST**: Acknowledge signals before executing
- **MUST**: Release credential locks in finally blocks
- **MUST**: Validate balance/jackpot reads before updating
- **MUST NOT**: Execute spins without valid signal or N3XT entry
- **MUST NOT**: Store credentials in logs or console output

### WindFixer Contract
- **MUST**: Build and test before considering task complete
- **MUST**: Run `dotnet csharpier .` on modified files
- **MUST**: Update codemap after structural changes
- **MUST NOT**: Delete or weaken existing tests
- **MUST NOT**: Create files outside approved directories

## 5. Change Management

### Pre-merge Checklist
1. `dotnet build P4NTH30N.slnx` — zero errors
2. `dotnet test UNI7T35T/UNI7T35T.csproj` — all tests pass
3. `dotnet csharpier check` — formatting clean
4. Relevant AGENTS.md updated if behavior changed
5. Decision status updated if executing approved decision

### Rollback Protocol
1. Identify failing commit via `git log`
2. `git revert <commit>` for targeted rollback
3. Rebuild and retest
4. Log incident to ERR0R collection
5. Create P1 decision for root cause analysis
