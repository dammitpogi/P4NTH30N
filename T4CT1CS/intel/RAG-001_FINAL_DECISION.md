# RAG-001 DECISION SYNTHESIS
## Final Architecture Approved - Ready for Implementation

**Date**: 2026-02-18  
**Status**: ✅ APPROVED - Implementation can proceed with conditions  
**Final Approval**: Designer 90/100, Oracle 82/100 CONDITIONAL

---

## APPROVAL SUMMARY

| Consultant | Rating | Status |
|------------|--------|--------|
| **Designer** | 90/100 | ✅ APPROVED |
| **Oracle** | 82/100 | ✅ CONDITIONAL APPROVAL |
| **Consensus** | 86/100 | ✅ PROCEED WITH CONDITIONS |

---

## FINAL ARCHITECTURE DECISIONS

### 1. MCP as Primary Interface ✅
- **Decision**: MCP Server with 6 tools
- **Rating**: Designer 90/100, Oracle APPROVED
- **Rationale**: Agents already use MCP pattern, self-documenting, composable
- **Tools**: rag_query, rag_ingest, rag_ingest_file, rag_status, rag_rebuild_index, rag_search_similar

### 2. Embedding Service ✅
- **Decision**: ONNX Runtime in-process with sentence-transformers fallback
- **Rating**: Designer 85/100
- **Model**: all-MiniLM-L6-v2 (primary), bge-small-en-v1.5 (upgrade path)
- **Performance**: 50-75ms single embedding (Oracle adjusted target)

### 3. Vector Store ✅
- **Decision**: FAISS IndexFlatL2 + MongoDB metadata
- **Rating**: Designer 88/100
- **Migration**: Upgrade to IVF at 50k vectors
- **Persistence**: Backup + atomic swap for reliability

### 4. Ingestion Strategy ✅
- **Decision**: Hybrid approach
- **Components**:
  - FileSystemWatcher (1-5 min debounce)
  - MongoDB Change Streams (30 sec batch)
  - 4-hour incremental rebuilds (Oracle addition)
  - Nightly full rebuild at 3 AM

### 5. Context Assembly ✅
- **Decision**: Structured with sources
- **Format**: Source attribution, relevance scores, token budget 2000
- **Rating**: Designer 95/100

### 6. Agent Integration ✅
- **Decision**: Explicit Context Builder primary, Direct MCP common case
- **Rating**: Designer 80/100
- **NOT recommended**: RAG Middleware (auto-context) - 60/100, too risky

### 7. Chunking Strategy ✅
- **Decision**: 512 tokens with 15% overlap (77 tokens)
- **Oracle adjustment**: Increased from 10% to 15% for better recall
- **AST-aware**: For code (class/method boundaries)
- **Section-aware**: For docs (heading boundaries)

### 8. Security Model ⚠️ CONDITIONAL
- **Decision**: Metadata filtering by agent ID (NOT separate indexes)
- **Oracle Conditions**:
  - Server-side filter validation (MANDATORY)
  - Audit logging to EV3NT (MANDATORY)
  - Query whitelist for filterable fields (MANDATORY)
  - Test suite verifying filter bypass impossible (MANDATORY)

### 9. Performance Targets ✅
| Metric | Target | Status |
|--------|--------|--------|
| Query latency | <100ms (p95) | ✅ Approved |
| Embedding | 50-75ms | ✅ Oracle adjusted |
| Index size | <500MB (target), <10GB (max) | ✅ Approved |
| Accuracy | >90% (top-5) | ✅ Approved |
| Success rate | >99.5% | ✅ Oracle addition |

### 10. Python Bridge ⚠️ CONDITIONAL
- **Decision**: Accept Python bridges with mitigation
- **Oracle Conditions**:
  - Process pool (2-3 warm processes)
  - Auto-restart with exponential backoff
  - 30-second timeout enforcement
  - 1GB memory limit per process
  - Startup health verification

---

## ORACLE CONDITIONS (MUST FIX BEFORE IMPLEMENTATION)

### Blocking (Required)
1. ✅ **Metadata filter security**: Server-side validation + audit logging to EV3NT
2. ✅ **ERR0R sanitization pipeline**: Pre-ingestion (not query-time)
3. ✅ **Python bridge integration**: EmbeddingService.cs, FaissVectorStore.cs with process pool
4. ✅ **Health monitoring**: Integration with existing /health endpoint

### Should Fix (Before Production)
5. ✅ **4-hour incremental rebuilds**: Reduce nightly full rebuild load
6. ✅ **Accuracy metrics**: Define and track top-1 match rate, MRR@5
7. ✅ **Degraded mode**: Return partial results with warning instead of failure

### Nice to Have (Post-MVP)
8. ✅ **C# port evaluation**: Reassess after 90 days of operation

---

## SANITIZATION RULES (Oracle Approved)

