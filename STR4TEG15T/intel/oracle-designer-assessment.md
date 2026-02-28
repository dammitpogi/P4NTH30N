# Oracle & Designer Assessment: Decision Research Analysis

**Date**: 2026-02-18
**Consultants**: Oracle, Designer
**Context**: Strategic analysis of 27 decisions, 35 action items
**Document**: T4CT1CS/intel/gaps/decision-research-questions.md

---

## Executive Summary

Both Oracle and Designer have provided comprehensive assessments of the decision research gaps. Their analysis reveals critical architectural blind spots, validation requirements, and implementation pathways that must be addressed before moving decisions from Proposed to InProgress.

**Key Finding**: Infrastructure decisions are appropriately prioritized (33% of total), but serial dependencies (INFRA-001 → INFRA-002 blocking 5+ decisions) create bottleneck risk.

---

## Oracle Assessment Highlights

### 1. Highest Architectural Impact Research Questions

**Tier 1 - Foundation Locking (Highest Risk)**:

| Decision | Impact | Rationale |
|----------|--------|-----------|
| INFRA-002: Secrets Management | Critical | Technology choice constrains future security architecture; nearly impossible to change post-commitment |
| Core Systems Architecture (Missing) | Critical | Microservices vs monolithic locks deployment complexity, data consistency, and operational burden |
| INFRA-001: ChromeDriver Strategy | High | Casino sites update requirements without notice; automated discovery of compatible versions is critical gap |

**Tier 2 - Operational Locking**:

| Decision | Impact | Rationale |
|----------|--------|-----------|
| INFRA-004: Monitoring Platform | High | Cost scaling underestimated; affects observability budget for years |
| INFRA-003: CI/CD Platform | Medium | Affects build velocity, deployment flexibility, and future integrations |

### 2. Critical Blind Spots Identified

**Blind Spot 1: Casino Site Dependency Risk** (Severity: High)
- Research treats ChromeDriver as version management only
- Real issue: Casino sites change frontend unpredictably, breaking selectors
- Gap: No decision addresses selector resilience, automated testing, or fallback strategies

**Blind Spot 2: Operational Cost Model** (Severity: High)
- No research into ongoing costs at scale
- Missing: MongoDB storage growth, compute costs, monitoring platform costs, Chrome instance costs

**Blind Spot 3: Data Sovereignty and Regulatory** (Severity: Critical)
- INFRA-06 mentions gambling regulations but lacks assessment
- Risk: State restrictions on automated casino play not addressed
- Platform-killer risk if legal constraints exist

**Blind Spot 4: Multi-Tenancy Considerations** (Severity: Medium)
- Current design appears single-tenant
- Affects configuration architecture (INFRA-002) and database schema isolation
- No research into roadmap for multi-tenant support

**Blind Spot 5: Graceful Degradation** (Severity: Medium)
- No research into failure handling when dependencies unavailable
- Missing: MongoDB unavailability handling, circuit breaker patterns for casino sites, resource constraint prioritization

### 3. Decision Velocity Analysis

| Metric | Current State | Assessment |
|--------|---------------|------------|
| Completion Rate | 59% (16/27) | Healthy momentum |
| Proposed vs InProgress | 8 Proposed, 3 InProgress | Bottleneck at research phase |
| Infrastructure Ratio | 33% (9/27) | Appropriate for foundation phase |
| Critical Path Risk | HIGH | Serial dependencies create cascade risk |

**Concern**: INFRA-001 and INFRA-002 at 40-50% completion while "InProgress" suggests research questions are harder than expected or resources constrained.

### 4. Oracle Recommendations (Priority Order)

**Next 2 Weeks**:
1. **Complete INFRA-002** - Finalize secrets management (Azure Key Vault vs HashiCorp Vault decision)
2. **Add Core Systems Architecture** to decision register immediately
3. **Close INFRA-001** - Lock OS matrix (Windows Server 2022 + Ubuntu 22.04 LTS for v1)
4. **Add Regulatory Assessment** - Engage legal counsel before production deployment

**Validation Required Before Commitment**:
- Secrets Management: Full migration cycle in staging with rollback trigger
- Monitoring Platform: 30-day cost POC at production data volume
- ChromeDriver: Weekly casino site probing integration test
- CI/CD Platform: Full pipeline dry-run with representative test suite

