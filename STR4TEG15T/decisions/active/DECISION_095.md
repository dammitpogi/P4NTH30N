---
agent: strategist
type: decision
decision: DECISION_095
created: 2026-02-22
status: Approved
tags:
  - mongodb
  - toolhive
  - mcp
  - infrastructure
  - hardening
  - rancher-desktop
  - container-stability
---

# DECISION_095: ToolHive Infrastructure Hardening - Container Stability + MongoDB Default Database Resolution

**Decision ID**: INFRA-095  
**Category**: INFRA  
**Status**: Approved  
**Priority**: High  
**Date**: 2026-02-22  
**Oracle Approval**: 81% (Combined: Infrastructure 84%, MongoDB Defaults 78%)  
**Designer Approval**: 84% (Combined: Infrastructure 85%, MongoDB Defaults 84%)

---

## Executive Summary

This decision establishes comprehensive hardening for ToolHive infrastructure across two critical domains:

1. **Container Stability (Phase 1-3)**: Hardened infrastructure configuration for running the decisions-server container reliably under Rancher Desktop with ToolHive orchestration. Addresses production incidents where the decisions-server entered restart loops due to missing stdin/tty configuration and MongoDB connection failures.

2. **MongoDB Default Database Resolution (Phase 4)**: Introduces a controlled default-database resolution layer that removes repetitive `database` arguments from common MongoDB calls while preserving explicit override support and auditability.

**Current Problems**:
- Decisions-server container exits immediately with code 0 when run detached (stdio transport requires attached stdin)
- MongoDB connection failures due to missing `directConnection` flag on Windows Docker environments
- Stale ToolHive workloads consuming ports and causing collision conflicts
- No standardized health probe validation before marking services as healthy
- Port collisions between ToolHive auto-discovered services and manually configured containers
- Callers repeatedly pass `database: "P4NTH30N"` in nearly every MongoDB tool call
- Existing MongoDB behavior is noisy and error-prone across agents and workflows

**Proposed Solutions**:
- Standardize docker-compose configuration with `stdin_open: true` and `tty: true` for all stdio MCP servers
- Enforce explicit MongoDB URI with `directConnection=true` parameter where single-node topology is used
- Implement stale workload cleanup automation in deployment scripts
- Add collision detection and dynamic port allocation for ToolHive services
- Add default database resolution in the `mongodb-p4nth30n` integration layer
- Keep explicit per-call database override as highest precedence
- Return resolved context metadata for traceability

---

## Background

### Container Stability Context

The decisions-server container has experienced multiple restart loops in production Rancher Desktop environments. Analysis of incidents (documented in `OP3NF1XER/deployments/JOURNAL_2026-02-22_decisions-server-fix.md`) reveals a pattern of infrastructure misconfigurations:

1. **Transport Mismatch**: MCP servers using `stdio` transport expect a parent process with attached stdin/stdout. When Docker runs these containers detached (`docker-compose up -d`), the absence of stdin causes immediate EOF and exit code 0.

2. **MongoDB Topology Issues**: Windows Docker environments with Rancher Desktop require explicit `directConnection=true` URI parameter when connecting to single-node MongoDB instances. Without this, the MongoDB driver attempts replica set discovery and fails.

3. **Port Collisions**: ToolHive Desktop's auto-discovery mechanism generates runconfigs with dynamic ports. When containers are manually deployed via docker-compose with hardcoded ports, collisions occur on subsequent deployments.

4. **Stale State**: ToolHive workloads that fail to shut down cleanly leave orphaned containers and port bindings, causing subsequent deployments to fail with "port already in use" errors.

5. **Insufficient Validation**: The current healthcheck only verifies MongoDB TCP connectivity (`nc -z`) but does not validate the decisions-server's ability to serve MCP requests.

### MongoDB Default Database Context

The current ToolHive MongoDB server model is explicit by default and requires database in most tool schemas. This is robust, but repetitive for single-database operations (`P4NTH30N`).

