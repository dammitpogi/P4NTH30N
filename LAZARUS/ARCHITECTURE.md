# Lazarus Protocol: Self-Healing System Architecture

## DECISION_050 Design Specification

**Version**: 1.0  
**Status**: Draft  
**Classification**: System Architecture  
**Scope**: P4NTH30N + oh-my-opencode-theseus Integration  

---

## 1. System Philosophy

### The Lazarus Covenant
> *"We do not resurrect blindly. We resurrect with memory, with caution, and with purpose."*

The Lazarus Protocol treats system failures as **recovery opportunities**, not terminal conditions. It operates on three inviolable principles:

1. **First, Do No Harm**: All healing actions have safety levels and circuit breakers
2. **Learn or Die**: Every failure teaches; patterns drive prevention
3. **Graceful Degradation**: When healing fails, the system narrows scope, never explodes it

### Design Tenets

| Tenet | Implementation |
|-------|---------------|
| **Observability First** | Every component emits structured telemetry |
| **Idempotent Healing** | Same healing action twice = same result |
| **Contextual Awareness** | Healing considers error history, not just current state |
| **Human Sovereignty** | Critical decisions require human approval; automation handles routine |

---

## 2. Architectural Overview

```
┌─────────────────────────────────────────────────────────────────────────────┐
│                         LAZARUS PROTOCOL ARCHITECTURE                        │
├─────────────────────────────────────────────────────────────────────────────┤
│                                                                              │
│  ┌─────────────────┐    ┌─────────────────┐    ┌─────────────────────────┐  │
│  │  Error Sources  │    │  Error Sources  │    │      Error Sources      │  │
│  │   (P4NTH30N)    │    │ (oh-my-opencode)│    │      (External)         │  │
│  │                 │    │                 │    │                         │  │
│  │ • Agent crashes │    │ • Plugin errors │    │ • MongoDB failures      │  │
│  │ • CDP failures  │    │ • Model timeouts│    │ • Network partitions    │  │
│  │ • Decision bugs │    │ • Task failures │    │ • Chrome crashes        │  │
│  │ • Session death │    │ • Config errors │    │ • Disk full             │  │
│  └────────┬────────┘    └────────┬────────┘    └────────────┬────────────┘  │
│           │                      │                          │               │
│           └──────────────────────┼──────────────────────────┘               │
│                                  │                                          │
│                                  ▼                                          │
│  ┌─────────────────────────────────────────────────────────────────────┐   │
│  │                    ERROR INGESTION LAYER (EIL)                       │   │
│  │                                                                      │   │
│  │  ┌──────────────┐  ┌──────────────┐  ┌──────────────┐  ┌──────────┐ │   │
│  │  │   Parsers    │→ │ Normalizer   │→ │Deduplicator  │→ │  Router  │ │   │
│  │  │   (plural)   │  │   (schema)   │  │  (fingerprint│  │ (topic)  │ │   │
│  │  └──────────────┘  └──────────────┘  └──────────────┘  └──────────┘ │   │
│  └─────────────────────────────────────────────────────────────────────┘   │
│                                  │                                          │
│                                  ▼                                          │
│  ┌─────────────────────────────────────────────────────────────────────┐   │
│  │                 ANOMALY DETECTION ENGINE (ADE)                       │   │
│  │                                                                      │   │
│  │  ┌─────────────┐  ┌─────────────┐  ┌─────────────┐  ┌─────────────┐ │   │
│  │  │   Pattern   │  │ Statistical │  │  Insanity   │  │   Context   │ │   │
│  │  │   Matcher   │  │   Analyzer  │  │  Detector   │  │   Engine    │ │   │
│  │  │  (known)    │  │  (baseline) │  │ (heuristics)│  │ (history)   │ │   │
│  │  └─────────────┘  └─────────────┘  └─────────────┘  └─────────────┘ │   │
│  │         │                │                │                │        │   │
│  │         └────────────────┴────────────────┴────────────────┘        │   │
│  │                              │                                       │   │
│  │                              ▼                                       │   │
│  │                    ┌───────────────────┐                             │   │
│  │                    │  Anomaly Score    │                             │   │
│  │                    │  (0.0 - 1.0)      │                             │   │
│  │                    └─────────┬─────────┘                             │   │
│  └──────────────────────────────┼──────────────────────────────────────┘   │
│                                 │                                          │
│                                 ▼                                          │
│  ┌─────────────────────────────────────────────────────────────────────┐   │
│  │               HEALING DECISION MATRIX (HDM)                          │   │
│  │                                                                      │   │
│  │  ┌─────────────────────────────────────────────────────────────┐   │   │
│  │  │                    CLASSIFICATION ENGINE                     │   │   │
│  │  │  Error Type × Severity × Frequency × Safety Level → Action   │   │   │
│  │  └─────────────────────────────────────────────────────────────┘   │   │
│  │                              │                                      │   │
│  │           ┌──────────────────┼──────────────────┐                  │   │
│  │           ▼                  ▼                  ▼                  │   │
│  │    ┌────────────┐    ┌────────────┐    ┌────────────┐             │   │
│  │    │ AUTO-HEAL  │    │  GUARDED   │    │  HUMAN     │             │   │
│  │    │  (safe)    │    │  (verify)  │    │  REQUIRED  │             │   │
│  │    └─────┬──────┘    └─────┬──────┘    └─────┬──────┘             │   │
│  │          │                 │                 │                    │   │
│  │          └─────────────────┴─────────────────┘                    │   │
│  │                            │                                       │   │
│  │                            ▼                                       │   │
│  │              ┌─────────────────────────┐                          │   │
│  │              │   Action Queue          │                          │   │
│  │              │   (prioritized)         │                          │   │
│  │              └─────────────────────────┘                          │   │
│  └─────────────────────────────────────────────────────────────────────┘   │
│                                 │                                          │
│                                 ▼                                          │
│  ┌─────────────────────────────────────────────────────────────────────┐   │
│  │              HEALING EXECUTION ENGINE (HEE)                          │   │
│  │                                                                      │   │
│  │  ┌─────────────┐  ┌─────────────┐  ┌─────────────┐  ┌─────────────┐ │   │
│  │  │   Plugin    │  │  P4NTH30N   │  │  Decision   │  │  Circuit    │ │   │
│  │  │  Healer     │  │   Healer    │  │   Healer    │  │  Breaker    │ │   │
│  │  │             │  │             │  │             │  │             │ │   │
│  │  │• Model      │  │• CDP        │  │• Bug report │  │• Failure    │ │   │
│  │  │  fallback   │  │  reconnect  │  │  to Forge   │  │  tracking   │ │   │
│  │  │• Config     │  │• Session    │  │• Decision   │  │• Backoff    │ │   │
│  │  │  repair     │  │  restore    │  │  patch      │  │  logic      │ │   │
│  │  │• Agent      │  │• Chrome     │  │• State      │  │• Quarantine  │ │   │
│  │  │  restart    │  │  respawn    │  │  rollback   │  │             │ │   │
│  │  └─────────────┘  └─────────────┘  └─────────────┘  └─────────────┘ │   │
│  └─────────────────────────────────────────────────────────────────────┘   │
│                                 │                                          │
│                                 ▼                                          │
│  ┌─────────────────────────────────────────────────────────────────────┐   │
│  │                    STATE TRACKING LAYER (STL)                        │   │
│  │                                                                      │   │
│  │  ┌─────────────┐  ┌─────────────┐  ┌─────────────┐  ┌─────────────┐ │   │
│  │  │   Healing   │  │   Success/  │  │   Circuit   │  │   Telemetry │ │   │
│  │  │   History   │  │   Failure   │  │   State     │  │   Export    │ │   │
│  │  │   (MongoDB) │  │   Metrics   │  │   (Redis)   │  │   (logs)    │ │   │
│  │  └─────────────┘  └─────────────┘  └─────────────┘  └─────────────┘ │   │
│  └─────────────────────────────────────────────────────────────────────┘   │
│                                                                              │
└─────────────────────────────────────────────────────────────────────────────┘
```

---

## 3. Component Specifications

### 3.1 Error Ingestion Layer (EIL)

**Purpose**: Ingest, normalize, and route error events from all system sources.

#### 3.1.1 Error Schema (Normalized)

