# DECISION_100: Integrate Theseus Plugin Fallback System for Oracle Repair

**Decision ID**: DECISION_100  
**Category**: INFRA (Infrastructure)  
**Status**: Proposed  
**Priority**: Critical  
**Date**: 2026-02-22  
**Oracle Approval**: [Pending]  
**Designer Approval**: [Pending]

---

## Executive Summary

Integrate the oh-my-opencode-theseus plugin's sophisticated fallback and resilience system into P4NTH30N's OpenCode infrastructure. The primary goal is to **repair Oracle** - ensuring the Oracle agent (Orion) has robust model fallback chains, error recovery, and circuit breaker protection when providing critical risk assessments and approvals.

**Key Insight from Theseus**: The plugin's fallback system has proven itself in production with:
- Automatic model fallback chains when primary models fail
- Circuit breaker pattern to prevent cascade failures  
- Error classification (NetworkTransient, ProviderRateLimit, ProviderError, ContextLength)
- Exponential backoff with jitter
- Health monitoring and task restart capabilities

---

## Background

### Current State
- **Oracle (Orion)** provides risk assessments and approval ratings for decisions
- When Oracle's model fails (rate limits, context length, service unavailable), we lose critical decision-making capability
- No automatic fallback exists - Strategist must assimilate Oracle role manually
- This creates bottlenecks and delays in the decision pipeline

### The Theseus Plugin
Located at `C:\P4NTH30N\plugins\theseues`, this is a production-hardened OpenCode plugin featuring:

| Component | Purpose |
|-----------|---------|
| **ErrorClassifier** | Categorizes errors into 6 types (NetworkTransient, ProviderRateLimit, ProviderError, ContextLength, NetworkPermanent, LogicError) |
| **NetworkCircuitBreaker** | Per-endpoint circuit breaking with 5-min cooldown |
| **BackoffManager** | Exponential backoff with jitter for retries |
| **ConnectionHealthMonitor** | Per-session health tracking |
| **TaskRestartManager** | Auto-restart for network-failed tasks |
| **RetryMetrics** | Visibility and alerting for retry activity |
| **Background Task Manager** | Fire-and-forget with resilience |

### The Gap
Oracle has no fallback protection. When the primary model fails:
1. Decision-making halts
2. Strategist must assimilate Oracle role (quality degradation)
3. No automatic recovery mechanism
4. No visibility into failure patterns

### Desired State
Oracle with Theseus-style resilience:
1. **Model Fallback Chain**: Oracle → Backup Oracle → Generalist Model
2. **Automatic Recovery**: Context length errors trigger compaction, then retry
3. **Circuit Breaker**: Stop trying failed models for 1 hour after 3 failures
4. **Health Monitoring**: Track Oracle availability and response quality
5. **Metrics**: Visibility into fallback frequency and recovery success

---

## Research Foundation

### Source 1: Theseus Plugin Fallback System (from Explorer Analysis)

**Core Components**:
1. **ErrorClassifier** - 6 error types (ContextLength, NetworkTransient, ProviderRateLimit, ProviderError, NetworkPermanent, LogicError)
2. **NetworkCircuitBreaker** - 3 states (CLOSED, OPEN, HALF_OPEN), 5 failures → 5min cooldown
3. **BackoffManager** - Exponential backoff with jitter (1s base, 30s cap, 20% jitter)
4. **BackgroundTaskManager** - Orchestrates fallback chains, tracks activeModel
5. **Configuration** - fallback.chains in oh-my-opencode-theseus.json

**Data Flow**:
```
Error occurs → ErrorClassifier categorizes → Decision:
  - ProviderError → Fallback to next model
  - NetworkTransient/RateLimit → Retry with backoff
  - ContextLength → Compact + retry
  - Permanent/Logic → Fail immediately
```

### Source 2: Update-Agent-Models Skill (from Explorer Analysis)

**Purpose**: Automated model-chain optimization for `oh-my-opencode-theseus.json`