Recent remediation stabilized the server by aligning to ToolHive and official MongoDB MCP behavior. The next step is developer-experience hardening without reintroducing hidden context risks.

### Desired State

A hardened infrastructure where:
- All stdio MCP containers run stably with proper terminal attachment
- MongoDB connections use topology-appropriate URI parameters
- Deployment automation cleans stale state before starting new workloads
- Port allocation prevents collisions through dynamic assignment
- Health probes validate actual service functionality, not just network connectivity
- Rollback procedures can restore service within 60 seconds of failure detection
- Common MongoDB calls omit `database` safely
- The resolved database is deterministic, visible, and auditable
- Explicit override remains available for multi-database cases

---

## Specification

### Phase 1: Foundation Hardening (Week 1)

**Objective**: Stabilize existing deployments with proven fixes from INCIDENT-2026-02-22.

#### Requirements

**REQ-095-001**: Docker Compose Stdio Configuration
- **Priority**: Must
- **Acceptance Criteria**:
  - All MCP servers with `MCP_TRANSPORT=stdio` must have `stdin_open: true` and `tty: true`
  - Healthcheck probes must use `host.docker.internal` for host network connectivity
  - Container restart policy must be `unless-stopped`, not `always`

**REQ-095-002**: MongoDB URI Standardization
- **Priority**: Must
- **Acceptance Criteria**:
  - Single-node MongoDB connections must include `directConnection=true`
  - URI must use `host.docker.internal` for cross-platform compatibility
  - Windows deployments must set `NODE_OPTIONS=--dns-result-order=ipv4first`

**REQ-095-003**: ToolHive Stale Workload Cleanup
- **Priority**: Must
- **Acceptance Criteria**:
  - Pre-deployment script must identify and remove orphaned containers
  - Port binding conflicts must be detected and reported
  - Stale runconfig entries must be purged before registration

### Phase 2: Resilience Automation (Week 2)

**Objective**: Automate collision detection, dynamic port allocation, and comprehensive health validation.

#### Requirements

**REQ-095-004**: Port Collision Detection
- **Priority**: Should
- **Acceptance Criteria**:
  - Deployment script checks for port availability before container start
  - If collision detected, dynamically allocate alternative port
  - Update ToolHive gateway config with actual bound port

**REQ-095-005**: Comprehensive Health Probes
- **Priority**: Should
- **Acceptance Criteria**:
  - Healthcheck validates MCP protocol handshake, not just TCP connectivity
  - MongoDB health probe performs actual query (e.g., `db.adminCommand('ping')`)
  - Failed healthchecks trigger container restart within 30 seconds

**REQ-095-006**: Deployment State Verification
- **Priority**: Should
- **Acceptance Criteria**:
  - Post-deployment script verifies all services respond to health probes
  - Validation results logged to centralized deployment log
  - Failure triggers automatic rollback to last known good state

### Phase 3: Production Hardening (Week 3)

**Objective**: Establish monitoring, alerting, and production-grade rollback capabilities.

#### Requirements

**REQ-095-007**: Monitoring Integration
- **Priority**: Could
- **Acceptance Criteria**:
  - Container metrics exposed via Rancher Desktop monitoring
  - MCP request/response latency tracked
  - MongoDB connection pool metrics visible

**REQ-095-008**: Automated Rollback
- **Priority**: Should
- **Acceptance Criteria**:
  - Rollback script restores previous docker-compose configuration
  - Rollback completes within 60 seconds of trigger
  - Rollback events logged with before/after state capture

### Phase 4: MongoDB Default Database Resolution (Week 4)

**Objective**: Implement controlled default-database resolution layer for improved developer experience.

#### Requirements

**REQ-095-009**: Deterministic Database Resolution
- **Priority**: Must
- **Acceptance Criteria**:
  - Resolution precedence is enforced as: call arg > tool-specific default > server default
  - Error is returned when no database can be resolved