```typescript
interface LazarusError {
  // Identity
  id: string;                    // ULID
  fingerprint: string;           // Hash of key fields for dedup
  
  // Source
  source: ErrorSource;           // P4NTH30N | PLUGIN | EXTERNAL
  component: string;             // e.g., "H4ND", "background-manager"
  instance: string;              // Hostname/process ID
  
  // Content
  type: ErrorType;               // CLASSIFICATION
  severity: ErrorSeverity;       // DEBUG | INFO | WARN | ERROR | CRITICAL
  message: string;
  stackTrace?: string;
  context: ErrorContext;         // Structured context
  
  // Temporal
  timestamp: Date;
  occurredAt: Date;              // Original occurrence
  
  // Lifecycle
  status: ErrorStatus;           // NEW | ACK | HEALING | RESOLVED | ESCALATED
  healingAttempts: number;
  lastHealingAt?: Date;
  
  // Metadata
  tags: string[];
  correlationId?: string;        // Groups related errors
}

interface ErrorContext {
  agentName?: string;
  decisionId?: string;
  taskId?: string;
  sessionId?: string;
  chromePid?: number;
  mongoConnection?: string;
  [key: string]: unknown;
}

enum ErrorType {
  // P4NTH30N Errors
  CDP_DISCONNECT = 'cdp_disconnect',
  SESSION_EXPIRED = 'session_expired',
  CHROME_CRASH = 'chrome_crash',
  MONGO_UNREACHABLE = 'mongo_unreachable',
  AGENT_CRASH = 'agent_crash',
  DECISION_BUG = 'decision_bug',
  
  // Plugin Errors
  MODEL_TIMEOUT = 'model_timeout',
  MODEL_CONTEXT_LENGTH = 'model_context_length',
  TASK_FAILURE = 'task_failure',
  CONFIG_ERROR = 'config_error',
  PERMISSION_DENIED = 'permission_denied',
  
  // Runtime Errors
  MEMORY_EXHAUSTED = 'memory_exhausted',
  DISK_FULL = 'disk_full',
  NETWORK_PARTITION = 'network_partition',
  
  // Insanity Conditions
  IMPOSSIBLE_STATE = 'impossible_state',
  CONTRADICTION = 'contradiction',
  CASCADE_FAILURE = 'cascade_failure',
  
  // Unknown
  UNKNOWN = 'unknown'
}
```

#### 3.1.2 Log Parsers

| Parser | Source | Format | Responsibility |
|--------|--------|--------|----------------|
| `P4nth30nLogParser` | P4NTH30N logs | Structured JSON | Parse C# exception output, CDP events |
| `PluginLogParser` | oh-my-opencode logs | Bun logger format | Parse agent failures, model errors |
| `ChromeLogParser` | Chrome stderr | Text lines | Parse crash reports, devtools errors |
| `MongoLogParser` | MongoDB logs | JSON | Parse connection failures, query timeouts |
| `SystemLogParser` | OS logs | Varies | Parse disk/memory/network errors |

**Parser Interface**:

```typescript
interface ILogParser {
  readonly source: ErrorSource;
  
  canParse(rawLog: unknown): boolean;
  parse(rawLog: unknown): LazarusError | null;
  extractContext(rawLog: unknown): Partial<ErrorContext>;
}

abstract class BaseLogParser implements ILogParser {
  abstract readonly source: ErrorSource;
  abstract canParse(rawLog: unknown): boolean;
  abstract parse(rawLog: unknown): LazarusError | null;
  
  protected generateFingerprint(error: Partial<LazarusError>): string {
    // Hash of: type + component + message pattern (normalized)
    const content = `${error.type}:${error.component}:${this.normalizeMessage(error.message || '')}`;
    return crypto.createHash('sha256').update(content).digest('hex').slice(0, 16);
  }
  
  private normalizeMessage(msg: string): string {
    // Remove variable content (IDs, timestamps, paths)
    return msg
      .replace(/[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}/gi, '<UUID>')
      .replace(/\d{4}-\d{2}-\d{2}[T ]\d{2}:\d{2}:\d{2}/g, '<TIMESTAMP>')
      .replace(/\/[^\s]+\/[^\s]+/g, '<PATH>');
  }
}
```

#### 3.1.3 Deduplication Strategy

```typescript
interface DeduplicationConfig {
  windowMs: number;              // Time window for dedup (default: 60000)
  maxOccurrences: number;        // Max occurrences before escalation
  fingerprintFields: string[];   // Fields to hash for fingerprint
}

class DeduplicationEngine {
  private cache: Map<string, DedupEntry> = new Map();
  
  process(error: LazarusError): DeduplicationResult {
    const existing = this.cache.get(error.fingerprint);
    
    if (existing) {
      // Within window - deduplicate
      if (Date.now() - existing.firstSeen < this.config.windowMs) {
        existing.count++;
        existing.lastSeen = Date.now();
        
        return {
          action: 'DEDUPLICATE',
          masterErrorId: existing.masterErrorId,
          occurrenceCount: existing.count
        };
      }
      
      // Window expired - treat as new but track history
      this.cache.delete(error.fingerprint);
    }
    
    // New error
    this.cache.set(error.fingerprint, {
      masterErrorId: error.id,
      firstSeen: Date.now(),
      lastSeen: Date.now(),
      count: 1
    });
    
    return {
      action: 'NEW',
      masterErrorId: error.id,
      occurrenceCount: 1
    };
  }
}
```

---

### 3.2 Anomaly Detection Engine (ADE)

**Purpose**: Detect abnormal system behavior through multiple detection strategies.

#### 3.2.1 Pattern Matcher

Matches known error signatures against a signature database.

```typescript
interface ErrorSignature {
  id: string;
  name: string;
  type: ErrorType;
  patterns: RegExp[];            // Multiple patterns = OR match
  requiredContext: string[];     // Required context fields
  severity: ErrorSeverity;
  autoHealSafe: boolean;         // Can auto-heal?
  suggestedAction: HealingActionType;
}

class PatternMatcher {
  private signatures: ErrorSignature[] = [];
  
  match(error: LazarusError): PatternMatchResult {
    for (const signature of this.signatures) {
      const matchesPattern = signature.patterns.some(p => 
        p.test(error.message) || p.test(error.stackTrace || '')
      );
      
      const hasRequiredContext = signature.requiredContext.every(field => 
        error.context[field] !== undefined
      );
      
      if (matchesPattern && hasRequiredContext) {
        return {
          matched: true,
          signature,
          confidence: this.calculateConfidence(error, signature)
        };
      }
    }
    
    return { matched: false };
  }
  
  // Pre-defined signatures
  private readonly builtInSignatures: ErrorSignature[] = [
    {
      id: 'SIG-001',
      name: 'CDP Connection Lost',
      type: ErrorType.CDP_DISCONNECT,
      patterns: [
        /WebSocket connection closed/i,
        /Protocol error.*Runtime\.evaluate/i,
        /No node with given id found/i
      ],
      requiredContext: ['chromePid'],
      severity: ErrorSeverity.ERROR,
      autoHealSafe: true,
      suggestedAction: 'CDP_RECONNECT'
    },
    {
      id: 'SIG-002',
      name: 'Model Context Length Exceeded',
      type: ErrorType.MODEL_CONTEXT_LENGTH,
      patterns: [
        /maximum context length/i,
        /context length exceeded/i,
        /too many tokens/i
      ],
      requiredContext: ['agentName'],
      severity: ErrorSeverity.ERROR,
      autoHealSafe: true,
      suggestedAction: 'MODEL_FALLBACK'
    },
    {
      id: 'SIG-003',
      name: 'MongoDB Connection Timeout',
      type: ErrorType.MONGO_UNREACHABLE,
      patterns: [
        /connection.*timeout/i,
        /MongoNetworkError/i,
        /ECONNREFUSED.*27017/i
      ],
      requiredContext: [],
      severity: ErrorSeverity.CRITICAL,
      autoHealSafe: false,
      suggestedAction: 'ESCALATE'
    },
    {
      id: 'SIG-004',
      name: 'Decision Bug Detected',
      type: ErrorType.DECISION_BUG,
      patterns: [
        /DECISION_\d{3}.*implementation error/i,
        /ConsultationLog.*validation failed/i
      ],
      requiredContext: ['decisionId'],
      severity: ErrorSeverity.ERROR,
      autoHealSafe: false,
      suggestedAction: 'REPORT_TO_FORGEWRIGHT'
    }
  ];
}
```

#### 3.2.2 Statistical Anomaly Detector

Detects anomalies based on error rate baselines.