| Data Type | Rule | Action |
|-----------|------|--------|
| **File paths** | Replace with relative | `C:\P4NTH30N\C0MMON\...` → `C0MMON/...` |
| **Line numbers** | Hash or remove | Protect code structure |
| **Stack traces** | Strip to exception type | Remove implementation details |
| **Credentials** | REJECT entire document | Never ingest secrets |
| **User identifiers** | Hash with SHA-256 | PII protection |
| **Exception messages** | Allow but redact URLs/IPs | Useful for debugging |

---

## WHAT NOT TO STORE IN RAG

- ❌ Credentials, passwords, API keys
- ❌ Sensitive user data (PII)
- ❌ Internal security assessments
- ❌ Unsanitized error details
- ❌ Raw stack traces

---

## MONITORING REQUIREMENTS (Oracle)

### Key Metrics
| Metric | Target | Alert |
|--------|--------|-------|
| Query latency (p95) | <100ms | >150ms |
| Query latency (p99) | <200ms | >300ms |
| Embedding latency (p95) | <75ms | >100ms |
| Index size | <500MB | >1GB |
| Query success rate | >99.5% | <99% |
| Rebuild duration | <60min | >90min |
| Python restarts | 0/day | >5/day |

### Dashboards
1. RAG Operations: Query volume, latency percentiles, error rates
2. Index Health: Vector count, index size, last rebuild
3. Ingestion Pipeline: Documents processed, sanitization rejections

### Alerting
| Condition | Severity | Action |
|-----------|----------|--------|
| RAG MCP server down | CRITICAL | Page on-call, fallback to non-RAG |
| Index corruption | CRITICAL | Alert + auto-failover to backup |
| Query error rate >1% | WARNING | Investigate within 1 hour |
| Embedding latency >100ms | WARNING | Investigate within 4 hours |
| Python restart >5/day | WARNING | Investigate memory/timeout |
| Rebuild fails | CRITICAL | Alert + keep previous index |

---

## RISK ASSESSMENT (Oracle)

| Risk | Likelihood | Impact | Mitigation |
|------|------------|--------|------------|
| Metadata filter bypass | Low | Critical | Validation + logging + tests |
| Python process crash | Medium | High | Process pool + restart |
| Index corruption | Low | Critical | Backup + atomic swap |
| Performance targets missed | Medium | Medium | Caching + batch |
| ERR0R sanitization failure | Low | Medium | Pre-ingestion validation |

---

## IMPLEMENTATION TIMELINE

### Phase 1: MCP Server Foundation + Security (Week 1)
- Days 1-5: MCP Server, EmbeddingService, FaissVectorStore, 6 MCP tools
- **CRITICAL**: Metadata filter security + ERR0R sanitization pipeline

### Phase 2: Core RAG Pipeline + Ingestion (Week 2)
- Days 6-11: Query pipeline, Ingestion pipeline, FileSystemWatcher, Change Streams
- **ADDITION**: 4-hour incremental rebuilds

### Phase 3: Production Hardening + Monitoring (Week 3)
- Days 12-15: Performance optimization, 3 AM nightly rebuild, health checks
- **ADDITION**: Degraded mode, accuracy metrics tracking

**Total**: 15 days (3 weeks)

---

## FILES TO IMPLEMENT

```
src/RAG/
├── McpServer.cs                    # MCP server with 6 tools
├── EmbeddingService.cs             # ONNX + sentence-transformers
├── FaissVectorStore.cs            # FAISS IndexFlatL2
├── QueryPipeline.cs               # embed → search → join → format
├── IngestionPipeline.cs           # chunk → embed → store
├── SanitizationPipeline.cs        # ERR0R preprocessing
├── ContextBuilder.cs              # Structured context assembly
└── HealthMonitor.cs               # Integration with /health

scripts/rag/
├── rebuild-index.ps1              # Nightly rebuild script
└── health-check.ps1               # Python bridge health check
```

---

## REFERENCE DOCUMENTS

1. `T4CT1CS/intel/RAG-001_IMPLEMENTATION_GUIDE.md` - Technical specification
2. `T4CT1CS/intel/MCP_EXPOSED_RAG_ARCHITECTURE.md` - MCP architecture
3. `T4CT1CS/intel/DESIGNER_BRIEF_MCP_RAG.md` - Designer consultation
4. `T4CT1CS/intel/ORACLE_BRIEF_RAG001.md` - Oracle consultation
5. `T4CT1CS/intel/RAG_*_AUDIT.md` - 6 WindFixer discovery docs

---

## NEXT STEPS

1. ✅ **Decision Approved**: RAG-001 ready for implementation
2. 🔄 **Begin Phase 1**: MCP Server Foundation + Security
3. ⚠️ **Address Conditions**: Metadata filter security before any agent uses RAG
4. 📊 **Set Up Monitoring**: Dashboards and alerting
5. 🚀 **Deploy**: 3-week implementation timeline

---

**RAG-001: CONDITIONALLY APPROVED (86/100 consensus)**

**Implementation can proceed with Oracle conditions met.**

**Designer**: 90/100 - Excellent architecture, MCP-first approach justified  
**Oracle**: 82/100 - Sound with conditions, security requirements mandatory  
**Consensus**: Proceed with implementation, address blocking conditions in Phase 1