**REQ-095-010**: ToolHive Compatibility First
- **Priority**: Must
- **Acceptance Criteria**:
  - No fork of ToolHive protocol behavior
  - Uses ToolHive-supported env/config semantics

**REQ-095-011**: Audit Visibility
- **Priority**: Must
- **Acceptance Criteria**:
  - Responses include resolved context metadata (`database`, `collection`, tool id)

**REQ-095-012**: Safe Multi-Database Override
- **Priority**: Should
- **Acceptance Criteria**:
  - Per-call `database` override is always honored
  - Optional allowlist can restrict unexpected target databases

#### Technical Details
- Introduce a wrapper/integration layer in `mcp-p4nthon` to inject defaults when absent
- Resolve from configuration first, then environment, with explicit precedence
- Keep upstream ToolHive MongoDB MCP contract intact at transport/tool schema boundary

---

## Action Items

| ID | Action | Assigned To | Status | Priority |
|----|--------|-------------|--------|----------|
| ACT-095-001 | Update docker-compose.yml with stdin_open/tty flags | @openfixer | Pending | Critical |
| ACT-095-002 | Add directConnection to MongoDB URI templates | @openfixer | Pending | Critical |
| ACT-095-003 | Create stale workload cleanup script | @forgewright | Pending | High |
| ACT-095-004 | Implement port collision detection in deploy script | @forgewright | Pending | High |
| ACT-095-005 | Enhance healthcheck with MCP protocol validation | @windfixer | Pending | Medium |
| ACT-095-006 | Create deployment verification automation | @forgewright | Pending | Medium |
| ACT-095-007 | Document rollback procedures | @librarian | Pending | Low |
| ACT-095-008 | Add monitoring integration hooks | @windfixer | Pending | Low |
| ACT-095-009 | Implement config loader for default database resolution | @openfixer | Pending | High |
| ACT-095-010 | Implement parameter injection middleware with precedence rules | @openfixer | Pending | High |
| ACT-095-011 | Add resolved-context metadata to responses | @openfixer | Pending | Medium |
| ACT-095-012 | Add migration helper for legacy explicit calls | @openfixer | Pending | Medium |
| ACT-095-013 | Validate against ToolHive MCP tooling and docs behavior | @oracle + @designer | Pending | High |

---

## Files Likely to Modify

### Core Configuration Files

| File | Purpose | Modifications |
|------|---------|---------------|
| `T00L5ET/decisions-server-config/docker-compose.yml` | Container orchestration | Add stdin_open/tty, update healthcheck, standardize env vars |
| `tools/mcp-development/servers/toolhive-gateway/config/servers.json` | ToolHive gateway config | Update MongoDB URIs with directConnection, refresh port mappings |
| `tools/mcp-development/servers/toolhive-gateway/config/mongodb-p4nth30n.json` | MongoDB MCP config | Add directConnection=true to URI template |

### Deployment Scripts

| File | Purpose | Modifications |
|------|---------|---------------|
| `tools/mcp-development/servers/toolhive-gateway/scripts/deploy-config.ts` | Config deployment | Add pre-deployment cleanup, port collision check, state verification |
| `tools/mcp-development/servers/toolhive-gateway/scripts/discover-toolhive-desktop.ts` | Service discovery | Add stale runconfig cleanup, validate port uniqueness |
| `OP3NF1XER/create-toolhive-task.ps1` | Windows autostart | Add port availability check before service registration |

### Server Implementation

| File | Purpose | Modifications |
|------|---------|---------------|
| `tools/mcp-development/servers/decisions-server/src/index.ts` | MCP server entry | Add startup health probe, validate MongoDB before serving |
| `tools/mcp-development/servers/decisions-server/Dockerfile` | Container build | Add HEALTHCHECK instruction with MCP validation |
| `tools/mcp-p4nthon/dist/index.js` (source) | MongoDB MCP server | Handle directConnection parameter, add connection retry logic |