```typescript
interface BaselineConfig {
  windowSize: number;            // Rolling window size in minutes
  sensitivity: number;           // Z-score threshold (default: 2.5)
  minSamples: number;            // Minimum samples before detection
}

class StatisticalAnalyzer {
  private windows: Map<string, RollingWindow> = new Map();
  
  analyze(error: LazarusError): StatisticalResult {
    const key = `${error.component}:${error.type}`;
    let window = this.windows.get(key);
    
    if (!window) {
      window = new RollingWindow(this.config.windowSize);
      this.windows.set(key, window);
    }
    
    window.add(error.timestamp);
    
    if (window.size < this.config.minSamples) {
      return { status: 'INSUFFICIENT_DATA' };
    }
    
    const stats = window.calculateStats();
    const currentRate = window.getCurrentRate();
    const zScore = (currentRate - stats.mean) / stats.stdDev;
    
    if (zScore > this.config.sensitivity) {
      return {
        status: 'ANOMALY_DETECTED',
        zScore,
        currentRate,
        baselineRate: stats.mean,
        severity: this.mapZScoreToSeverity(zScore)
      };
    }
    
    return { status: 'NORMAL', zScore };
  }
  
  private mapZScoreToSeverity(zScore: number): ErrorSeverity {
    if (zScore > 4) return ErrorSeverity.CRITICAL;
    if (zScore > 3) return ErrorSeverity.ERROR;
    return ErrorSeverity.WARN;
  }
}
```

#### 3.2.3 Insanity Detector

Detects "impossible" or contradictory system states.

```typescript
interface InsanityRule {
  id: string;
  description: string;
  check: (errors: LazarusError[], context: SystemContext) => boolean;
  severity: ErrorSeverity;
  category: 'CONTRADICTION' | 'IMPOSSIBLE' | 'CASCADE';
}

class InsanityDetector {
  private rules: InsanityRule[] = [
    {
      id: 'INS-001',
      description: 'Agent reports success while error log shows failure',
      check: (errors, ctx) => {
        const successReport = ctx.recentEvents.find(e => 
          e.type === 'AGENT_SUCCESS' && e.agentName
        );
        const agentError = errors.find(e => 
          e.context.agentName === successReport?.agentName &&
          e.timestamp > successReport.timestamp
        );
        return !!successReport && !!agentError;
      },
      severity: ErrorSeverity.ERROR,
      category: 'CONTRADICTION'
    },
    {
      id: 'INS-002',
      description: 'Healing action reported success but error recurred within 30s',
      check: (errors, ctx) => {
        const healedErrors = errors.filter(e => 
          e.status === 'RESOLVED' && e.lastHealingAt
        );
        return healedErrors.some(e => {
          const recurrence = errors.find(r => 
            r.fingerprint === e.fingerprint &&
            r.timestamp > e.lastHealingAt! &&
            r.timestamp.getTime() - e.lastHealingAt!.getTime() < 30000
          );
          return !!recurrence;
        });
      },
      severity: ErrorSeverity.CRITICAL,
      category: 'CASCADE'
    },
    {
      id: 'INS-003',
      description: 'Multiple different agents fail simultaneously with same root cause',
      check: (errors, ctx) => {
        const recentAgentErrors = errors.filter(e => 
          e.type === ErrorType.AGENT_CRASH &&
          e.timestamp > new Date(Date.now() - 60000)
        );
        const uniqueAgents = new Set(recentAgentErrors.map(e => e.context.agentName));
        return uniqueAgents.size >= 3;
      },
      severity: ErrorSeverity.CRITICAL,
      category: 'CASCADE'
    },
    {
      id: 'INS-004',
      description: 'Error claims Chrome is dead but process still exists',
      check: (errors, ctx) => {
        const chromeDeath = errors.find(e => e.type === ErrorType.CHROME_CRASH);
        const chromePid = chromeDeath?.context.chromePid;
        return chromeDeath !== undefined && 
               chromePid !== undefined && 
               ctx.processes.has(chromePid);
      },
      severity: ErrorSeverity.ERROR,
      category: 'CONTRADICTION'
    }
  ];
  
  detect(errors: LazarusError[], context: SystemContext): InsanityResult[] {
    return this.rules
      .filter(rule => rule.check(errors, context))
      .map(rule => ({
        ruleId: rule.id,
        description: rule.description,
        severity: rule.severity,
        category: rule.category,
        implicatedErrors: this.findImplicatedErrors(errors, rule)
      }));
  }
}
```

#### 3.2.4 Context Engine

Maintains system context for anomaly detection.

```typescript
interface SystemContext {
  recentEvents: SystemEvent[];
  processes: Map<number, ProcessInfo>;
  agentStates: Map<string, AgentState>;
  healingHistory: HealingRecord[];
  decisionStates: Map<string, DecisionState>;
}

class ContextEngine {
  private context: SystemContext;
  private maxEventAge = 300000; // 5 minutes
  
  update(error: LazarusError): void {
    // Add to recent events
    this.context.recentEvents.push({
      type: 'ERROR',
      timestamp: error.timestamp,
      errorId: error.id,
      agentName: error.context.agentName
    });
    
    // Prune old events
    const cutoff = Date.now() - this.maxEventAge;
    this.context.recentEvents = this.context.recentEvents.filter(
      e => e.timestamp.getTime() > cutoff
    );
  }
  
  getRecentErrors(timeWindowMs: number): LazarusError[] {
    const cutoff = Date.now() - timeWindowMs;
    return this.context.recentEvents
      .filter(e => e.type === 'ERROR' && e.timestamp.getTime() > cutoff)
      .map(e => this.getErrorById(e.errorId))
      .filter((e): e is LazarusError => e !== null);
  }
}
```

#### 3.2.5 Anomaly Score Calculation

```typescript
interface AnomalyScore {
  score: number;                 // 0.0 - 1.0
  confidence: number;            // Detector confidence
  factors: AnomalyFactor[];
  recommendedAction: HealingActionType;
}

interface AnomalyFactor {
  source: 'PATTERN' | 'STATISTICAL' | 'INSANITY' | 'CONTEXT';
  weight: number;
  contribution: number;
  details: unknown;
}

class AnomalyScorer {
  calculate(error: LazarusError, context: SystemContext): AnomalyScore {
    const factors: AnomalyFactor[] = [];
    
    // Pattern match contribution (0.0 - 0.4)
    const patternResult = this.patternMatcher.match(error);
    if (patternResult.matched) {
      factors.push({
        source: 'PATTERN',
        weight: 0.4,
        contribution: patternResult.confidence * 0.4,
        details: patternResult.signature
      });
    }
    
    // Statistical contribution (0.0 - 0.3)
    const statsResult = this.statisticalAnalyzer.analyze(error);
    if (statsResult.status === 'ANOMALY_DETECTED') {
      factors.push({
        source: 'STATISTICAL',
        weight: 0.3,
        contribution: Math.min(statsResult.zScore / 5, 1) * 0.3,
        details: statsResult
      });
    }
    
    // Insanity contribution (0.0 - 0.3)
    const recentErrors = this.contextEngine.getRecentErrors(60000);
    const insanityResults = this.insanityDetector.detect(
      [...recentErrors, error], 
      context
    );
    if (insanityResults.length > 0) {
      const maxSeverity = Math.max(...insanityResults.map(i => 
        this.severityToNumber(i.severity)
      ));
      factors.push({
        source: 'INSANITY',
        weight: 0.3,
        contribution: (maxSeverity / 4) * 0.3,
        details: insanityResults
      });
    }
    
    // Calculate total score
    const totalScore = factors.reduce((sum, f) => sum + f.contribution, 0);
    const confidence = this.calculateConfidence(factors);
    
    return {
      score: Math.min(totalScore, 1.0),
      confidence,
      factors,
      recommendedAction: this.determineAction(error, factors)
    };
  }
  
  private determineAction(
    error: LazarusError, 
    factors: AnomalyFactor[]
  ): HealingActionType {
    // Priority: Pattern match suggested action > statistical severity > default
    const patternFactor = factors.find(f => f.source === 'PATTERN');
    if (patternFactor) {
      return (patternFactor.details as ErrorSignature).suggestedAction;
    }
    
    // Fallback to error type mapping
    return this.errorTypeToAction(error.type);
  }
}
```

---

### 3.3 Healing Decision Matrix (HDM)

**Purpose**: Map errors to appropriate healing actions based on safety levels and context.

#### 3.3.1 Safety Levels

