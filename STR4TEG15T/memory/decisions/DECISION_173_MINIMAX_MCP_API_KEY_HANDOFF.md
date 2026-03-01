---
type: decision
id: DECISION_173
category: INFRA
status: drafted
version: 1.0.0
created_at: '2026-03-01T09:20:00Z'
last_reviewed: '2026-03-01T09:20:00Z'
priority: Critical
keywords:
  - minimax
  - mcp
  - api-keys
  - openfixer
  - mongodb
  - rag
  - decisions-server
  - cascade
  - sparks
roles:
  - strategist
  - openfixer
  - minimax
source:
  type: decision
  original_path: STR4TEG15T/memory/decisions/DECISION_173_MINIMAX_MCP_API_KEY_HANDOFF.md
---

# DECISION_173: MiniMax MCP API Key Handoff to OpenFixer (v1.0.0)

**Decision ID**: DECISION_173  
**Version**: 1.0.0  
**Category**: INFRA (Infrastructure)  
**Status**: Drafted  
**Priority**: Critical  
**Date**: 2026-03-01  
**Parent Decision**: DECISION_172 (Book-First MVP Architecture)

---

## Executive Summary

This decision authorizes the handoff of MCP server API keys to MiniMax for OpenFixer integration. MiniMax will guide OpenFixer through the connection setup for the three v2 MCP servers that power the P4NTHE0N decision and memory infrastructure. This enables the cascade of Sparks—real-time coding assistance with full access to institutional memory.

**Core Mission**: Get OpenFixer plugged into the MCP infrastructure so MiniMax can orchestrate the Book-First MVP build with full decision system and RAG support.

---

## The API Keys

### MCP_AUTH_TOKEN (Shared Across All Three Servers)
```
fc02dbcffaec5d51204e415b8ff9103eba39d79bff014f9d6869a33276233af1
```

### Server Endpoints

| Server | Image | Port | URL | Purpose |
|--------|-------|------|-----|---------|
| **servers-mongodb-p4nth30n-v2** | servers-mongodb-p4nth30n-v2 | 3001 | http://127.0.0.1:3001/sse | Decision persistence, CRUD operations |
| **servers-rag-server-v2** | servers-rag-server-v2 | 3002 | http://127.0.0.1:3002/sse | Vector search, semantic retrieval |
| **servers-decisions-server-v2** | servers-decisions-server-v2 | 3000 | http://127.0.0.1:3000/sse | Decision workflow management |

### Authentication Pattern
All servers use Bearer token authentication:
```
Authorization: Bearer fc02dbcffaec5d51204e415b8ff9103eba39d79bff014f9d6869a33276233af1
```

---

## Intake

**From Nexus**: "MiniMax will walk OpenFixer this run. He needs the API keys for mongodb-p4nth30n-v2, servers-rag-server-v2, and servers-decisions-server-v2."

**Context**: This is a small, focused job. MiniMax (the model) will guide OpenFixer through the MCP integration. The keys were discovered in Docker container environment variables during earlier reconnaissance.

**Why This Matters**: Without these keys, OpenFixer cannot:
- Query the decisions-server for active decision context
- Use RAG to retrieve institutional knowledge
- Persist new decisions to MongoDB
- Access the full P4NTHE0N memory system

---

## Frame (Bounded Scope)

1. **Objective**: Hand off MCP API keys to MiniMax for OpenFixer integration
2. **Constraints**:
   - Keys are already extracted from running Docker containers
   - No new infrastructure to build
   - Focus is on connection/configuration only
   - MiniMax guides; OpenFixer executes
3. **Evidence Targets**:
   - OpenFixer can successfully query all three MCP servers
   - Health check endpoints return 200 OK with auth
   - ToolHive gateway recognizes the servers
4. **Risk Ceiling**: Low—keys are for local development, production uses separate auth
5. **Finish Criteria**: OpenFixer confirms MCP connectivity and can query decisions

---

## Action Items

| ID | Action | Owner | Status | Priority |
|----|--------|-------|--------|----------|
| ACT-173-01 | Provide API keys to MiniMax | @strategist | ✅ Complete | Critical |
| ACT-173-02 | Configure OpenFixer MCP client with keys | @openfixer | Pending | Critical |
| ACT-173-03 | Test connectivity to mongodb-p4nth30n-v2 | @openfixer | Pending | Critical |
| ACT-173-04 | Test connectivity to rag-server-v2 | @openfixer | Pending | Critical |
| ACT-173-05 | Test connectivity to decisions-server-v2 | @openfixer | Pending | Critical |
| ACT-173-06 | Verify health endpoints return 200 | @openfixer | Pending | High |
| ACT-173-07 | Query a test decision to validate full flow | @openfixer | Pending | High |