---

## Designer Assessment Highlights

### 1. Architecture Foundation Assessment

**Current Architecture Pattern**: Hybrid monolithic with repository pattern
- H4ND and H0UND as separate processes (not microservices)
- Shared C0MMON library provides infrastructure abstraction
- MongoDB central data store
- Emerging resilience patterns (CircuitBreaker, SystemDegradationManager)

**Technology Stack**:
- .NET 8+ with primary constructors, file-scoped namespaces
- MongoDB.Driver + EF Core (analytics)
- Selenium for browser automation
- Repository pattern + Unit of Work

**Design Philosophy**: Gradual evolution, minimal disruption, automation-first

### 2. INFRA-001: Environment Setup Architecture

**OS Support Matrix Recommendation**:
```csharp
// Primary: Windows (development + production)
Windows 10 (Build 19044+)
Windows 11 (Build 22621+)
Windows Server 2019
Windows Server 2022 (recommended)

// Secondary: Ubuntu (production containers)
Ubuntu 22.04 LTS (Jammy)
Ubuntu 24.04 LTS (Noble)
```

**Hardware Tiers**:
- Development: 4C/8GB/50GB, Max 1 concurrent H4ND
- Production: 8C/16GB/200GB, Max 4 concurrent H4ND

**MongoDB Strategy**:
- Minimum: MongoDB 6.0 (change streams requirement)
- Recommended: MongoDB 7.0+ (performance improvements)
- Self-hosted for now (Atlas deferred)

**ChromeDriver Strategy**:
- Single ChromeDriver version per deployment
- Rationale: Most casinos use Chromium-based browsers
- Fallback: Version-specific profiles for edge cases
- **Note**: Automated casino site probing needed (Oracle finding)

### 3. INFRA-002: Configuration Management Design

**Configuration Hierarchy** (Priority Order):
1. Environment Variables (runtime overrides)
2. User Secrets (local development)
3. appsettings.{Environment}.json (environment-specific)
4. appsettings.json (base defaults)
5. Code defaults (fallback)

**Configuration Schema Design**:
```json
{
  "MongoDB": {
    "ConnectionString": "mongodb://localhost:27017",
    "DatabaseName": "P4NTHE0N",
    "MaxConnectionPoolSize": 100,
    "MinConnectionPoolSize": 10,
    "ConnectTimeoutSeconds": 10,
    "SocketTimeoutSeconds": 30
  },
  "H4ND": {
    "MaxConcurrentBrowsers": 4,
    "BrowserTimeoutSeconds": 60,
    "RetryAttempts": 3
  },
  "H0UND": {
    "AnalyticsIntervalSeconds": 10,
    "PollingIntervalSeconds": 30,
    "CircuitBreakerFailureThreshold": 5
  }
}
```

**Secrets Management Strategy** (Per AGENTS.md):
| Environment | Storage | Rationale |
|-------------|---------|-----------|
| Development | User Secrets | Convenient, no encryption needed yet |
| Staging | Environment Variables | Simple transition path |
| Production | Environment Variables | Acceptable per automation priority |
| Future | Azure Key Vault / HashiCorp Vault | Post-agentic phase |

**Hot Reload Scope**:
- **Dynamic**: Logging levels, feature flags (UsePriorityCalculation), polling intervals
- **Restart Required**: Connection strings, database names, collection names

### 4. INFRA-003: CI/CD Pipeline Design

**Recommended Platform**: GitHub Actions
- Native GitHub integration
- Matrix builds for Windows/Ubuntu
- Container support
- Free for public repos

**Pipeline Architecture**:
```yaml
# Build workflow (all PRs)
- Restore dependencies
- Build Debug
- Format check (CSharpier)
- Run unit tests
- Upload test results

# Integration tests (main branch)
- Start MongoDB service container
- Run integration tests
- Validate with production-like data

# Deployment (main branch)
- Build self-contained artifacts
- Manual gate for staging → production
- Blue/green deployment
```

**Environment Promotion**:
```
Feature Branch → Staging (Manual Gate) → Production (Manual Gate)
     │               │                       │
     ▼               ▼                       ▼
 Tests Pass    Integration Tests       Health Checks
 Format OK     MongoDB Connect        Blue/Green
```