### MongoDB Default Database Resolution

| File | Purpose | Modifications |
|------|---------|---------------|
| `tools/mcp-p4nthon/src/config/database-resolver.ts` (new) | Config loader | Implement default database resolution with precedence rules |
| `tools/mcp-p4nthon/src/middleware/parameter-injection.ts` (new) | Middleware | Inject default database when absent, preserve explicit overrides |
| `tools/mcp-p4nthon/src/types/context.ts` (new) | Type definitions | Define resolved context metadata types |
| `tools/mcp-p4nthon/src/utils/migration-helper.ts` (new) | Migration | Helper to migrate legacy explicit calls |

### Validation and Monitoring

| File | Purpose | Modifications |
|------|---------|---------------|
| `scripts/health/check-decisions-server.ps1` (new) | Health validation | Create PowerShell script for MCP protocol health probe |
| `scripts/deploy/rollback-decisions-server.ps1` (new) | Rollback automation | Create rollback script with state capture/restore |
| `T00L5ET/decisions-server-config/.env.template` | Environment template | Document all required env vars with examples |

---

## Validation Checklist

### Phase 1 Validation (Foundation Hardening)

#### Docker Compose Configuration
- [ ] `stdin_open: true` present in decisions-server service
- [ ] `tty: true` present in decisions-server service
- [ ] `network_mode: host` OR explicit port mapping with collision handling
- [ ] `restart: unless-stopped` configured (not `always`)
- [ ] `MONGODB_URI` includes `directConnection=true` parameter
- [ ] `NODE_OPTIONS=--dns-result-order=ipv4first` set for Windows compatibility
- [ ] Healthcheck uses `host.docker.internal` not `localhost`

#### Container Startup
- [ ] Container starts without immediate exit (code 0)
- [ ] Logs show "Decisions MCP server v1.2.0 running on stdio"
- [ ] Container status shows "Up" not "Restarting"
- [ ] No "ECONNREFUSED" errors in first 30 seconds

#### MongoDB Connectivity
- [ ] Container can resolve `host.docker.internal:27017`
- [ ] MongoDB connection established without replica set discovery timeout
- [ ] `directConnection=true` visible in connection logs

### Phase 2 Validation (Resilience Automation)

#### Port Management
- [ ] Deployment script checks port availability before start
- [ ] If port in use, script allocates alternative and updates config
- [ ] No "bind: address already in use" errors during deployment
- [ ] ToolHive gateway config reflects actual bound ports

#### Health Probe Enhancement
- [ ] Healthcheck validates MCP protocol handshake
- [ ] MongoDB probe performs actual query (not just TCP connect)
- [ ] Failed healthcheck triggers container restart
- [ ] Health status visible via `docker ps` (healthy/unhealthy)

#### State Verification
- [ ] Post-deployment verification confirms all services healthy
- [ ] Deployment log contains timestamp, ports, and health status
- [ ] Verification failure triggers rollback notification

### Phase 3 Validation (Production Hardening)

#### Monitoring
- [ ] Container metrics visible in Rancher Desktop dashboard
- [ ] MCP latency metrics collected and queryable
- [ ] MongoDB connection pool metrics exposed

#### Rollback Capability
- [ ] Rollback script exists and is executable
- [ ] Rollback completes within 60 seconds
- [ ] Rollback restores previous configuration version
- [ ] Rollback events logged with before/after diff

### Phase 4 Validation (MongoDB Default Database Resolution)

#### Default Resolution
- [ ] Common MongoDB calls execute without explicit `database` argument
- [ ] Resolution precedence enforced: call arg > tool default > server default
- [ ] Error returned when no database can be resolved
- [ ] Resolved context metadata present in all responses

#### Override Support
- [ ] Explicit `database` override works for multi-database operations
- [ ] Optional allowlist restricts unexpected target databases
- [ ] ToolHive protocol behavior unchanged