```typescript
enum SafetyLevel {
  /**
   * Safe to auto-heal without human approval
   * - Well-understood error patterns
   * - Idempotent healing actions
   * - Low blast radius
   */
  AUTO = 'AUTO',
  
  /**
   * Requires verification before healing
   * - System will queue action and notify
   * - Auto-approves if no human response in timeout
   * - Medium blast radius
   */
  GUARDED = 'GUARDED',
  
  /**
   * Requires explicit human approval
   * - High blast radius or destructive actions
   * - Unknown error patterns
   * - Never auto-approves
   */
  MANUAL = 'MANUAL',
  
  /**
   * System-level emergency
   * - Immediate escalation to human
   * - May involve data loss or corruption risk
   * - Halts related operations
   */
  EMERGENCY = 'EMERGENCY'
}

interface SafetyRule {
  errorType: ErrorType;
  defaultSafety: SafetyLevel;
  overrides: SafetyOverride[];
}

interface SafetyOverride {
  condition: (error: LazarusError, context: SystemContext) => boolean;
  safety: SafetyLevel;
  reason: string;
}
```

#### 3.3.2 Classification Engine

```typescript
interface ClassificationResult {
  error: LazarusError;
  anomalyScore: AnomalyScore;
  safetyLevel: SafetyLevel;
  action: HealingAction;
  escalationPath: EscalationLevel[];
  autoApproveTimeout?: number;   // For GUARDED level
}

class ClassificationEngine {
  private safetyRules: Map<ErrorType, SafetyRule> = new Map([
    [ErrorType.CDP_DISCONNECT, {
      errorType: ErrorType.CDP_DISCONNECT,
      defaultSafety: SafetyLevel.AUTO,
      overrides: [{
        condition: (e, ctx) => ctx.healingHistory.filter(
          h => h.action.type === 'CDP_RECONNECT' && 
               h.timestamp > new Date(Date.now() - 300000)
        ).length > 3,
        safety: SafetyLevel.GUARDED,
        reason: 'Multiple CDP reconnects in 5 minutes'
      }]
    }],
    
    [ErrorType.MODEL_CONTEXT_LENGTH, {
      errorType: ErrorType.MODEL_CONTEXT_LENGTH,
      defaultSafety: SafetyLevel.AUTO,
      overrides: []
    }],
    
    [ErrorType.MONGO_UNREACHABLE, {
      errorType: ErrorType.MONGO_UNREACHABLE,
      defaultSafety: SafetyLevel.MANUAL,
      overrides: []
    }],
    
    [ErrorType.CASCADE_FAILURE, {
      errorType: ErrorType.CASCADE_FAILURE,
      defaultSafety: SafetyLevel.EMERGENCY,
      overrides: []
    }]
  ]);
  
  classify(error: LazarusError, context: SystemContext): ClassificationResult {
    const anomalyScore = this.anomalyScorer.calculate(error, context);
    const rule = this.safetyRules.get(error.type);
    
    // Determine safety level
    let safetyLevel = rule?.defaultSafety || SafetyLevel.GUARDED;
    let overrideReason: string | undefined;
    
    // Check overrides
    if (rule) {
      for (const override of rule.overrides) {
        if (override.condition(error, context)) {
          safetyLevel = override.safety;
          overrideReason = override.reason;
          break;
        }
      }
    }
    
    // High anomaly score can escalate safety
    if (anomalyScore.score > 0.8 && safetyLevel === SafetyLevel.AUTO) {
      safetyLevel = SafetyLevel.GUARDED;
      overrideReason = overrideReason || 'High anomaly score';
    }
    
    // Build action
    const action = this.buildAction(error, anomalyScore, safetyLevel);
    
    // Determine escalation path
    const escalationPath = this.buildEscalationPath(safetyLevel, error);
    
    return {
      error,
      anomalyScore,
      safetyLevel,
      action,
      escalationPath,
      autoApproveTimeout: safetyLevel === SafetyLevel.GUARDED ? 30000 : undefined
    };
  }
  
  private buildAction(
    error: LazarusError, 
    score: AnomalyScore, 
    safety: SafetyLevel
  ): HealingAction {
    return {
      id: `heal-${ulid()}`,
      type: score.recommendedAction,
      target: error,
      safety,
      parameters: this.buildParameters(error, score),
      maxAttempts: this.getMaxAttempts(score.recommendedAction),
      backoffMs: 1000
    };
  }
  
  private buildEscalationPath(
    level: SafetyLevel, 
    error: LazarusError
  ): EscalationLevel[] {
    switch (level) {
      case SafetyLevel.AUTO:
        return ['LOG'];
      case SafetyLevel.GUARDED:
        return ['NOTIFY', 'AUTO_APPROVE', 'ESCALATE'];
      case SafetyLevel.MANUAL:
        return ['NOTIFY', 'AWAIT_APPROVAL', 'ESCALATE'];
      case SafetyLevel.EMERGENCY:
        return ['NOTIFY_ALL', 'HALT_OPERATIONS', 'AWAIT_APPROVAL'];
      default:
        return ['NOTIFY'];
    }
  }
}
```

#### 3.3.3 Action Queue

```typescript
interface ActionQueue {
  enqueue(action: HealingAction): void;
  dequeue(): HealingAction | undefined;
  peek(): HealingAction | undefined;
  remove(actionId: string): boolean;
  getPending(): HealingAction[];
  getByPriority(priority: Priority): HealingAction[];
}

class PrioritizedActionQueue implements ActionQueue {
  private queues: Map<Priority, HealingAction[]> = new Map([
    ['CRITICAL', []],
    ['HIGH', []],
    ['MEDIUM', []],
    ['LOW', []]
  ]);
  
  enqueue(action: HealingAction): void {
    const priority = this.calculatePriority(action);
    const queue = this.queues.get(priority)!;
    
    // Insert maintaining time order within priority
    const index = queue.findIndex(a => a.createdAt > action.createdAt);
    if (index === -1) {
      queue.push(action);
    } else {
      queue.splice(index, 0, action);
    }
  }
  
  private calculatePriority(action: HealingAction): Priority {
    if (action.target.severity === ErrorSeverity.CRITICAL) return 'CRITICAL';
    if (action.safety === SafetyLevel.EMERGENCY) return 'CRITICAL';
    if (action.target.severity === ErrorSeverity.ERROR) return 'HIGH';
    if (action.safety === SafetyLevel.MANUAL) return 'HIGH';
    if (action.target.severity === ErrorSeverity.WARN) return 'MEDIUM';
    return 'LOW';
  }
  
  dequeue(): HealingAction | undefined {
    for (const priority of ['CRITICAL', 'HIGH', 'MEDIUM', 'LOW'] as Priority[]) {
      const queue = this.queues.get(priority)!;
      if (queue.length > 0) {
        return queue.shift();
      }
    }
    return undefined;
  }
  
  getPending(): HealingAction[] {
    return [...this.queues.values()].flat();
  }
}
```

---

### 3.4 Healing Execution Engine (HEE)

**Purpose**: Execute healing actions with circuit breakers, retries, and rollback capability.

#### 3.4.1 Healing Actions

```typescript
interface HealingAction {
  id: string;
  type: HealingActionType;
  target: LazarusError;
  safety: SafetyLevel;
  parameters: Record<string, unknown>;
  maxAttempts: number;
  backoffMs: number;
  createdAt: Date;
  status?: 'PENDING' | 'RUNNING' | 'COMPLETED' | 'FAILED';
}

type HealingActionType = 
  // Plugin healing
  | 'MODEL_FALLBACK'
  | 'AGENT_RESTART'
  | 'CONFIG_REPAIR'
  | 'TASK_RETRY'
  | 'COMPACT_SESSION'
  
  // P4NTH30N healing
  | 'CDP_RECONNECT'
  | 'CHROME_RESPAWN'
  | 'SESSION_RESTORE'
  | 'MONGO_RECONNECT'
  | 'AGENT_RELOAD'
  
  // Decision healing
  | 'REPORT_TO_FORGEWRIGHT'
  | 'DECISION_ROLLBACK'
  | 'PATCH_DECISION'
  
  // System healing
  | 'RESTART_SERVICE'
  | 'CLEAR_CACHE'
  | 'ESCALATE'
  | 'HALT';
```

#### 3.4.2 Plugin Healer