**16 Required Benchmarks**:
1. gpqa - Graduate-Level Google-Proof Q&A
2. mmlu_pro - Massive Multitask Language Understanding Professional
3. intelligence_index - Overall intelligence score
4. ifbench - Instruction Following Benchmark
5. context_length - Maximum context window size
6. tau2 - Tau-squared efficiency metric
7. gdpval_aa_elo - Artificial Analysis GDPval ELO rating
8. aime - AI Mathematical Evaluation
9. math_index - Mathematical capability index
10. hle - Humanity's Last Exam
11. terminalbench_hard - Terminal interaction benchmark
12. coding_index - Coding capability index
13. swe_bench_pro - Professional software engineering tasks
14. swe_bench_verified - Verified software engineering tasks
15. livecodebench - Live coding performance
16. scicode - Scientific code generation

**Oracle-Specific Scoring** (from bench_calc.json):
- gpqa: 50% (advanced reasoning)
- aime: 20% (mathematical reasoning)
- math_index: 15% (mathematical capability)
- mmlu_pro: 10% (general knowledge)
- hle: 5% (comprehensive knowledge)

**Scoring Algorithm**:
```
Oracle_Score = (gpqa * 0.45) + (aime * 0.2) + ((math_index / 100) * 0.2) + (mmlu_pro * 0.1) + (hle * 0.05)
```

**Normalization Constants**:
- MAX_CONTEXT_LENGTH = 2,000,000 tokens
- MAX_GDPVAL_AA_ELO = 2000
- MAX_INDEX_SCORE = 100
- MAX_PERCENT_SCORE = 100

**7-Phase Workflow**:
1. Guard pre-checks (schema validation)
2. Model refresh (test-models.sh)
3. Budget refresh (OpenAI usage)
4. AA API Research (benchmark collection)
5. Local Benchmark Execution (IFBench, MMLU-Pro, GPQA)
6. Web Research (ToolHive search)
7. SWE-Bench-Pro Proxy (ML estimation)
8. User Interview Gate (one model at a time)
9. Normalization (automatic)
10. Optimization (chain reordering)
11. Guard post-checks

### Source 3: ArXiv Papers on Resilience and Fallback Systems

**To be researched**:
- Circuit breaker patterns in distributed systems
- Model fallback strategies for LLM agents
- Error classification and recovery in AI systems
- Health monitoring for agent orchestration

---

## Specification

### Architecture: Unified Resilience + Model Optimization System