#### Migration
- [ ] Migration helper successfully converts legacy explicit calls
- [ ] Backward compatibility maintained for existing automation

### Integration Testing

#### End-to-End Validation
- [ ] `toolhive find_tool decisions-server` returns valid server config
- [ ] `toolhive call_tool decisions-server list_decisions` returns data
- [ ] Decision write operation succeeds and persists to MongoDB
- [ ] Decision read operation retrieves correct data
- [ ] Concurrent requests (10+) handled without connection pool exhaustion
- [ ] MongoDB calls without `database` argument resolve to `P4NTH30N`
- [ ] MongoDB calls with explicit `database` override use specified database

#### Failover Testing
- [ ] MongoDB restart: decisions-server reconnects within 30 seconds
- [ ] Container kill: restart policy brings service back within 10 seconds
- [ ] Port collision simulation: dynamic allocation resolves conflict
- [ ] Stale workload presence: cleanup script removes before new deployment
- [ ] Database resolution failure: clear error message returned

---

## Rollback / Fallback Strategy

### Automated Rollback Triggers

Rollback automatically initiates when ANY of the following conditions are met:

1. **Health Probe Failure**: Container fails healthcheck 3 consecutive times
2. **Deployment Verification Failure**: Post-deployment validation does not complete within 120 seconds
3. **Port Collision Unresolvable**: All alternative ports (5 attempts) are occupied
4. **MongoDB Connection Timeout**: Cannot establish MongoDB connection within 60 seconds
5. **Database Resolution Error**: Default database resolution fails and breaks existing workflows
6. **Manual Trigger**: Operator executes rollback script explicitly

### Rollback Procedure (Automated)

```powershell
# Phase 1: Capture Current State (5 seconds)
$state = @{
    timestamp = Get-Date -Format "yyyy-MM-ddTHH:mm:ssZ"
    containers = docker ps --filter "name=decisions" --format json | ConvertFrom-Json
    config = Get-Content docker-compose.yml -Raw
    ports = netstat -an | Select-String "LISTENING"
}
$state | ConvertTo-Json -Depth 10 | Out-File rollback-state-$(Get-Date -Format "yyyyMMdd-HHmmss").json

# Phase 2: Stop Current Deployment (10 seconds)
docker-compose down --remove-orphans
docker container prune -f

# Phase 3: Restore Previous Configuration (15 seconds)
Copy-Item docker-compose.yml.backup docker-compose.yml -Force
Copy-Item servers.json.backup servers.json -Force

# Phase 4: Restart with Previous Config (30 seconds)
docker-compose up -d
Start-Sleep 10

# Phase 5: Verify Rollback Success (remaining time)
$healthy = docker ps --filter "name=decisions-server" --filter "health=healthy" --format "{{.Names}}"
if ($healthy) {
    Write-Host "Rollback successful: $healthy"
    exit 0
} else {
    Write-Error "Rollback failed - manual intervention required"
    exit 1
}
```

### Manual Fallback Procedures

#### Fallback A: Reset to ToolHive Native
If custom docker-compose deployment fails repeatedly:

1. Stop custom container: `docker-compose down`
2. Remove custom config: `rm servers.json`
3. Re-run ToolHive discovery: `node discover-toolhive-desktop.ts`
4. Restart ToolHive Desktop to regenerate native runconfigs
5. Verify: `toolhive list` shows decisions-server

#### Fallback B: Local Process Mode
If container deployment is completely blocked:

1. Stop all decisions-server containers: `docker stop decisions-server`
2. Run as local Node.js process:
   ```bash
   cd tools/mcp-development/servers/decisions-server
   MONGODB_URI=mongodb://localhost:27017/P4NTH30N node dist/index.js
   ```
3. Update gateway config to use stdio transport pointing to local process
4. Update `servers.json` to use `"transport": "stdio"` with `"command": "node"`