```typescript
class PluginHealer {
  constructor(
    private backgroundManager: BackgroundManager,
    private configLoader: ConfigLoader
  ) {}
  
  async execute(action: HealingAction): Promise<HealingResult> {
    switch (action.type) {
      case 'MODEL_FALLBACK':
        return this.handleModelFallback(action);
      
      case 'AGENT_RESTART':
        return this.handleAgentRestart(action);
      
      case 'CONFIG_REPAIR':
        return this.handleConfigRepair(action);
      
      case 'COMPACT_SESSION':
        return this.handleSessionCompaction(action);
      
      case 'TASK_RETRY':
        return this.handleTaskRetry(action);
      
      default:
        return {
          success: false,
          error: `Unknown plugin action: ${action.type}`
        };
    }
  }
  
  private async handleModelFallback(action: HealingAction): Promise<HealingResult> {
    const agentName = action.target.context.agentName;
    if (!agentName) {
      return { success: false, error: 'Missing agent name in context' };
    }
    
    try {
      // Get fallback chain for agent
      const config = await this.configLoader.loadAgentConfig(agentName);
      const currentModel = config.currentModel;
      const chain = config.models || [];
      
      // Find next model in chain
      const currentIndex = chain.indexOf(currentModel);
      const nextModel = chain[currentIndex + 1];
      
      if (!nextModel) {
        return { 
          success: false, 
          error: 'No fallback model available in chain',
          escalate: true 
        };
      }
      
      // Update current model
      await this.configLoader.updateAgentModel(agentName, nextModel);
      
      return {
        success: true,
        message: `Fell back from ${currentModel} to ${nextModel}`,
        metadata: { previousModel: currentModel, newModel: nextModel }
      };
    } catch (error) {
      return {
        success: false,
        error: `Model fallback failed: ${error}`
      };
    }
  }
  
  private async handleSessionCompaction(action: HealingAction): Promise<HealingResult> {
    const taskId = action.target.context.taskId;
    if (!taskId) {
      return { success: false, error: 'Missing task ID in context' };
    }
    
    try {
      // Invoke compact command on background task
      await this.backgroundManager.compactSession(taskId);
      
      return {
        success: true,
        message: `Session ${taskId} compacted`
      };
    } catch (error) {
      return {
        success: false,
        error: `Session compaction failed: ${error}`
      };
    }
  }
}
```

#### 3.4.3 P4NTH30N Healer

```typescript
class P4nth30nHealer {
  constructor(
    private cdpManager: CDPManager,
    private sessionManager: SessionManager,
    private mongoClient: MongoClient
  ) {}
  
  async execute(action: HealingAction): Promise<HealingResult> {
    switch (action.type) {
      case 'CDP_RECONNECT':
        return this.handleCDPReconnect(action);
      
      case 'CHROME_RESPAWN':
        return this.handleChromeRespawn(action);
      
      case 'SESSION_RESTORE':
        return this.handleSessionRestore(action);
      
      case 'MONGO_RECONNECT':
        return this.handleMongoReconnect(action);
      
      default:
        return {
          success: false,
          error: `Unknown P4NTH30N action: ${action.type}`
        };
    }
  }
  
  private async handleCDPReconnect(action: HealingAction): Promise<HealingResult> {
    const chromePid = action.target.context.chromePid;
    
    try {
      // Check if Chrome process still exists
      if (chromePid && !await this.processExists(chromePid)) {
        // Chrome is dead - respawn instead
        return this.handleChromeRespawn(action);
      }
      
      // Attempt CDP reconnection
      const result = await this.cdpManager.reconnect({
        timeout: 30000,
        retries: 3
      });
      
      if (result.connected) {
        return {
          success: true,
          message: 'CDP reconnected successfully',
          metadata: { wsEndpoint: result.wsEndpoint }
        };
      } else {
        return {
          success: false,
          error: 'CDP reconnection failed after retries',
          escalate: true
        };
      }
    } catch (error) {
      return {
        success: false,
        error: `CDP reconnect error: ${error}`
      };
    }
  }
  
  private async handleChromeRespawn(action: HealingAction): Promise<HealingResult> {
    try {
      // Kill any orphaned Chrome processes
      await this.cdpManager.killOrphanedProcesses();
      
      // Spawn new Chrome instance
      const newChrome = await this.cdpManager.spawn({
        headless: false,
        userDataDir: this.getUserDataDir()
      });
      
      // Restore session state if available
      const sessionId = action.target.context.sessionId;
      if (sessionId) {
        await this.sessionManager.restore(sessionId, newChrome);
      }
      
      return {
        success: true,
        message: 'Chrome respawned successfully',
        metadata: { 
          newPid: newChrome.pid,
          wsEndpoint: newChrome.wsEndpoint,
          sessionRestored: !!sessionId
        }
      };
    } catch (error) {
      return {
        success: false,
        error: `Chrome respawn failed: ${error}`,
        escalate: true
      };
    }
  }
  
  private async processExists(pid: number): Promise<boolean> {
    try {
      process.kill(pid, 0);
      return true;
    } catch {
      return false;
    }
  }
}
```

#### 3.4.4 Decision Healer

```typescript
class DecisionHealer {
  constructor(
    private forgewrightNotifier: ForgewrightNotifier,
    private decisionStore: DecisionStore
  ) {}
  
  async execute(action: HealingAction): Promise<HealingResult> {
    switch (action.type) {
      case 'REPORT_TO_FORGEWRIGHT':
        return this.handleBugReport(action);
      
      case 'DECISION_ROLLBACK':
        return this.handleDecisionRollback(action);
      
      default:
        return {
          success: false,
          error: `Unknown decision action: ${action.type}`
        };
    }
  }
  
  private async handleBugReport(action: HealingAction): Promise<HealingResult> {
    const decisionId = action.target.context.decisionId;
    
    if (!decisionId) {
      return { 
        success: false, 
        error: 'Missing decision ID in context' 
      };
    }
    
    try {
      // Gather bug context
      const bugReport: BugReport = {
        decisionId,
        errorId: action.target.id,
        errorType: action.target.type,
        errorMessage: action.target.message,
        stackTrace: action.target.stackTrace,
        context: action.target.context,
        timestamp: new Date(),
        reportedBy: 'lazarus-protocol'
      };
      
      // Send to Forgewright
      const result = await this.forgewrightNotifier.notify(bugReport);
      
      if (result.accepted) {
        return {
          success: true,
          message: `Bug reported to Forgewright: ${result.ticketId}`,
          metadata: { ticketId: result.ticketId }
        };
      } else {
        return {
          success: false,
          error: `Forgewright rejected bug report: ${result.reason}`
        };
      }
    } catch (error) {
      return {
        success: false,
        error: `Bug report failed: ${error}`
      };
    }
  }
}
```

#### 3.4.5 Circuit Breaker

```typescript
interface CircuitBreakerConfig {
  failureThreshold: number;      // Failures before opening
  resetTimeoutMs: number;        // Time before attempting reset
  halfOpenMaxCalls: number;      // Max calls in half-open state
}

enum CircuitState {
  CLOSED = 'CLOSED',           // Normal operation
  OPEN = 'OPEN',              // Failing, reject calls
  HALF_OPEN = 'HALF_OPEN'     // Testing if recovered
}

class HealingCircuitBreaker {
  private state: CircuitState = CircuitState.CLOSED;
  private failures: number = 0;
  private lastFailureTime?: number;
  private halfOpenCalls: number = 0;
  
  constructor(
    private name: string,
    private config: CircuitBreakerConfig
  ) {}
  
  async execute<T>(
    fn: () => Promise<T>,
    onStateChange?: (state: CircuitState) => void
  ): Promise<T> {
    if (this.state === CircuitState.OPEN) {
      if (this.shouldAttemptReset()) {
        this.transitionTo(CircuitState.HALF_OPEN, onStateChange);
      } else {
        throw new CircuitBreakerOpenError(
          `Circuit breaker '${this.name}' is OPEN`
        );
      }
    }
    
    if (this.state === CircuitState.HALF_OPEN && 
        this.halfOpenCalls >= this.config.halfOpenMaxCalls) {
      throw new CircuitBreakerOpenError(
        `Circuit breaker '${this.name}' HALF_OPEN limit reached`
      );
    }
    
    if (this.state === CircuitState.HALF_OPEN) {
      this.halfOpenCalls++;
    }
    
    try {
      const result = await fn();
      this.onSuccess();
      return result;
    } catch (error) {
      this.onFailure();
      throw error;
    }
  }
  
  private onSuccess(): void {
    if (this.state === CircuitState.HALF_OPEN) {
      this.transitionTo(CircuitState.CLOSED);
    }
    this.failures = 0;
    this.halfOpenCalls = 0;
  }
  
  private onFailure(): void {
    this.failures++;
    this.lastFailureTime = Date.now();
    
    if (this.failures >= this.config.failureThreshold) {
      this.transitionTo(CircuitState.OPEN);
    }
  }
  
  private shouldAttemptReset(): boolean {
    return !!this.lastFailureTime && 
           Date.now() - this.lastFailureTime >= this.config.resetTimeoutMs;
  }
  
  private transitionTo(
    newState: CircuitState, 
    callback?: (state: CircuitState) => void
  ): void {
    const oldState = this.state;
    this.state = newState;
    
    if (newState === CircuitState.CLOSED) {
      this.failures = 0;
      this.halfOpenCalls = 0;
    }
    
    if (callback) {
      callback(newState);
    }
  }
  
  getState(): CircuitState {
    return this.state;
  }
  
  getMetrics(): CircuitBreakerMetrics {
    return {
      state: this.state,
      failures: this.failures,
      lastFailureTime: this.lastFailureTime,
      halfOpenCalls: this.halfOpenCalls
    };
  }
}

// Circuit breaker registry
class CircuitBreakerRegistry {
  private breakers: Map<string, HealingCircuitBreaker> = new Map();
  
  get(name: string, config?: CircuitBreakerConfig): HealingCircuitBreaker {
    if (!this.breakers.has(name)) {
      this.breakers.set(
        name, 
        new HealingCircuitBreaker(name, config || this.defaultConfig())
      );
    }
    return this.breakers.get(name)!;
  }
  
  getAllMetrics(): Map<string, CircuitBreakerMetrics> {
    const metrics = new Map();
    for (const [name, breaker] of this.breakers) {
      metrics.set(name, breaker.getMetrics());
    }
    return metrics;
  }
  
  private defaultConfig(): CircuitBreakerConfig {
    return {
      failureThreshold: 5,
      resetTimeoutMs: 60000,
      halfOpenMaxCalls: 3
    };
  }
}
```