### 5. INFRA-004: Monitoring Stack Design

**Recommended Stack**: Prometheus + Grafana (Open Source)
- Zero licensing cost
- Mature ecosystem
- OpenTelemetry integration
- Self-hosted (no cloud dependencies)

**KPI Definitions with SLA Targets**:

| KPI | Target | Measurement |
|-----|--------|-------------|
| Signal Processing 95th Percentile | < 60s | `signal_processing_duration_seconds` histogram |
| Jackpot Query Success Rate | > 99.5% | `jackpot_query_success_total / (success + failure)` |
| H4ND Automation Success Rate | > 98% | `automation_success_total / (success + failure)` |
| MongoDB Query 95th Percentile | < 500ms | `mongo_query_duration_seconds` histogram |
| Browser Launch 95th Percentile | < 20s | `browser_launch_duration_seconds` histogram |

**Health Check Endpoints**:
- `/health` - Minimal (status, timestamp, version)
- `/health/full` - Comprehensive (MongoDB latency, circuit breakers, degradation level)
- `/metrics` - Prometheus format

**Alert Severity Matrix**:

| Severity | KPI | Threshold | Trigger | Channel |
|----------|-----|-----------|---------|---------|
| P1 (Critical) | Signal Processing | > 120s | 3 consecutive alerts | PagerDuty + SMS |
| P1 (Critical) | MongoDB Connectivity | Down | 2 consecutive failures | PagerDuty + SMS |
| P2 (High) | H4ND Automation | < 90% | 10 consecutive failures | Email + Slack |
| P3 (Medium) | MongoDB Query | > 1s | Sustained 10 minutes | Email |
| P4 (Low) | Disk Space | < 20% free | Once per day | Email |

**Log Retention Policy**:

| Log Type | Dev | Staging | Production |
|----------|-----|---------|------------|
| Application Logs | 7 days | 30 days | 90 days |
| Error Logs | 30 days | 90 days | 365 days |
| Audit Logs | 30 days | 90 days | 730 days |
| Metrics | 30 days | 90 days | 365 days |

### 6. INFRA-006: Security Hardening Design

**Recommended Approach**: Incremental hardening (aligned with AGENTS.md)

**Phase 1: Deferred Encryption** (Post-agentic)
- AES-256-GCM for credential encryption
- PBKDF2 with 100,000 iterations
- Key rotation every 90 days
- HSM support for production (optional)

**Phase 2: RBAC Implementation** (Now)
```csharp
Roles:
- Admin: Full permissions (credentials:read/write/delete, signals:read/write/delete, system:configure/restart)
- Operator: Limited (credentials:read, signals:read, system:restart)
- Viewer: Read-only (credentials:read, signals:read)
```

**Phase 3: Audit Logging** (Now)
```csharp
AuditEvent Schema:
- Timestamp: DateTime (UTC)
- Actor: string (User or system component)
- Action: string (e.g., "credential_read")
- Resource: string (e.g., "Credential:123")
- IpAddress: string
- Metadata: Dictionary<string, object>
```

**Audit Retention**:
- Development: 30 days
- Staging: 90 days
- Production: 730 days (2 years)

### 7. Missing Decision Categories Design

**Core Systems Architecture**:
- **Recommendation**: Maintain hybrid monolithic
- **Rationale**: H4ND/H0UND already decoupled, microservices complexity not justified
- **Future**: Containerized services path if scale requires

**Data Architecture**:
- **Schema Evolution**: Version tracking + migration scripts
- **Archival Policy**: Jackpot (2 years), Signal (1 year), Error (6 months)
- **Analytics**: MongoDB change streams → analytics collection
- **Future**: Time-series database (InfluxDB) for metrics

**Testing Strategy**:
- **Test Pyramid**: 70% unit, 20% integration, 10% e2e
- **Test Data**: Bogus library for fake data
- **Isolation**: Separate test databases, cleanup after each test
- **Coverage**: >80% for critical paths

**Documentation Strategy**:
- **ADRs**: Architecture Decision Records (Number, Title, Status, Date, Context, Decision, Consequences)
- **API Docs**: Swashbuckle (Swagger) for REST, XML comments for internal
- **User Docs**: Installation, configuration, deployment, troubleshooting

---

## Synthesized Recommendations