#### Fallback C: MongoDB Local Fallback
If MongoDB connectivity issues persist:

1. Verify MongoDB service status: `Get-Service MongoDB`
2. If MongoDB down, restart: `Restart-Service MongoDB`
3. If network issues, use `127.0.0.1` instead of `host.docker.internal`
4. Test connectivity: `mongosh mongodb://127.0.0.1:27017/P4NTH30N --eval "db.adminCommand('ping')"`

#### Fallback D: Explicit Database Mode
If default database resolution causes issues:

1. Disable default resolution in config: `DEFAULT_DATABASE_RESOLUTION=false`
2. Revert to explicit `database` parameter in all calls
3. Use migration helper to restore legacy call patterns
4. Verify all existing automation continues to work

### Rollback Verification

After any rollback, verify:
- [ ] `docker ps` shows decisions-server in "healthy" state
- [ ] `toolhive find_tool decisions-server` returns valid configuration
- [ ] Decision read/write operations succeed
- [ ] No error logs in past 5 minutes
- [ ] Rollback state file created with before/after diff
- [ ] MongoDB calls work with explicit `database` parameter

### Escalation Path

If automated rollback fails:

1. **Level 1** (0-5 min): Retry rollback script with verbose logging
2. **Level 2** (5-15 min): Execute Fallback B (local process mode)
3. **Level 3** (15-30 min): Execute Fallback D (explicit database mode)
4. **Level 4** (30+ min): Delegate to @forgewright for diagnostic analysis
5. **Level 5** (45+ min): Escalate to DECISION_093 orchestration for full stack restart

---

## Dependencies

- **Blocks**: DECISION_094 (MCP Boot Integration) - provides autostart infrastructure
- **Blocked By**: DECISION_050 (Decisions-Server MCP Entry) - provides base configuration
- **Related**: 
  - DECISION_039 (ToolHive Migration)
  - DECISION_092 (ToolHive Re-registration)
  - DECISION_093 (Service Orchestration)
  - DECISION_040/041 (MongoDB Validation)

---

## Risks and Mitigations

| Risk | Impact | Likelihood | Mitigation |
|------|--------|------------|------------|
| Port collision during peak deployment | High | Medium | Dynamic port allocation with 5 fallback ports |
| MongoDB replica set misconfiguration | High | Low | Explicit `directConnection=true` in all URIs |
| ToolHive Desktop upgrade breaks config | Medium | Medium | Backup/restore of servers.json before any ToolHive updates |
| Stale container prevents new deployment | Medium | High | Pre-deployment cleanup script with force removal |
| Rollback fails and leaves system down | Critical | Low | Multi-level fallback (A/B/C/D) with manual procedures |
| Health probe false positives | Medium | Medium | MCP protocol validation, not just TCP connect |
| Windows Docker networking quirks | Medium | High | `host.docker.internal` standardization, IPv4 preference |
| Hidden writes to wrong DB via implicit defaults | High | Medium | Deterministic precedence + explicit error on unresolved DB + optional allowlist |
| Cache/stale server tool metadata in ToolHive ecosystem | Medium | Medium | Add restart/refresh verification in validation plan |
| Migration confusion between explicit and implicit calls | Medium | Medium | Keep explicit override support and publish migration helper |

---

## Success Criteria

### Container Stability
1. Decisions-server container runs continuously for 7 days without restart loop
2. Deployment completes successfully 10/10 times in test environment
3. Health probes correctly identify unhealthy state within 30 seconds
4. Rollback restores service within 60 seconds of trigger
5. Zero port collision failures during 30-day observation period
6. MongoDB connection success rate >99.9% (measured via health probe logs)

### MongoDB Default Database Resolution
1. Common MongoDB calls execute without explicit `database` argument in primary workflows
2. Explicit `database` override still works for multi-database operations
3. Validation confirms ToolHive compatibility and no regression in existing automation
4. Resolved context metadata visible in all responses
5. Migration helper successfully converts 100% of legacy explicit calls