---

### 3.5 State Tracking Layer (STL)

**Purpose**: Persist healing history, track success rates, and maintain circuit breaker state.

#### 3.5.1 Healing History Store

```typescript
interface HealingRecord {
  id: string;
  actionId: string;
  errorId: string;
  actionType: HealingActionType;
  startedAt: Date;
  completedAt?: Date;
  status: 'SUCCESS' | 'FAILED' | 'IN_PROGRESS';
  result?: HealingResult;
  attemptNumber: number;
  executor: string;              // Component that executed
}

interface HealingHistory {
  records: HealingRecord[];
  successRate: number;
  averageDuration: number;
  mostEffectiveActions: HealingActionType[];
}

class HealingHistoryStore {
  constructor(private mongo: MongoClient) {}
  
  async recordStart(action: HealingAction): Promise<void> {
    const record: HealingRecord = {
      id: ulid(),
      actionId: action.id,
      errorId: action.target.id,
      actionType: action.type,
      startedAt: new Date(),
      status: 'IN_PROGRESS',
      attemptNumber: action.target.healingAttempts + 1,
      executor: this.determineExecutor(action.type)
    };
    
    await this.collection.insertOne(record);
  }
  
  async recordComplete(
    actionId: string, 
    result: HealingResult
  ): Promise<void> {
    await this.collection.updateOne(
      { actionId },
      {
        $set: {
          completedAt: new Date(),
          status: result.success ? 'SUCCESS' : 'FAILED',
          result
        }
      }
    );
  }
  
  async getHistory(
    filters: HistoryFilters,
    limit: number = 100
  ): Promise<HealingRecord[]> {
    return this.collection
      .find(filters)
      .sort({ startedAt: -1 })
      .limit(limit)
      .toArray();
  }
  
  async getSuccessRate(
    actionType?: HealingActionType,
    timeWindowHours: number = 24
  ): Promise<number> {
    const cutoff = new Date(Date.now() - timeWindowHours * 3600000);
    const match: Record<string, unknown> = { startedAt: { $gte: cutoff } };
    
    if (actionType) {
      match.actionType = actionType;
    }
    
    const stats = await this.collection.aggregate([
      { $match: match },
      {
        $group: {
          _id: null,
          total: { $sum: 1 },
          successes: {
            $sum: { $cond: [{ $eq: ['$status', 'SUCCESS'] }, 1, 0] }
          }
        }
      }
    ]).toArray();
    
    if (stats.length === 0) return 0;
    return stats[0].successes / stats[0].total;
  }
  
  async getMostEffectiveActions(
    minAttempts: number = 5,
    limit: number = 10
  ): Promise<Array<{ action: HealingActionType; successRate: number }>> {
    return this.collection.aggregate([
      {
        $group: {
          _id: '$actionType',
          total: { $sum: 1 },
          successes: {
            $sum: { $cond: [{ $eq: ['$status', 'SUCCESS'] }, 1, 0] }
          }
        }
      },
      { $match: { total: { $gte: minAttempts } } },
      {
        $project: {
          action: '$_id',
          successRate: { $divide: ['$successes', '$total'] }
        }
      },
      { $sort: { successRate: -1 } },
      { $limit: limit }
    ]).toArray();
  }
  
  private get collection() {
    return this.mongo.db('lazarus').collection<HealingRecord>('healing_history');
  }
  
  private determineExecutor(actionType: HealingActionType): string {
    if (['MODEL_FALLBACK', 'AGENT_RESTART', 'CONFIG_REPAIR'].includes(actionType)) {
      return 'PluginHealer';
    }
    if (['CDP_RECONNECT', 'CHROME_RESPAWN', 'SESSION_RESTORE'].includes(actionType)) {
      return 'P4nth30nHealer';
    }
    if (['REPORT_TO_FORGEWRIGHT', 'DECISION_ROLLBACK'].includes(actionType)) {
      return 'DecisionHealer';
    }
    return 'Unknown';
  }
}
```

#### 3.5.2 Circuit Breaker State Store

```typescript
interface CircuitBreakerState {
  name: string;
  state: CircuitState;
  failures: number;
  lastFailureTime?: Date;
  halfOpenCalls: number;
  updatedAt: Date;
}

class CircuitBreakerStateStore {
  constructor(private redis: RedisClient) {}
  
  async saveState(state: CircuitBreakerState): Promise<void> {
    await this.redis.setex(
      `circuit:${state.name}`,
      3600, // 1 hour TTL
      JSON.stringify({
        ...state,
        updatedAt: new Date().toISOString()
      })
    );
  }
  
  async loadState(name: string): Promise<CircuitBreakerState | null> {
    const data = await this.redis.get(`circuit:${name}`);
    if (!data) return null;
    return JSON.parse(data);
  }
  
  async getAllStates(): Promise<CircuitBreakerState[]> {
    const keys = await this.redis.keys('circuit:*');
    if (keys.length === 0) return [];
    
    const values = await this.redis.mget(...keys);
    return values
      .filter((v): v is string => v !== null)
      .map(v => JSON.parse(v));
  }
  
  async recordFailure(name: string): Promise<void> {
    const key = `circuit:${name}:failures`;
    await this.redis.incr(key);
    await this.redis.expire(key, 3600);
  }
  
  async getFailureCount(name: string, windowMinutes: number = 60): Promise<number> {
    const count = await this.redis.get(`circuit:${name}:failures`);
    return parseInt(count || '0', 10);
  }
}
```

---

## 4. File Structure