### Immediate Actions (This Week)

1. **Research Resolution Priority**:
   - **INFRA-002**: Make secrets management decision (Azure Key Vault if Azure-hosted, else HashiCorp Vault)
   - **INFRA-001**: Lock OS matrix (Windows Server 2022 + Ubuntu 22.04 LTS only)
   - **Regulatory**: Add legal assessment task to decision research (Oracle critical finding)

2. **Missing Decision Creation**:
   - Add Core Systems Architecture decision immediately (affects all other architectural choices)
   - Define microservices vs monolithic stance

3. **ChromeDriver Gap Closure**:
   - Add automated casino site probing to INFRA-001 scope (Oracle finding)
   - Weekly integration test for casino site Chrome requirements

### Next 2 Weeks

4. **Validation Execution** (Oracle recommendations):
   - Secrets Management: Full migration cycle test in staging
   - Monitoring Platform: 30-day cost POC at production data volume
   - ChromeDriver: Create integration test probing each casino site weekly
   - CI/CD: Full pipeline dry-run with representative test suite

5. **Designer Implementation Phase 1**:
   - Implement INFRA-002 configuration hierarchy (Designer schema provided)
   - Set up GitHub Actions workflow (Designer pipeline architecture)
   - Define RBAC roles and permissions (INFRA-006)

### Next Month

6. **Complete Critical Path**:
   - Finish INFRA-001 (ChromeDriver automation, environment validation)
   - Complete INFRA-002 (Configuration provider, secrets integration)
   - Implement INFRA-003 (CI/CD pipeline)
   - Implement INFRA-004 (Monitoring stack with Prometheus + Grafana)

7. **Risk Mitigation** (Oracle blind spots):
   - Address operational cost model (MongoDB growth, compute costs)
   - Implement graceful degradation patterns (MongoDB unavailability handling)
   - Define multi-tenancy roadmap

---

## Risk Matrix

| Risk | Severity | Likelihood | Mitigation | Owner |
|------|----------|------------|------------|-------|
| ChromeDriver casino dependency | High | High | Automated site probing, version profiles | Oracle |
| Serial dependency bottleneck | High | Medium | Parallelize research, expedite INFRA-001/002 | Strategist |
| Regulatory/legal constraints | Critical | Unknown | Legal assessment before production | Oracle |
| Cost underestimation | High | Medium | 30-day cost POC, budget tracking | Designer |
| Secrets management tech lock-in | Medium | High | Evaluate alternatives, migration path | Designer |

---

## Decision Dependencies Updated

```
INFRA-001 (Environment Setup)
  ├─> INFRA-003 (CI/CD) ✓
  ├─> INFRA-005 (Backup) ✓
  └─> Core Systems Architecture (NEW - blocks all)

INFRA-002 (Configuration)
  ├─> INFRA-003 (CI/CD) ✓
  ├─> INFRA-004 (Monitoring) ✓
  └─> INFRA-006 (Security) ✓

NEW: Core Systems Architecture (Microservices vs Monolithic)
  ├─> INFRA-001 (affects OS matrix)
  ├─> INFRA-002 (affects config scope)
  ├─> INFRA-003 (affects deployment model)
  └─> INFRA-004 (affects monitoring scope)
```

---

## Validation Checklist

Before moving decisions from Proposed → InProgress:

- [ ] Secrets management technology selected and validated
- [ ] OS support matrix approved (Windows Server 2022 + Ubuntu 22.04)
- [ ] MongoDB version confirmed (7.0+)
- [ ] ChromeDriver probing strategy defined
- [ ] CI/CD platform validated with dry-run
- [ ] Monitoring platform cost POC completed
- [ ] Legal/regulatory assessment initiated
- [ ] Core Systems Architecture decision created
- [ ] RBAC roles defined
- [ ] Audit event schema approved

---

## Next Strategic Review

**Scheduled**: 1 week from today
**Attendees**: Strategist, Oracle, Designer, Operations representative
**Agenda**:
1. INFRA-001/002 completion status
2. Core Systems Architecture decision review
3. Regulatory assessment findings
4. Cost model validation results
5. ChromeDriver probing test results

---

**Document Status**: Active
**Last Updated**: 2026-02-18
**Next Update**: Upon completion of INFRA-001/002 or regulatory assessment