---

## Token Budget

- **Estimated**: 75,000 tokens (45K infrastructure + 30K MongoDB defaults)
- **Model**: Claude 3.5 Sonnet (for Fixer implementation)
- **Budget Category**: Critical (<100K)

---

## Bug-Fix Section

- **On syntax error**: Auto-fix inline, no delegation needed
- **On logic error**: Delegate to @forgewright with context
- **On config error**: Delegate to @openfixer
- **On test failure**: WindFixer self-resolves or delegates to Forgewright if >30min blocked
- **On deployment failure**: Execute rollback script, if rollback fails delegate to @forgewright
- **On database resolution failure**: Revert to explicit-db mode (Fallback D) and re-run validation
- **Escalation threshold**: 30 minutes blocked → auto-delegate to Forgewright

---

## Sub-Decision Authority

| Agent | Can Create | Max Complexity | Approval Required |
|-------|-----------|----------------|-------------------|
| Oracle | Validation sub-decisions | Medium | No |
| Designer | Architecture sub-decisions | Medium | No |
| WindFixer | Implementation sub-decisions | High | Yes (Strategist) |
| OpenFixer | Config/tooling sub-decisions | High | Yes (Strategist) |
| Forgewright | Complex deployment/rollback automation | Critical | Yes (Strategist) |

---

## Consultation Log

### Oracle Consultation (Container Stability)
- **Date**: 2026-02-22
- **Models**: claude-sonnet-4-20250514
- **Approval**: 84%
- **Feasibility**: 7/10
- **Risk**: 6/10
- **Complexity**: 5/10
- **Key Findings**: Primary risk is recurrent port/proxy contention under Rancher Desktop. Highest-value mitigations are a single MongoDB URI source of truth, preflight port checks, fixed runtime policy, and health-gated startup ordering.

### Oracle Consultation (MongoDB Defaults)
- **Date**: 2026-02-22
- **Approval**: 78%
- **Key Findings**:
  - Safe if explicit override semantics remain highest precedence
  - Require structured errors when default DB is unresolved
  - Include resolved context in responses for auditability

### Designer Consultation (Container Stability)
- **Date**: 2026-02-22
- **Models**: kimi-k2
- **Approval**: 85%
- **Key Findings**: Three-phase approach balances immediate stability (Phase 1) with long-term resilience (Phases 2-3). Validation checklist provides concrete verification gates. Fallback strategy includes three escalating levels (ToolHive native -> local process -> full stack restart).

### Designer Consultation (MongoDB Defaults)
- **Date**: 2026-02-22
- **Approval**: 84%
- **Key Findings**:
  - Use phased rollout with config loader + middleware injection
  - Keep ToolHive protocol semantics unchanged
  - Add migration helper and backward compatibility path

---

## Notes

### Reference Incidents
- **INCIDENT-2026-02-22**: Decisions-server restart loop due to missing stdin/tty flags. Resolved per `OP3NF1XER/deployments/JOURNAL_2026-02-22_decisions-server-fix.md`.

### Technical Constraints
- Rancher Desktop on Windows uses WSL2 backend with specific networking behavior
- ToolHive Desktop manages container lifecycle independently; manual docker-compose deployments must coordinate
- MongoDB running on Windows host requires `host.docker.internal` resolution
- Stdio transport MCP servers cannot run as detached services without terminal emulation
- This decision intentionally avoids hidden global mutable session state for database resolution
- The implementation target is predictable defaulting, not implicit magic

### Future Enhancements (Out of Scope)
- Kubernetes-native deployment via Rancher Desktop k3s
- Sidecar pattern for MongoDB connection pooling
- Distributed tracing across MCP tool calls
- Automatic database discovery from MongoDB server metadata

---

*Decision INFRA-095*  
*ToolHive Infrastructure Hardening - Container Stability + MongoDB Default Database Resolution*  
*2026-02-22*