```
P4NTH30N/
├── LAZARUS/                              # Lazarus Protocol root
│   ├── README.md                         # System overview
│   ├── ARCHITECTURE.md                   # This document
│   ├── CONFIG.md                         # Configuration reference
│   │
│   ├── src/
│   │   ├── index.ts                      # Main entry point
│   │   ├── lazarus-core.ts               # Core orchestrator
│   │   │
│   │   ├── ingestion/                    # Error Ingestion Layer
│   │   │   ├── index.ts
│   │   │   ├── error-schema.ts           # Core error types
│   │   │   ├── parsers/
│   │   │   │   ├── base-parser.ts
│   │   │   │   ├── p4nth30n-parser.ts
│   │   │   │   ├── plugin-parser.ts
│   │   │   │   ├── chrome-parser.ts
│   │   │   │   ├── mongo-parser.ts
│   │   │   │   └── system-parser.ts
│   │   │   ├── normalizer.ts
│   │   │   ├── deduplicator.ts
│   │   │   └── router.ts
│   │   │
│   │   ├── detection/                    # Anomaly Detection Engine
│   │   │   ├── index.ts
│   │   │   ├── anomaly-scorer.ts
│   │   │   ├── pattern-matcher.ts
│   │   │   ├── signatures/               # Error signature definitions
│   │   │   │   ├── cdp-signatures.ts
│   │   │   │   ├── model-signatures.ts
│   │   │   │   ├── mongo-signatures.ts
│   │   │   │   └── p4nth30n-signatures.ts
│   │   │   ├── statistical-analyzer.ts
│   │   │   ├── insanity-detector.ts
│   │   │   ├── context-engine.ts
│   │   │   └── baselines/                # Statistical baselines
│   │   │       └── default-baselines.ts
│   │   │
│   │   ├── decision/                     # Healing Decision Matrix
│   │   │   ├── index.ts
│   │   │   ├── classification-engine.ts
│   │   │   ├── safety-rules.ts           # Safety level definitions
│   │   │   ├── action-queue.ts
│   │   │   └── escalation.ts
│   │   │
│   │   ├── healing/                      # Healing Execution Engine
│   │   │   ├── index.ts
│   │   │   ├── healing-executor.ts
│   │   │   ├── healers/
│   │   │   │   ├── plugin-healer.ts
│   │   │   │   ├── p4nth30n-healer.ts
│   │   │   │   └── decision-healer.ts
│   │   │   ├── circuit-breaker.ts
│   │   │   └── rollback.ts               # Rollback capability
│   │   │
│   │   ├── state/                        # State Tracking Layer
│   │   │   ├── index.ts
│   │   │   ├── history-store.ts
│   │   │   ├── metrics-collector.ts
│   │   │   └── circuit-state-store.ts
│   │   │
│   │   ├── integrations/                 # External integrations
│   │   │   ├── p4nth30n-adapter.ts       # P4NTH30N integration
│   │   │   ├── plugin-adapter.ts         # oh-my-opencode integration
│   │   │   ├── forgewright-client.ts     # Bug reporting
│   │   │   └── notifications.ts          # Human notification
│   │   │
│   │   ├── types/
│   │   │   ├── errors.ts
│   │   │   ├── healing.ts
│   │   │   └── state.ts
│   │   │
│   │   └── utils/
│   │       ├── logger.ts
│   │       ├── ulid.ts
│   │       └── validation.ts
│   │
│   ├── config/
│   │   ├── default.yaml                  # Default configuration
│   │   ├── signatures.yaml               # Error signatures
│   │   └── safety-rules.yaml             # Safety rule definitions
│   │
│   ├── tests/
│   │   ├── unit/
│   │   │   ├── ingestion/
│   │   │   ├── detection/
│   │   │   ├── decision/
│   │   │   └── healing/
│   │   ├── integration/
│   │   │   ├── p4nth30n-integration.test.ts
│   │   │   └── plugin-integration.test.ts
│   │   └── fixtures/
│   │       ├── errors/
│   │       └── signatures/
│   │
│   └── scripts/
│       ├── setup-lazarus.ts              # Initial setup
│       ├── migrate-signatures.ts         # Signature migration
│       └── generate-report.ts            # Health report generation
│
├── H4ND/                                 # Integration with P4NTH30N
│   └── tools/
│       └── lazarus-bridge/               # C# → TypeScript bridge
│           ├── LazarusBridge.cs
│           └── ErrorForwarder.cs
│
└── oh-my-opencode-theseus/               # Plugin integration
    └── src/
        └── lazarus/                      # Plugin-side components
            ├── hooks/
            │   └── error-capture.ts      # Hook into plugin error flow
            ├── adapters/
            │   └── lazarus-adapter.ts
            └── config/
                └── lazarus-config.ts
```

---

## 5. Integration Points

### 5.1 P4NTH30N Integration

```typescript
// H4ND/tools/lazarus-bridge/LazarusBridge.cs
public class LazarusBridge : IDisposable
{
    private readonly HttpClient _httpClient;
    private readonly string _lazarusEndpoint;
    
    public LazarusBridge(string endpoint = "http://localhost:7734")
    {
        _httpClient = new HttpClient();
        _lazarusEndpoint = endpoint;
    }
    
    public async Task ForwardErrorAsync(P4nth30nError error)
    {
        var lazarusError = new LazarusError
        {
            Source = "P4NTH30N",
            Component = error.Component,
            Type = MapErrorType(error.Type),
            Severity = MapSeverity(error.Severity),
            Message = error.Message,
            StackTrace = error.StackTrace,
            Context = new Dictionary<string, object>
            {
                ["chromePid"] = error.ChromePid,
                ["sessionId"] = error.SessionId,
                ["decisionId"] = error.DecisionId,
                ["agentName"] = error.AgentName
            },
            Timestamp = DateTime.UtcNow
        };
        
        var response = await _httpClient.PostAsJsonAsync(
            $"{_lazarusEndpoint}/ingest",
            lazarusError
        );
        
        response.EnsureSuccessStatusCode();
    }
    
    public async Task<HealingResult> RequestHealingAsync(
        string errorId, 
        HealingActionType action)
    {
        var request = new HealingRequest
        {
            ErrorId = errorId,
            Action = action
        };
        
        var response = await _httpClient.PostAsJsonAsync(
            $"{_lazarusEndpoint}/heal",
            request
        );
        
        return await response.Content.ReadFromJsonAsync<HealingResult>();
    }
    
    private ErrorType MapErrorType(P4nth30nErrorType type) => type switch
    {
        P4nth30nErrorType.CDPDisconnect => ErrorType.CDP_DISCONNECT,
        P4nth30nErrorType.SessionExpired => ErrorType.SESSION_EXPIRED,
        P4nth30nErrorType.ChromeCrash => ErrorType.CHROME_CRASH,
        P4nth30nErrorType.MongoUnreachable => ErrorType.MONGO_UNREACHABLE,
        _ => ErrorType.UNKNOWN
    };
}
```

### 5.2 oh-my-opencode-theseus Integration

```typescript
// oh-my-opencode-theseus/src/lazarus/hooks/error-capture.ts
import { LazarusClient } from '../adapters/lazarus-adapter';

export class ErrorCaptureHook {
  private lazarus: LazarusClient;
  
  constructor() {
    this.lazarus = new LazarusClient();
    this.installHooks();
  }
  
  private installHooks(): void {
    // Hook into background task errors
    const originalHandleError = BackgroundManager.prototype.handleTaskError;
    BackgroundManager.prototype.handleTaskError = async function(
      taskId: string,
      error: Error
    ) {
      await this.captureForLazarus(taskId, error);
      return originalHandleError.call(this, taskId, error);
    };
    
    // Hook into model failures
    const originalHandleModelFailure = BackgroundManager.prototype.retryWithNextModel;
    BackgroundManager.prototype.retryWithNextModel = async function(
      agent: AgentName,
      error: Error
    ) {
      await this.captureModelFailure(agent, error);
      return originalHandleModelFailure.call(this, agent, error);
    };
  }
  
  private async captureForLazarus(taskId: string, error: Error): Promise<void> {
    await this.lazarus.ingest({
      source: 'PLUGIN',
      component: 'background-manager',
      type: this.classifyError(error),
      severity: 'ERROR',
      message: error.message,
      stackTrace: error.stack,
      context: {
        taskId,
        agentName: this.getAgentForTask(taskId)
      }
    });
  }
  
  private classifyError(error: Error): ErrorType {
    if (error.message.includes('context length')) {
      return ErrorType.MODEL_CONTEXT_LENGTH;
    }
    if (error.message.includes('timeout')) {
      return ErrorType.MODEL_TIMEOUT;
    }
    if (error.message.includes('permission')) {
      return ErrorType.PERMISSION_DENIED;
    }
    return ErrorType.UNKNOWN;
  }
}
```

### 5.3 Forgewright Integration

```typescript
// LAZARUS/src/integrations/forgewright-client.ts
export class ForgewrightClient {
  private decisionPath: string;
  
  constructor(decisionPath: string = 'C:/P4NTH30N/STR4TEG15T/decisions') {
    this.decisionPath = decisionPath;
  }
  
  async notify(bugReport: BugReport): Promise<ForgewrightResponse> {
    // Create a bug-fix decision file
    const decisionId = `BUGFIX_${bugReport.decisionId}_${Date.now()}`;
    const decisionPath = path.join(
      this.decisionPath,
      'bugfixes',
      `${decisionId}.md`
    );
    
    const decisionContent = this.generateDecision(bugReport, decisionId);
    
    await fs.mkdir(path.dirname(decisionPath), { recursive: true });
    await fs.writeFile(decisionPath, decisionContent, 'utf-8');
    
    // Notify via configured channels
    await this.sendNotification(bugReport, decisionId);
    
    return {
      accepted: true,
      ticketId: decisionId,
      decisionPath
    };
  }
  
  private generateDecision(bugReport: BugReport, decisionId: string): string {
    return `# ${decisionId}

## Bug Report (Auto-Generated by Lazarus)

**Original Decision**: ${bugReport.decisionId}  
**Error Type**: ${bugReport.errorType}  
**Detected At**: ${bugReport.timestamp.toISOString()}  
**Lazarus Error ID**: ${bugReport.errorId}

### Error Details