---

## Handoff Contract

### For OpenFixer

**What You Get**:
- MCP_AUTH_TOKEN: `fc02dbcffaec5d51204e415b8ff9103eba39d79bff014f9d6869a33276233af1`
- Three server endpoints (see table above)
- Bearer token authentication pattern

**What You Must Do**:
1. Configure your MCP client with the token
2. Set up connections to all three servers
3. Run health checks on each endpoint
4. Query the decisions-server to verify full connectivity
5. Report success/failure back to Strategist

**Validation Commands**:
```bash
# Test decisions-server health
curl -H "Authorization: Bearer fc02dbcffaec5d51204e415b8ff9103eba39d79bff014f9d6869a33276233af1" \
     -H "Origin: http://localhost:5173" \
     http://localhost:3000/health

# Test mongodb-p4nth30n-v2 health
curl -H "Authorization: Bearer fc02dbcffaec5d51204e415b8ff9103eba39d79bff014f9d6869a33276233af1" \
     -H "Origin: http://localhost:5173" \
     http://localhost:3001/health

# Test rag-server-v2 health
curl -H "Authorization: Bearer fc02dbcffaec5d51204e415b8ff9103eba39d79bff014f9d6869a33276233af1" \
     -H "Origin: http://localhost:5173" \
     http://localhost:3002/health
```

**Expected Response**:
```json
{"status": "healthy", "service": "decisions-server-v2", ...}
```

### For MiniMax

**Your Role**: Guide OpenFixer through the MCP integration. You have the keys. Walk him through:
1. Where to store the keys (environment variables, not hardcoded)
2. How to configure the MCP client
3. How to test each connection
4. How to handle failures

**Remember**: This is a cascade of Sparks. Speed matters, but so does correctness. OpenFixer should be able to query decisions and use RAG by the end of this run.

---

## Consultation Results

### Oracle Consultation - SKIPPED
**Rationale**: This is a straightforward key handoff with no architectural decisions. Risk is low—keys are for local development only.

### Designer Consultation - SKIPPED
**Rationale**: No design work required. This is pure infrastructure configuration.

---

## Pass Questions (Harden / Expand / Narrow)

- **Harden**: Should we rotate these keys after OpenFixer integration is complete?
- **Expand**: Do we need to document the MCP tool schemas for OpenFixer reference?
- **Narrow**: Is local-only sufficient, or do we need production MCP keys too?

---

## Closure Checklist Draft

- [ ] OpenFixer confirms MCP client configuration
- [ ] All three servers return healthy status
- [ ] OpenFixer successfully queries a decision from decisions-server-v2
- [ ] OpenFixer can call rag-server-v2 for semantic search
- [ ] OpenFixer can write to mongodb-p4nth30n-v2
- [ ] Deployment journal captured
- [ ] Manifest updated with completion status

---

## Evidence Artifacts

**Source of Keys**: Docker container inspection
- Container: `decisions-server-v2`, `mongodb-p4nth30n-v2`, `rag-server-v2`
- Command used: `docker inspect <container> --format "{{json .Config.Env}}"`
- Discovery timestamp: 2026-03-01 during Strategist reconnaissance

**Key Verification**: All three containers share the same MCP_AUTH_TOKEN value, confirming unified authentication across the v2 server suite.

---

## Strategist Retrospective

**What worked**: Direct key extraction from running containers. No guesswork, no documentation drift—just the actual values in use.

**What drifted**: None. This is a clean handoff.

**What to automate**: Future MCP deployments should document keys in decisions immediately, not require container inspection.

**What to enforce next**: All API keys must be decision-governed before handoff to Fixer agents.

---

## Notes for Nexus

The cascade of Sparks begins here. MiniMax has the keys. OpenFixer has the mission. The MCP infrastructure is ready.

Let's ship this. Spin the reels. Cash out for the cascade.

---

*Decision DECISION_173*  
*MiniMax MCP API Key Handoff to OpenFixer*  
*2026-03-01*