```
┌─────────────────────────────────────────────────────────────────────────────┐
│              DECISION_100: ORACLE REPAIR + MODEL OPTIMIZATION               │
├─────────────────────────────────────────────────────────────────────────────┤
│                                                                             │
│  ┌─────────────────────────────────────────────────────────────────────┐   │
│  │              MODEL TESTING & ALGORITHMIC BALANCING                  │   │
│  │         (from update-agent-models skill)                            │   │
│  │                                                                     │   │
│  │  ┌─────────────┐  ┌─────────────┐  ┌─────────────┐  ┌────────────┐ │   │
│  │  │ 16 Benchmark│──▶│Normalization│──▶│Agent-Specific│──▶│Optimized   │ │   │
│  │  │   Testing   │  │   (0-1)     │  │   Scoring    │  │Model Chain │ │   │
│  │  └─────────────┘  └─────────────┘  └─────────────┘  └────────────┘ │   │
│  │                                                                     │   │
│  │  Oracle Scoring: gpqa(45%) + aime(20%) + math_index(20%) + ...     │   │
│  │  Source: bench_calc.json                                            │   │
│  └─────────────────────────────────────────────────────────────────────┘   │
│                                    │                                        │
│                                    ▼                                        │
│  ┌─────────────────────────────────────────────────────────────────────┐   │
│  │              THESEUS FALLBACK RESILIENCE LAYER                      │   │
│  │                                                                     │   │
│  │  ┌─────────────┐  ┌─────────────┐  ┌─────────────┐  ┌────────────┐ │   │
│  │  │   Error     │──▶│   Circuit   │──▶│   Backoff   │──▶│  Fallback  │ │   │
│  │  │  Classifier │  │   Breaker   │  │   Manager   │  │   Engine   │ │   │
│  │  └─────────────┘  └─────────────┘  └─────────────┘  └────────────┘ │   │
│  │                                                                     │   │
│  │  Error Types: ProviderError → Fallback to next model in chain      │   │
│  │               NetworkTransient → Retry with exponential backoff    │   │
│  │               ContextLength → Compact session + retry              │   │
│  └─────────────────────────────────────────────────────────────────────┘   │
│                                    │                                        │
│                                    ▼                                        │
│  ┌─────────────────────────────────────────────────────────────────────┐   │
│  │              OPENCODE PLUGIN INTEGRATION                            │   │
│  │                                                                     │   │
│  │  • Hook-based Oracle agent interception                            │   │
│  │  • Automatic fallback on model failure                             │   │
│  │  • Context preservation during retry/fallback                      │   │
│  │  • Metrics export for monitoring                                   │   │
│  └─────────────────────────────────────────────────────────────────────┘   │
│                                                                             │
└─────────────────────────────────────────────────────────────────────────────┘
```
┌─────────────────────────────────────────────────────────────────────────────┐
│                         ORACLE RESILIENCE LAYER                             │
├─────────────────────────────────────────────────────────────────────────────┤
│                                                                             │
│   ┌─────────────────┐     ┌─────────────────┐     ┌─────────────────┐      │
│   │   Oracle Call   │────▶│ ErrorClassifier │────▶│  Decision Point │      │
│   │   (Primary)     │     │   (Theseus)     │     │                 │      │
│   └─────────────────┘     └─────────────────┘     └────────┬────────┘      │
│                                                            │               │
│                    ┌───────────────────────────────────────┼───────────┐   │
│                    │                                       ▼           │   │
│                    │  ┌─────────────────┐  ┌─────────────────────────┐  │   │
│                    │  │ NetworkTransient│  │  Retry with Backoff     │  │   │
│                    │  │ ProviderRateLimit│  │  (same model)           │  │   │
│                    │  └─────────────────┘  └─────────────────────────┘  │   │
│                    │                                                   │   │
│                    │  ┌─────────────────┐  ┌─────────────────────────┐  │   │
│                    │  │ ProviderError   │──▶│  Fallback to Next Model │  │   │
│                    │  │ (model failure) │  │  (Oracle chain)         │  │   │
│                    │  └─────────────────┘  └─────────────────────────┘  │   │
│                    │                                                   │   │
│                    │  ┌─────────────────┐  ┌─────────────────────────┐  │   │
│                    │  │ ContextLength   │──▶│  Compact + Retry        │  │   │
│                    │  │ (token limit)   │  │  (same model)           │  │   │
│                    │  └─────────────────┘  └─────────────────────────┘  │   │
│                    │                                                   │   │
│                    │  ┌─────────────────┐  ┌─────────────────────────┐  │   │
│                    │  │ LogicError      │──▶│  Fail Immediately       │  │   │
│                    │  │ (unrecoverable) │  │  (no retry)             │  │   │
│                    │  └─────────────────┘  └─────────────────────────┘  │   │
│                    │                                                   │   │
│                    └───────────────────────────────────────────────────┘   │
│                                                                             │
│   ┌─────────────────────────────────────────────────────────────────────┐  │
│   │                    CIRCUIT BREAKER (per model)                      │  │
│   │                                                                     │  │
│   │   State: CLOSED ──fail──▶ OPEN ──5min──▶ HALF_OPEN ──success──▶ CLOSED │
│   │                                                                     │  │
│   │   After 3 failures in 1 hour: Block model, use fallback           │  │
│   └─────────────────────────────────────────────────────────────────────┘  │
│                                                                             │
└─────────────────────────────────────────────────────────────────────────────┘
```

### Requirements

1. **INFRA-100-001**: Error Classification Integration
   - **Priority**: Must
   - **Acceptance Criteria**: All Oracle errors classified into 6 types
   - **Implementation**: Port ErrorClassifier from Theseus to P4NTH30N

2. **INFRA-100-002**: Model Fallback Chain for Oracle
   - **Priority**: Must
   - **Acceptance Criteria**: Oracle automatically falls back to backup models
   - **Implementation**: Configure fallback chain in opencode.json

3. **INFRA-100-003**: Circuit Breaker Pattern
   - **Priority**: Must
   - **Acceptance Criteria**: Failed models blocked for 1 hour after 3 failures
   - **Implementation**: Port NetworkCircuitBreaker from Theseus

4. **INFRA-100-004**: Context Length Recovery
   - **Priority**: Must
   - **Acceptance Criteria**: Context length errors trigger compaction + retry
   - **Implementation**: Port compaction logic from Theseus background-manager

5. **INFRA-100-005**: Health Monitoring
   - **Priority**: Should
   - **Acceptance Criteria**: Track Oracle availability and response quality
   - **Implementation**: Port ConnectionHealthMonitor from Theseus

6. **INFRA-100-006**: Metrics and Alerting
   - **Priority**: Should
   - **Acceptance Criteria**: Visibility into fallback frequency and recovery
   - **Implementation**: Port RetryMetrics from Theseus

---

## Technical Details

### Files to Port from Theseus

**Core Resilience Components**:
1. `src/background/resilience/error-classifier.ts` → `STR4TEG15T/tools/resilience/`
2. `src/background/resilience/network-circuit-breaker.ts` → `STR4TEG15T/tools/resilience/`
3. `src/background/resilience/backoff-manager.ts` → `STR4TEG15T/tools/resilience/`
4. `src/background/resilience/connection-health-monitor.ts` → `STR4TEG15T/tools/resilience/`
5. `src/background/resilience/retry-metrics.ts` → `STR4TEG15T/tools/resilience/`

**Integration Points**:
6. `src/background/background-manager.ts` → Adapter for OpenCode integration
7. `src/config/constants.ts` → Model fallback chain configuration

### Oracle Configuration

#### Standard Fallback Chain (4 models)

```json
// opencode.json
{
  "agents": {
    "oracle": {
      "currentModel": "openrouter/claude-3.5-sonnet",
      "models": [
        "openrouter/claude-3.5-sonnet",
        "openrouter/gpt-4",
        "openrouter/gemini-pro",
        "openrouter/mistral-large"
      ],
      "fallback": {
        "enabled": true,
        "maxRetries": 3,
        "circuitBreaker": {
          "failureThreshold": 3,
          "cooldownMs": 3600000
        }
      }
    }
  }
}
```

#### Extended Fallback Chain (10+ models) - RECOMMENDED

Based on Explorer analysis, use extended chain for maximum resilience:

```json
// opencode.json - Extended Oracle Fallback Chain
{
  "agents": {
    "oracle": {
      "currentModel": "openrouter/claude-3.5-sonnet",
      "models": [
        // Tier 1: Premium Models (Benchmark-optimized for Oracle)
        "openrouter/claude-3.5-sonnet",    // Primary: gpqa 45%, aime 20%
        "openrouter/claude-3-opus",        // Backup: High reasoning
        "openrouter/gpt-4",                // Backup: Generalist
        
        // Tier 2: Strong Alternatives
        "openrouter/gemini-pro",           // Google: Strong reasoning
        "openrouter/mistral-large",        // Mistral: European provider
        "openrouter/llama-3.3-70b",        // Meta: Open source
        
        // Tier 3: Additional Coverage
        "openrouter/qwen-2.5-72b",         // Alibaba: Strong math
        "openrouter/deepseek-chat",        // DeepSeek: Cost-effective
        "openrouter/nous-hermes-2",        // Nous: Reasoning focus
        
        // Tier 4: Bridge + Local Fallback
        "free/openrouter/free",            // Bridge model (excluded from research)
        "lmstudio-local/llama-3.2-1b",     // Local: Zero API cost
        "lmstudio-local/qwen-0.5b"         // Local: Tiny, always available
      ],
      "fallback": {
        "enabled": true,
        "maxRetries": 3,
        "circuitBreaker": {
          "failureThreshold": 3,
          "cooldownMs": 3600000
        },
        "extendedChain": {
          "enabled": true,
          "tiers": [
            {"name": "premium", "models": ["claude-3.5-sonnet", "claude-3-opus", "gpt-4"]},
            {"name": "standard", "models": ["gemini-pro", "mistral-large", "llama-3.3-70b"]},
            {"name": "alternative", "models": ["qwen-2.5-72b", "deepseek-chat", "nous-hermes-2"]},
            {"name": "local", "models": ["free/openrouter/free", "lmstudio-local/*"]}
          ]
        }
      }
    }
  }
}
```

#### Extended Chain Benefits

| Tier | Models | Purpose |
|------|--------|---------|
| **Premium** | 3 | Highest benchmark scores for Oracle (gpqa, aime) |
| **Standard** | 3 | Diverse providers, strong performance |
| **Alternative** | 3 | Geographic/provider diversity |
| **Local** | 2+ | Zero-cost, always-available fallback |

**Total Coverage**: 11+ models across 4 tiers
**Provider Diversity**: Anthropic, OpenAI, Google, Mistral, Meta, Alibaba, DeepSeek, Nous, Local
**Geographic Diversity**: US, EU, China (via OpenRouter)
**Cost Diversity**: Premium → Standard → Free → Local

#### Triage Scorecard Configuration

```json
{
  "fallback": {
    "triage": {
      "enabled": true,
      "scorecard": {
        "trackMetrics": [
          "totalCalls",
          "successes",
          "failures",
          "successRate",
          "avgResponseTimeMs",
          "circuitBreakerActivations",
          "failureReasons"
        ],
        "exportFormat": "json",
        "exportPath": "~/.local/share/opencode/oracle-triage-scorecard.json",
        "generateReport": true,
        "reportInterval": "end-of-session"
      }
    }
  }
}
```

### Integration Architecture

```
┌─────────────────────────────────────────────────────────────────┐
│                    OPENCODE PLUGIN ARCHITECTURE                 │
├─────────────────────────────────────────────────────────────────┤
│                                                                 │
│   ┌─────────────┐                                              │
│   │   Oracle    │◀── Request (risk assessment)                 │
│   │   Agent     │                                              │
│   └──────┬──────┘                                              │
│          │                                                      │
│          ▼                                                      │
│   ┌─────────────────────────────────────────────────────────┐  │
│   │              ORACLE RESILIENCE ADAPTER                  │  │
│   │  (Ported from Theseus background-manager.ts)            │  │
│   ├─────────────────────────────────────────────────────────┤  │
│   │  ErrorClassifier ──▶ Classify error type                │  │
│   │  CircuitBreaker ───▶ Check if model blocked             │  │
│   │  BackoffManager ───▶ Calculate retry delay              │  │
│   │  HealthMonitor ────▶ Track model health                 │  │
│   └─────────────────────────────────────────────────────────┘  │
│          │                                                      │
│          ▼                                                      │
│   ┌─────────────────────────────────────────────────────────┐  │
│   │              FALLBACK DECISION ENGINE                   │  │
│   ├─────────────────────────────────────────────────────────┤  │
│   │  ProviderError ──────▶ Next model in chain              │  │
│   │  ContextLength ──────▶ Compact + retry same model       │  │
│   │  RateLimit ──────────▶ Exponential backoff              │  │
│   │  NetworkTransient ───▶ Retry with backoff               │  │
│   │  LogicError ─────────▶ Fail immediately                 │  │
│   └─────────────────────────────────────────────────────────┘  │
│          │                                                      │
│          ▼                                                      │
│   ┌─────────────┐     ┌─────────────┐     ┌─────────────┐     │
│   │   Model 1   │────▶│   Model 2   │────▶│   Model 3   │     │
│   │  (Primary)  │     │  (Fallback) │     │ (Emergency) │     │
│   └─────────────┘     └─────────────┘     └─────────────┘     │
│                                                                 │
└─────────────────────────────────────────────────────────────────┘
```

---

## Implementation Strategy

### Phase 1: Port Core Resilience Components (4 hours)

1. **ErrorClassifier** (1 hour)
   - Copy from Theseus
   - Adapt to P4NTH30N logging
   - Add Oracle-specific error patterns

2. **CircuitBreaker** (1 hour)
   - Copy from Theseus
   - Adapt for model-level breaking (1 hour cooldown)
   - Integrate with opencode.json config

3. **BackoffManager** (1 hour)
   - Copy from Theseus
   - Configure for Oracle use case
   - Add jitter for thundering herd prevention

4. **HealthMonitor + Metrics** (1 hour)
   - Copy from Theseus
   - Adapt for single-agent monitoring
   - Add Prometheus-style metrics

### Phase 2: Oracle Adapter (3 hours)

1. **OracleResilienceAdapter** (2 hours)
   - Wrap Oracle agent calls
   - Implement fallback chain logic
   - Handle context length compaction

2. **Configuration Integration** (1 hour)
   - Read fallback chains from opencode.json
   - Validate configuration
   - Hot-reload support

### Phase 3: Testing and Validation (3 hours)

1. **Unit Tests** (1.5 hours)
   - Error classification tests
   - Circuit breaker state machine tests
   - Fallback chain tests

2. **Integration Tests** (1.5 hours)
   - End-to-end Oracle fallback
   - Context length recovery
   - Circuit breaker activation

**Total Estimated Effort**: 10 hours

---

## Success Criteria

1. ✅ Oracle errors classified correctly (6 types)
2. ✅ Model fallback chain executes automatically
3. ✅ Circuit breaker blocks failed models for 1 hour
4. ✅ Context length errors trigger compaction + retry
5. ✅ Health metrics visible (fallback frequency, recovery success)
6. ✅ Oracle availability > 99% (with fallback)
7. ✅ Zero manual Oracle assimilation required
8. ✅ Extended fallback chain (10+ models) configured
9. ✅ Triage scorecard tracks all model performance
10. ✅ End-game report generated with model rankings

---

## Risk Assessment

| Risk | Probability | Impact | Mitigation |
|------|-------------|--------|------------|
| Port introduces bugs | Medium | High | Comprehensive testing, gradual rollout |
| Performance overhead | Low | Medium | Benchmark before/after, optimize hot paths |
| Configuration complexity | Medium | Low | Clear documentation, validation |
| Integration with existing | Medium | High | Adapter pattern, backward compatibility |

---

## Dependencies

- **Source**: oh-my-opencode-theseus plugin (`C:\P4NTH30N\plugins\theseues`)
- **Target**: OpenCode plugin infrastructure
- **Blocks**: DECISION_101 (Oracle Repair via Fallback)
- **Blocked by**: None

---

## Handoff to OpenFixer

**OpenFixer**: Port Theseus resilience system for Oracle repair.

**Source Files** (from `C:\P4NTH30N\plugins\theseues\src\`):
1. `background/resilience/error-classifier.ts`
2. `background/resilience/network-circuit-breaker.ts`
3. `background/resilience/backoff-manager.ts`
4. `background/resilience/connection-health-monitor.ts`
5. `background/resilience/retry-metrics.ts`

**Target Location**: `C:\P4NTH30N\STR4TEG15T\tools\oracle-resilience\`

**Integration Target**: OpenCode plugin at `~/.config/opencode/plugins/`

**Key Deliverables**:
1. Ported resilience components (TypeScript)
2. OracleResilienceAdapter class
3. opencode.json configuration schema
4. Unit tests for all components
5. Integration test demonstrating Oracle fallback

**Validation**:
```typescript
// Test Oracle fallback
const oracle = new OracleResilienceAdapter({
  primaryModel: 'claude-3.5-sonnet',
  fallbackModels: ['gpt-4', 'gemini-pro'],
  circuitBreaker: { failureThreshold: 3, cooldownMs: 3600000 }
});

// Simulate primary model failure
const result = await oracle.consult('DECISION_100', context);
// Should automatically fall back to gpt-4
```

---

## Post-Implementation

1. Deploy to OpenCode plugin directory
2. Configure Oracle fallback chains
3. Test with simulated failures
4. Monitor metrics for 1 week
5. Document Oracle availability improvements

---

## Metadata

- **Source**: oh-my-opencode-theseus v0.7.4
- **Research**: Circuit breaker patterns, LLM fallback strategies
- **Primary Goal**: Repair Oracle with automatic fallback
- **Secondary Goals**: General resilience for all Pantheon agents
- **Estimated Effort**: 10 hours
- **Actual Effort**: [To be filled by OpenFixer]