\`\`\`
${bugReport.errorMessage}
\`\`\`

${bugReport.stackTrace ? `### Stack Trace\n\n\`\`\`\n${bugReport.stackTrace}\n\`\`\`\n` : ''}

### Context

\`\`\`json
${JSON.stringify(bugReport.context, null, 2)}
\`\`\`

### Healing Attempts

- [ ] Error analyzed by Forgewright
- [ ] Root cause identified
- [ ] Fix implemented
- [ ] Fix tested
- [ ] Fix deployed

### Notes

_Add analysis and fix details here._

---
*This decision was automatically created by the Lazarus Protocol self-healing system.*
`;
  }
}
```

---

## 6. Operational Scenarios

### 6.1 Scenario: CDP Disconnection

```
1. P4NTH30N detects CDP disconnection
2. C# ErrorForwarder captures error
3. HTTP POST to Lazarus /ingest
4. P4nth30nLogParser normalizes error
5. PatternMatcher identifies SIG-001 (CDP Connection Lost)
6. AnomalyScorer calculates score: 0.3 (known pattern)
7. ClassificationEngine assigns AUTO safety level
8. ActionQueue receives CDP_RECONNECT action
9. P4nth30nHealer.execute() called
10. Circuit breaker check: CLOSED
11. CDP reconnect attempted
12. Success: record in HealingHistory
13. Error status updated to RESOLVED
```

### 6.2 Scenario: Model Context Length

```
1. oh-my-opencode plugin hits context length limit
2. ErrorCaptureHook intercepts error
3. LazarusClient.ingest() called
4. PluginLogParser normalizes error
5. PatternMatcher identifies SIG-002 (Model Context Length)
6. ClassificationEngine assigns AUTO safety level
7. ActionQueue receives MODEL_FALLBACK action
8. PluginHealer.execute() called
9. Fallback chain consulted
10. Next model in chain activated
11. Session compacted if needed
12. Task retried with new model
13. Metrics updated
```

### 6.3 Scenario: Cascade Failure (Insanity)

```
1. Multiple agents fail within 60 seconds
2. Errors ingested from multiple sources
3. ContextEngine detects pattern
4. InsanityDetector triggers INS-003 rule
5. AnomalyScorer calculates score: 0.95 (CRITICAL)
6. ClassificationEngine assigns EMERGENCY safety level
7. Escalation path: NOTIFY_ALL → HALT_OPERATIONS
8. All non-critical operations paused
9. Human notification sent
10. Circuit breakers opened for affected components
11. Await human decision
```

---

## 7. Configuration

### 7.1 Default Configuration

```yaml
# config/default.yaml
lazarus:
  server:
    port: 7734
    host: localhost
    
  ingestion:
    deduplicationWindow: 60000  # 1 minute
    maxErrorSize: 1048576       # 1MB
    
  detection:
    baselineWindow: 60          # 60 minutes
    sensitivity: 2.5            # Z-score threshold
    insanityCheckInterval: 5000 # 5 seconds
    
  decision:
    autoApproveTimeout: 30000   # 30 seconds for GUARDED
    maxQueueSize: 1000
    
  healing:
    maxRetries: 3
    backoffMultiplier: 2
    maxBackoffMs: 60000
    
  circuitBreaker:
    failureThreshold: 5
    resetTimeoutMs: 60000
    halfOpenMaxCalls: 3
    
  storage:
    mongodb:
      uri: mongodb://localhost:27017
      database: lazarus
    redis:
      host: localhost
      port: 6379
      
  notifications:
    enabled: true
    channels:
      - type: log
        level: info
      - type: webhook
        url: ${LAZARUS_WEBHOOK_URL}
        events: [emergency, manual_required]
```

### 7.2 Safety Rules Configuration

```yaml
# config/safety-rules.yaml
safetyRules:
  CDP_DISCONNECT:
    default: AUTO
    overrides:
      - condition: recentAttempts > 3
        safety: GUARDED
        reason: Multiple CDP reconnects detected
        
  MONGO_UNREACHABLE:
    default: MANUAL
    
  CASCADE_FAILURE:
    default: EMERGENCY
    
  MODEL_CONTEXT_LENGTH:
    default: AUTO
    
  AGENT_CRASH:
    default: GUARDED
    overrides:
      - condition: sameAgentCrashes > 2
        safety: MANUAL
        reason: Agent repeatedly crashing
```

---

## 8. Safety Mechanisms

### 8.1 Circuit Breaker Protection

Every healing action type has a circuit breaker. If healing fails repeatedly:

1. Circuit opens after 5 failures
2. No healing attempted for 60 seconds
3. After timeout, circuit enters HALF_OPEN
4. Limited test calls allowed
5. Success closes circuit, failure reopens

### 8.2 Rollback Capability

```typescript
interface RollbackableAction {
  execute(): Promise<HealingResult>;
  rollback(): Promise<void>;
  getSnapshot(): SystemSnapshot;
}

class HealingWithRollback implements RollbackableAction {
  private snapshot: SystemSnapshot;
  
  async execute(): Promise<HealingResult> {
    // Take snapshot before healing
    this.snapshot = await this.captureSnapshot();
    
    try {
      const result = await this.performHealing();
      
      if (!result.success && result.escalate) {
        // Automatic rollback on critical failure
        await this.rollback();
      }
      
      return result;
    } catch (error) {
      await this.rollback();
      throw error;
    }
  }
  
  async rollback(): Promise<void> {
    if (!this.snapshot) {
      throw new Error('No snapshot to rollback to');
    }
    
    // Restore previous state
    await this.restoreSnapshot(this.snapshot);
  }
}
```

### 8.3 Human Override

All GUARDED and MANUAL actions can be:
- **Approved**: Execute immediately
- **Rejected**: Cancel and escalate
- **Modified**: Change parameters before execution
- **Delayed**: Schedule for later

---

## 9. Monitoring & Observability

### 9.1 Metrics

| Metric | Type | Description |
|--------|------|-------------|
| `lazarus_errors_ingested_total` | Counter | Total errors ingested |
| `lazarus_errors_by_type` | Counter | Errors by type |
| `lazarus_healing_attempts_total` | Counter | Total healing attempts |
| `lazarus_healing_success_rate` | Gauge | Success rate (0-1) |
| `lazarus_healing_duration_ms` | Histogram | Healing execution time |
| `lazarus_circuit_breaker_state` | Gauge | Circuit breaker state (0=closed, 1=open, 2=half_open) |
| `lazarus_queue_size` | Gauge | Pending healing actions |
| `lazarus_anomaly_score` | Histogram | Distribution of anomaly scores |

### 9.2 Health Endpoint

```typescript
// GET /health
{
  "status": "healthy",
  "components": {
    "ingestion": "healthy",
    "detection": "healthy",
    "decision": "healthy",
    "healing": "degraded",
    "storage": "healthy"
  },
  "circuitBreakers": {
    "CDP_RECONNECT": "CLOSED",
    "MODEL_FALLBACK": "CLOSED",
    "CHROME_RESPAWN": "OPEN"
  },
  "stats": {
    "errorsIngested": 1523,
    "healingSuccessRate": 0.87,
    "pendingActions": 3
  }
}
```

---

## 10. Implementation Phases

### Phase 1: Foundation (Week 1-2)
- [ ] Error ingestion layer with parsers
- [ ] MongoDB schema and storage
- [ ] Basic HTTP API
- [ ] P4NTH30N bridge

### Phase 2: Detection (Week 3)
- [ ] Pattern matcher with signatures
- [ ] Statistical analyzer
- [ ] Anomaly scoring
- [ ] Context engine

### Phase 3: Healing (Week 4)
- [ ] Classification engine
- [ ] Action queue
- [ ] Plugin healer
- [ ] Basic circuit breaker

### Phase 4: Integration (Week 5)
- [ ] P4NTH30N healer
- [ ] Decision healer
- [ ] oh-my-opencode hooks
- [ ] Forgewright integration

### Phase 5: Safety & Polish (Week 6)
- [ ] Advanced circuit breaker
- [ ] Rollback capability
- [ ] Human approval flow
- [ ] Monitoring and metrics
- [ ] Documentation

---

## 11. Success Criteria

The Lazarus Protocol is successful when:

1. **>80% of known errors** are automatically healed without human intervention
2. **Zero false positive healing** (no healing actions that make things worse)
3. **<30s mean time to heal** for AUTO-level actions
4. **100% of insanity conditions** detected and escalated
5. **All healing actions** are logged and measurable

---

**Document Version**: 1.0  
**Last Updated**: 2026-02-23  
**Author**: Aegis (Designer Agent)  
**Classification**: DECISION_050 Specification  
