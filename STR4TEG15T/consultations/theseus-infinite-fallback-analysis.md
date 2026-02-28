# Infinite Fallback Loops & Triage Scorecard Analysis

**Agent**: Explorer (Pyxis)  
**Mission**: Analyze Theseus plugin fallback mechanics for infinite loop implementation and triage analytics  
**Date**: 2026-02-22  
**Source**: `C:\P4NTHE0N\plugins\theseues`

---

## Executive Summary

The Theseus plugin implements a sophisticated fallback system with circuit breakers, retry logic, and model health tracking. This analysis reveals how to transform the existing fail-through mechanism into an **infinite loop system** that treats triage data as a **competitive scorecard** for model analytics.

---

## 1. Current Fallback Chain Mechanics

### 1.1 Fallback Chain Definition

**Location**: `src/background/background-manager.ts` (lines 825-866)

```typescript
private getFullModelChain(agentName: string): string[] {
  const agents = this.config?.agents;
  const chainCandidates: Array<string | undefined> = [];

  if (agents && agents[agentName]) {
    const agentConfig = agents[agentName] as Record<string, unknown> | undefined;
    if (agentConfig && typeof agentConfig === 'object') {
      // First check for models array (full chain)
      const models = agentConfig.models as string[] | undefined;
      if (models && Array.isArray(models) && models.length > 0) {
        chainCandidates.push(...models);
      } else if (agentConfig.currentModel) {
        // Fall back to single model
        chainCandidates.push(agentConfig.currentModel as string);
      }
    }
  }

  // Legacy/CLI fallback chain compatibility
  const legacyChains = this.config?.fallback?.chains as
    | Record<string, string[] | undefined>
    | undefined;
  const legacyChain = legacyChains?.[agentName];
  if (legacyChain && Array.isArray(legacyChain)) {
    chainCandidates.push(...legacyChain);
  }

  let chain = this.normalizeModelChain(chainCandidates);

  // Fall back to DEFAULT_MODELS if nothing in config
  if (chain.length === 0) {
    const defaultModel =
      DEFAULT_MODELS[agentName as keyof typeof DEFAULT_MODELS];
    if (defaultModel) {
      chain = this.normalizeModelChain([defaultModel]);
    }
  }

  return chain;
}
```

**Configuration Schema** (`src/config/schema.ts` lines 106-126):

```typescript
const AgentModelChainSchema = z.array(z.string()).min(1);

const FallbackChainsSchema = z
  .object({
    orchestrator: AgentModelChainSchema.optional(),
    oracle: AgentModelChainSchema.optional(),
    designer: AgentModelChainSchema.optional(),
    explorer: AgentModelChainSchema.optional(),
    librarian: AgentModelChainSchema.optional(),
    fixer: AgentModelChainSchema.optional(),
  })
  .catchall(AgentModelChainSchema);

export const FailoverConfigSchema = z.object({
  enabled: z.boolean().default(true),
  timeoutMs: z.number().min(1000).max(120000).default(15000),
  chains: FallbackChainsSchema.optional(),
  triage: z.record(z.string(), ModelHealthSchema).default({}),
});
```

### 1.2 Current End-of-Chain Behavior

**Location**: `src/background/background-manager.ts` (lines 1526-1534)

When all models fail:

```typescript
if (!succeeded) {
  const finalError = `All fallback models failed after ${attemptCount} attempts. ${errors.join(' | ')}`;
  log(`[fallback] COMPLETE FAILURE: ${finalError}`, {
    taskId: task.id,
    agent: task.agent,
    totalAttempts: attemptCount,
  });
  throw new Error(finalError);
}
```

**Current behavior**: The task fails with an error when all models in the chain have been exhausted.

---

## 2. Triage Data Structure

### 2.1 Current Triage Schema

**Location**: `src/config/schema.ts` (lines 96-104)

```typescript
export const ModelHealthSchema = z.object({
  lastFailure: z.number().optional(),    // Unix timestamp (ms) of last failure
  failureCount: z.number().min(0).default(0),  // Consecutive failure count
  lastSuccess: z.number().optional(),    // Unix timestamp (ms) of last success
  lastChecked: z.number().optional(),    // Last health-check/probe timestamp
  disabled: z.boolean().optional(),      // Model disabled due to repeated failures
});

export type ModelHealth = z.infer<typeof ModelHealthSchema>;
```

### 2.2 Triage Persistence

**Location**: `src/background/background-manager.ts` (lines 406-572)

Triage data is persisted to `oh-my-opencode-theseus.json`:

```typescript
private async persistConfig(): Promise<void> {
  // ... validation and safety checks ...
  
  // Merge strategy: Preserve existing config and only update specific fields
  const mergedConfig: Record<string, unknown> = { ...existingConfig };

  // Only update triage data in fallback - never replace the entire fallback object
  if (this.config.fallback?.triage) {
    if (!mergedConfig.fallback || typeof mergedConfig.fallback !== 'object') {
      mergedConfig.fallback = {};
    }
    (mergedConfig.fallback as Record<string, unknown>).triage =
      this.config.fallback.triage;
  }
  
  // Write to ~/.config/opencode/oh-my-opencode-theseus.json
  await fs.writeFile(configPath, JSON.stringify(mergedConfig, null, 2), 'utf-8');
}
```

### 2.3 Circuit Breaker Integration

**Location**: `src/background/background-manager.ts` (lines 868-964)

```typescript
private async resolveFallbackChain(agentName: string): Promise<string[]> {
  // Get the full chain
  const chain = this.getFullModelChain(agentName);

  // Get model health from triage in config
  const triage = fallback?.triage ?? {};

  // Filter out models that have tripped the circuit breaker
  const availableChain = chain.filter((m) => {
    const health = triage[m];
    if (!health || !health.lastFailure) return true;

    const failureCount = (health.failureCount as number) ?? 0;
    const lastFailure = (health.lastFailure as number) ?? 0;

    if (failureCount >= this.CIRCUIT_BREAKER_THRESHOLD) {
      const lastChecked = (health.lastChecked as number) ?? 0;
      const gateTimestamp = Math.max(lastFailure, lastChecked);
      const ageMs = now - gateTimestamp;

      if (ageMs < this.CIRCUIT_BREAKER_COOLDOWN_MS) {
        // Circuit open - skip this model
        return false;
      }

      // Allow one probe after cooldown; this is the periodic health check.
      triage[m] = {
        ...health,
        lastChecked: now,
      };
      triageUpdated = true;
    }

    return true;
  });

  return providerAwareChain;
}
```

**Circuit Breaker Constants** (lines 252-253):

```typescript
private readonly CIRCUIT_BREAKER_THRESHOLD = 3;        // 3 consecutive failures
private readonly CIRCUIT_BREAKER_COOLDOWN_MS = 3600000; // 1 hour cooldown
```

---

## 3. Making Fallback Infinite

### 3.1 Detection of End-of-Chain

**Current Detection** (`src/background/background-manager.ts` lines 1185-1524):

The fallback loop iterates through `attemptModels` array:

```typescript
for (const model of attemptModels) {
  attemptCount++;
  // ... attempt logic ...
  if (modelSucceeded) {
    succeeded = true;
    break; // Exit model chain loop
  }
  // Try next model in chain
  if (attemptCount < attemptModels.length) {
    log(`[fallback] Retrying with next model in chain...`);
  }
}

if (!succeeded) {
  // ALL MODELS FAILED - throws error
  throw new Error(finalError);
}
```

### 3.2 Proposed Infinite Loop Architecture

```typescript
interface InfiniteFallbackConfig {
  enabled: boolean;
  mode: 'round-robin' | 'weighted' | 'adaptive';
  maxIterations: number;        // 0 = infinite
  loopDelayMs: number;          // Delay between loop iterations
  enableScorecard: boolean;     // Track detailed metrics
}

class InfiniteFallbackEngine {
  private scorecard: Map<string, TriageScorecard> = new Map();
  private iterationCount = 0;
  
  async executeWithLoop(
    task: BackgroundTask,
    prompt: string,
    chain: string[],
    config: InfiniteFallbackConfig
  ): Promise<TaskResult> {
    
    while (config.maxIterations === 0 || this.iterationCount < config.maxIterations) {
      this.iterationCount++;
      
      // Sort chain based on mode
      const orderedChain = this.orderChain(chain, config.mode);
      
      for (const model of orderedChain) {
        const startTime = Date.now();
        
        try {
          const result = await this.tryModel(model, prompt);
          const duration = Date.now() - startTime;
          
          this.recordSuccess(model, result, duration);
          return { success: true, result, model, attempts: this.getTotalAttempts() };
          
        } catch (error) {
          const duration = Date.now() - startTime;
          this.recordFailure(model, error, duration);
          
          // Continue to next model - don't break the loop
          continue;
        }
      }
      
      // All models in chain attempted, wait before next iteration
      if (config.loopDelayMs > 0) {
        await this.sleep(config.loopDelayMs);
      }
      
      log(`[infinite-fallback] Completed iteration ${this.iterationCount}, looping...`);
    }
    
    // Max iterations reached (if not infinite)
    throw new Error(`Max iterations (${config.maxIterations}) reached without success`);
  }
  
  private orderChain(chain: string[], mode: string): string[] {
    switch (mode) {
      case 'round-robin':
        // Rotate based on iteration count
        const offset = this.iterationCount % chain.length;
        return [...chain.slice(offset), ...chain.slice(0, offset)];
        
      case 'weighted':
        // Sort by success rate (highest first)
        return chain.sort((a, b) => {
          const scoreA = this.scorecard.get(a)?.successRate ?? 0.5;
          const scoreB = this.scorecard.get(b)?.successRate ?? 0.5;
          return scoreB - scoreA;
        });
        
      case 'adaptive':
        // Prioritize models with fewer recent failures
        return chain.sort((a, b) => {
          const failuresA = this.scorecard.get(a)?.consecutiveFailures ?? 0;
          const failuresB = this.scorecard.get(b)?.consecutiveFailures ?? 0;
          return failuresA - failuresB;
        });
        
      default:
        return chain;
    }
  }
}
```

### 3.3 Code Modifications Required

**File**: `src/background/background-manager.ts`

**Modification 1**: Add infinite loop configuration (around line 219):

```typescript
private fallbackConfig!: {
  enabled: boolean;
  timeoutMs: number;
  chains?: Record<string, string[]>;
  triage: Record<string, ModelHealth>;
  infiniteLoop?: {
    enabled: boolean;
    mode: 'round-robin' | 'weighted' | 'adaptive';
    maxIterations: number;     // 0 = truly infinite
    loopDelayMs: number;       // Delay between iterations
    enableScorecard: boolean;  // Track detailed metrics
  };
};
```

**Modification 2**: Replace the linear fallback loop (lines 1185-1524):

```typescript
// OLD: Linear iteration with failure at end
for (const model of attemptModels) {
  // ... attempt logic ...
}
if (!succeeded) {
  throw new Error(finalError);  // FAILS HERE
}

// NEW: Infinite loop with optional max iterations
const infiniteConfig = this.fallbackConfig.infiniteLoop;
let iterationCount = 0;

while (!succeeded) {
  iterationCount++;
  
  // Check max iterations (0 = infinite)
  if (infiniteConfig?.maxIterations > 0 && 
      iterationCount > infiniteConfig.maxIterations) {
    throw new Error(`Max iterations (${infiniteConfig.maxIterations}) reached`);
  }
  
  // Order models based on mode
  const orderedModels = this.orderModelsForIteration(
    attemptModels, 
    infiniteConfig?.mode || 'round-robin',
    iterationCount
  );
  
  for (const model of orderedModels) {
    // ... existing attempt logic ...
    if (modelSucceeded) {
      succeeded = true;
      break;
    }
  }
  
  // Delay before next iteration
  if (!succeeded && infiniteConfig?.loopDelayMs) {
    await this.sleep(infiniteConfig.loopDelayMs);
  }
}
```

---

## 4. Enhanced Triage Scorecard

### 4.1 Proposed Scorecard Schema

```typescript
interface TriageScorecard {
  // Model identification
  modelId: string;
  providerId: string;
  
  // Usage metrics
  totalCalls: number;
  totalSuccesses: number;
  totalFailures: number;
  successRate: number;           // 0.0 - 1.0
  
  // Timing metrics
  totalResponseTimeMs: number;
  avgResponseTimeMs: number;
  minResponseTimeMs: number;
  maxResponseTimeMs: number;
  
  // Failure analysis
  consecutiveFailures: number;
  circuitBreakerActivations: number;
  failureReasons: Record<string, number>;  // Error type -> count
  
  // Temporal tracking
  firstUsed: number;             // Unix timestamp
  lastUsed: number;              // Unix timestamp
  lastSuccess: number;           // Unix timestamp
  lastFailure: number;           // Unix timestamp
  
  // Prompt-type analytics (for A/B testing)
  promptTypeStats: Record<string, {
    calls: number;
    successes: number;
    avgResponseTimeMs: number;
  }>;
  
  // Iteration tracking (for infinite loops)
  iterationStats: {
    iterationNumber: number;
    attemptNumber: number;
  }[];
}
```

### 4.2 Scorecard Integration

**Location**: `src/background/background-manager.ts`

Add new methods:

```typescript
/**
 * Record a successful model attempt with full analytics
 */
private async recordModelSuccessDetailed(
  model: string,
  durationMs: number,
  promptType?: string,
  iterationData?: { iteration: number; attempt: number }
): Promise<void> {
  if (!this.config?.fallback?.triage) return;

  const triage = this.config.fallback.triage;
  const now = Date.now();
  
  // Get or create scorecard entry
  let scorecard = triage[model] as TriageScorecard | undefined;
  if (!scorecard) {
    scorecard = this.createEmptyScorecard(model);
    triage[model] = scorecard;
  }
  
  // Update metrics
  scorecard.totalCalls++;
  scorecard.totalSuccesses++;
  scorecard.successRate = scorecard.totalSuccesses / scorecard.totalCalls;
  scorecard.consecutiveFailures = 0;
  scorecard.lastSuccess = now;
  scorecard.lastUsed = now;
  
  // Timing
  scorecard.totalResponseTimeMs += durationMs;
  scorecard.avgResponseTimeMs = scorecard.totalResponseTimeMs / scorecard.totalCalls;
  scorecard.minResponseTimeMs = Math.min(scorecard.minResponseTimeMs, durationMs);
  scorecard.maxResponseTimeMs = Math.max(scorecard.maxResponseTimeMs, durationMs);
  
  // Prompt type stats
  if (promptType) {
    if (!scorecard.promptTypeStats[promptType]) {
      scorecard.promptTypeStats[promptType] = {
        calls: 0,
        successes: 0,
        avgResponseTimeMs: 0,
      };
    }
    const stats = scorecard.promptTypeStats[promptType];
    stats.calls++;
    stats.successes++;
    stats.avgResponseTimeMs = 
      (stats.avgResponseTimeMs * (stats.calls - 1) + durationMs) / stats.calls;
  }
  
  // Iteration tracking
  if (iterationData) {
    scorecard.iterationStats.push({
      iterationNumber: iterationData.iteration,
      attemptNumber: iterationData.attempt,
    });
  }
  
  void this.persistConfig();
}

/**
 * Record a failed model attempt with error classification
 */
private async recordModelFailureDetailed(
  model: string,
  error: unknown,
  durationMs: number,
  promptType?: string,
  iterationData?: { iteration: number; attempt: number }
): Promise<void> {
  if (!this.config?.fallback?.triage) return;

  const triage = this.config.fallback.triage;
  const now = Date.now();
  
  // Classify error
  const errorType = this.errorClassifier.classify(error);
  const errorLabel = errorTypeLabel(errorType);
  
  // Get or create scorecard entry
  let scorecard = triage[model] as TriageScorecard | undefined;
  if (!scorecard) {
    scorecard = this.createEmptyScorecard(model);
    triage[model] = scorecard;
  }
  
  // Update metrics
  scorecard.totalCalls++;
  scorecard.totalFailures++;
  scorecard.successRate = scorecard.totalSuccesses / scorecard.totalCalls;
  scorecard.consecutiveFailures++;
  scorecard.lastFailure = now;
  scorecard.lastUsed = now;
  
  // Circuit breaker check
  if (scorecard.consecutiveFailures >= this.CIRCUIT_BREAKER_THRESHOLD) {
    scorecard.circuitBreakerActivations++;
  }
  
  // Failure reasons
  if (!scorecard.failureReasons[errorLabel]) {
    scorecard.failureReasons[errorLabel] = 0;
  }
  scorecard.failureReasons[errorLabel]++;
  
  // Prompt type stats
  if (promptType) {
    if (!scorecard.promptTypeStats[promptType]) {
      scorecard.promptTypeStats[promptType] = {
        calls: 0,
        successes: 0,
        avgResponseTimeMs: 0,
      };
    }
    const stats = scorecard.promptTypeStats[promptType];
    stats.calls++;
    stats.avgResponseTimeMs = 
      (stats.avgResponseTimeMs * (stats.calls - 1) + durationMs) / stats.calls;
  }
  
  // Iteration tracking
  if (iterationData) {
    scorecard.iterationStats.push({
      iterationNumber: iterationData.iteration,
      attemptNumber: iterationData.attempt,
    });
  }
  
  void this.persistConfig();
}

private createEmptyScorecard(model: string): TriageScorecard {
  const parsed = parseModelReference(model);
  return {
    modelId: model,
    providerId: parsed?.providerID || 'unknown',
    totalCalls: 0,
    totalSuccesses: 0,
    totalFailures: 0,
    successRate: 0,
    totalResponseTimeMs: 0,
    avgResponseTimeMs: 0,
    minResponseTimeMs: Infinity,
    maxResponseTimeMs: 0,
    consecutiveFailures: 0,
    circuitBreakerActivations: 0,
    failureReasons: {},
    firstUsed: Date.now(),
    lastUsed: 0,
    lastSuccess: 0,
    lastFailure: 0,
    promptTypeStats: {},
    iterationStats: [],
  };
}
```

---

## 5. Export/Report Generation

### 5.1 Scorecard Export Methods

```typescript
interface ScorecardExportOptions {
  format: 'json' | 'csv' | 'html' | 'markdown';
  includeRawData: boolean;
  sortBy: 'successRate' | 'totalCalls' | 'avgResponseTime' | 'lastUsed';
  filterMinCalls: number;        // Only include models with N+ calls
  timeRange?: {                  // Optional time filter
    start: number;
    end: number;
  };
}

class ScorecardExporter {
  constructor(private triage: Record<string, TriageScorecard>) {}
  
  export(options: ScorecardExportOptions): string {
    const data = this.prepareData(options);
    
    switch (options.format) {
      case 'json':
        return this.exportJson(data, options);
      case 'csv':
        return this.exportCsv(data, options);
      case 'html':
        return this.exportHtml(data, options);
      case 'markdown':
        return this.exportMarkdown(data, options);
      default:
        throw new Error(`Unknown format: ${options.format}`);
    }
  }
  
  private prepareData(options: ScorecardExportOptions): TriageScorecard[] {
    let data = Object.values(this.triage);
    
    // Filter by minimum calls
    if (options.filterMinCalls > 0) {
      data = data.filter(s => s.totalCalls >= options.filterMinCalls);
    }
    
    // Filter by time range
    if (options.timeRange) {
      data = data.filter(s => 
        s.lastUsed >= options.timeRange!.start && 
        s.lastUsed <= options.timeRange!.end
      );
    }
    
    // Sort
    data.sort((a, b) => {
      switch (options.sortBy) {
        case 'successRate':
          return b.successRate - a.successRate;
        case 'totalCalls':
          return b.totalCalls - a.totalCalls;
        case 'avgResponseTime':
          return a.avgResponseTimeMs - b.avgResponseTimeMs;
        case 'lastUsed':
          return b.lastUsed - a.lastUsed;
        default:
          return 0;
      }
    });
    
    return data;
  }
  
  private exportJson(data: TriageScorecard[], options: ScorecardExportOptions): string {
    const exportData = {
      generatedAt: new Date().toISOString(),
      totalModels: data.length,
      summary: this.calculateSummary(data),
      models: data,
    };
    
    return JSON.stringify(exportData, null, 2);
  }
  
  private exportCsv(data: TriageScorecard[], options: ScorecardExportOptions): string {
    const headers = [
      'Model ID',
      'Provider',
      'Total Calls',
      'Success Rate %',
      'Avg Response Time (ms)',
      'Circuit Breaker Activations',
      'Consecutive Failures',
      'Last Used',
    ];
    
    const rows = data.map(s => [
      s.modelId,
      s.providerId,
      s.totalCalls,
      (s.successRate * 100).toFixed(2),
      s.avgResponseTimeMs.toFixed(0),
      s.circuitBreakerActivations,
      s.consecutiveFailures,
      new Date(s.lastUsed).toISOString(),
    ]);
    
    return [headers.join(','), ...rows.map(r => r.join(','))].join('\n');
  }
  
  private exportHtml(data: TriageScorecard[], options: ScorecardExportOptions): string {
    const summary = this.calculateSummary(data);
    
    return `<!DOCTYPE html>
<html>
<head>
  <title>Model Performance Scorecard</title>
  <style>
    body { font-family: Arial, sans-serif; margin: 20px; }
    .summary { background: #f0f0f0; padding: 15px; border-radius: 5px; margin-bottom: 20px; }
    table { border-collapse: collapse; width: 100%; }
    th, td { border: 1px solid #ddd; padding: 8px; text-align: left; }
    th { background: #4CAF50; color: white; }
    tr:nth-child(even) { background: #f2f2f2; }
    .success-high { color: green; }
    .success-medium { color: orange; }
    .success-low { color: red; }
  </style>
</head>
<body>
  <h1>Model Performance Scorecard</h1>
  <div class="summary">
    <h2>Summary</h2>
    <p>Total Models: ${summary.totalModels}</p>
    <p>Total Calls: ${summary.totalCalls}</p>
    <p>Overall Success Rate: ${(summary.overallSuccessRate * 100).toFixed(2)}%</p>
    <p>Avg Response Time: ${summary.avgResponseTime.toFixed(0)}ms</p>
  </div>
  <table>
    <tr>
      <th>Rank</th>
      <th>Model</th>
      <th>Provider</th>
      <th>Calls</th>
      <th>Success Rate</th>
      <th>Avg Response</th>
      <th>Circuit Breakers</th>
    </tr>
    ${data.map((s, i) => `
    <tr>
      <td>${i + 1}</td>
      <td>${s.modelId}</td>
      <td>${s.providerId}</td>
      <td>${s.totalCalls}</td>
      <td class="${s.successRate > 0.8 ? 'success-high' : s.successRate > 0.5 ? 'success-medium' : 'success-low'}">
        ${(s.successRate * 100).toFixed(2)}%
      </td>
      <td>${s.avgResponseTimeMs.toFixed(0)}ms</td>
      <td>${s.circuitBreakerActivations}</td>
    </tr>
    `).join('')}
  </table>
</body>
</html>`;
  }
  
  private exportMarkdown(data: TriageScorecard[], options: ScorecardExportOptions): string {
    const summary = this.calculateSummary(data);
    
    return `# Model Performance Scorecard

Generated: ${new Date().toISOString()}

## Summary

- **Total Models**: ${summary.totalModels}
- **Total Calls**: ${summary.totalCalls}
- **Overall Success Rate**: ${(summary.overallSuccessRate * 100).toFixed(2)}%
- **Average Response Time**: ${summary.avgResponseTime.toFixed(0)}ms

## Leaderboard

| Rank | Model | Provider | Calls | Success Rate | Avg Response | Circuit Breakers |
|------|-------|----------|-------|--------------|--------------|------------------|
${data.map((s, i) => `| ${i + 1} | ${s.modelId} | ${s.providerId} | ${s.totalCalls} | ${(s.successRate * 100).toFixed(2)}% | ${s.avgResponseTimeMs.toFixed(0)}ms | ${s.circuitBreakerActivations} |`).join('\n')}

## Failure Breakdown

${data.map(s => `
### ${s.modelId}

**Failure Reasons:**
${Object.entries(s.failureReasons).map(([reason, count]) => `- ${reason}: ${count}`).join('\n')}
`).join('\n')}
`;
  }
  
  private calculateSummary(data: TriageScorecard[]) {
    const totalCalls = data.reduce((sum, s) => sum + s.totalCalls, 0);
    const totalSuccesses = data.reduce((sum, s) => sum + s.totalSuccesses, 0);
    
    return {
      totalModels: data.length,
      totalCalls,
      overallSuccessRate: totalCalls > 0 ? totalSuccesses / totalCalls : 0,
      avgResponseTime: data.length > 0 
        ? data.reduce((sum, s) => sum + s.avgResponseTimeMs, 0) / data.length 
        : 0,
    };
  }
}
```

### 5.2 CLI Integration

**File**: `src/cli/fallback.ts` (new file)

```typescript
import { ScorecardExporter } from '../background/scorecard-exporter';

export async function exportScorecardCommand(
  configPath: string,
  options: {
    format: 'json' | 'csv' | 'html' | 'markdown';
    output?: string;
    sortBy?: string;
    minCalls?: number;
  }
): Promise<void> {
  // Load config
  const config = await loadConfig(configPath);
  const triage = config.fallback?.triage || {};
  
  // Export
  const exporter = new ScorecardExporter(triage);
  const content = exporter.export({
    format: options.format,
    includeRawData: true,
    sortBy: (options.sortBy as any) || 'successRate',
    filterMinCalls: options.minCalls || 0,
  });
  
  // Write output
  if (options.output) {
    await fs.writeFile(options.output, content, 'utf-8');
    console.log(`Scorecard exported to: ${options.output}`);
  } else {
    console.log(content);
  }
}

export async function resetScorecardCommand(configPath: string): Promise<void> {
  const config = await loadConfig(configPath);
  
  if (config.fallback) {
    config.fallback.triage = {};
    await saveConfig(configPath, config);
    console.log('Scorecard reset complete');
  }
}
```

---

## 6. Configuration Example

### 6.1 Infinite Loop Mode Configuration

```json
{
  "agents": {
    "orchestrator": {
      "currentModel": "openrouter/claude-3.5-sonnet",
      "models": [
        "openrouter/claude-3.5-sonnet",
        "openrouter/gpt-4o",
        "openrouter/gemini-pro",
        "openrouter/llama-3.1-70b",
        "openrouter/mistral-large"
      ]
    },
    "explorer": {
      "currentModel": "openrouter/gpt-4o-mini",
      "models": [
        "openrouter/gpt-4o-mini",
        "openrouter/claude-3-haiku",
        "openrouter/gemini-flash"
      ]
    }
  },
  "fallback": {
    "enabled": true,
    "timeoutMs": 15000,
    "chains": {
      "orchestrator": [
        "openrouter/claude-3.5-sonnet",
        "openrouter/gpt-4o",
        "openrouter/gemini-pro"
      ],
      "explorer": [
        "openrouter/gpt-4o-mini",
        "openrouter/claude-3-haiku",
        "openrouter/gemini-flash"
      ]
    },
    "triage": {},
    "infiniteLoop": {
      "enabled": true,
      "mode": "adaptive",
      "maxIterations": 0,
      "loopDelayMs": 1000,
      "enableScorecard": true
    }
  },
  "hangDetection": {
    "enabled": true,
    "detection": {
      "inactivityTimeout": 300000,
      "rateLimitRetryThreshold": 5
    },
    "circuitBreaker": {
      "failureThreshold": 3,
      "cooldownPeriod": 3600000
    }
  }
}
```

### 6.2 Schema Updates

**File**: `src/config/schema.ts`

```typescript
export const InfiniteLoopConfigSchema = z.object({
  enabled: z.boolean().default(false),
  mode: z.enum(['round-robin', 'weighted', 'adaptive']).default('round-robin'),
  maxIterations: z.number().min(0).default(0),  // 0 = infinite
  loopDelayMs: z.number().min(0).max(60000).default(1000),
  enableScorecard: z.boolean().default(true),
});

export const EnhancedModelHealthSchema = z.object({
  // Existing fields
  lastFailure: z.number().optional(),
  failureCount: z.number().min(0).default(0),
  lastSuccess: z.number().optional(),
  lastChecked: z.number().optional(),
  disabled: z.boolean().optional(),
  
  // New scorecard fields
  totalCalls: z.number().min(0).default(0),
  totalSuccesses: z.number().min(0).default(0),
  totalFailures: z.number().min(0).default(0),
  successRate: z.number().min(0).max(1).default(0),
  totalResponseTimeMs: z.number().min(0).default(0),
  avgResponseTimeMs: z.number().min(0).default(0),
  minResponseTimeMs: z.number().min(0).default(Infinity),
  maxResponseTimeMs: z.number().min(0).default(0),
  consecutiveFailures: z.number().min(0).default(0),
  circuitBreakerActivations: z.number().min(0).default(0),
  failureReasons: z.record(z.string(), z.number()).default({}),
  firstUsed: z.number().optional(),
  lastUsed: z.number().optional(),
  promptTypeStats: z.record(z.string(), z.object({
    calls: z.number(),
    successes: z.number(),
    avgResponseTimeMs: z.number(),
  })).default({}),
  iterationStats: z.array(z.object({
    iterationNumber: z.number(),
    attemptNumber: z.number(),
  })).default([]),
});

export const FailoverConfigSchema = z.object({
  enabled: z.boolean().default(true),
  timeoutMs: z.number().min(1000).max(120000).default(15000),
  chains: FallbackChainsSchema.optional(),
  triage: z.record(z.string(), EnhancedModelHealthSchema).default({}),
  infiniteLoop: InfiniteLoopConfigSchema.optional(),
});
```

---

## 7. Implementation Roadmap

### Phase 1: Enhanced Triage Schema
1. Update `ModelHealthSchema` with scorecard fields
2. Add migration logic for existing triage data
3. Update `recordModelSuccess` and `recordModelFailure` methods
4. Add timing instrumentation to model attempts

### Phase 2: Infinite Loop Engine
1. Create `InfiniteFallbackEngine` class
2. Implement chain ordering strategies (round-robin, weighted, adaptive)
3. Add iteration tracking and delay mechanisms
4. Integrate with existing `startTask` method

### Phase 3: Scorecard Export
1. Create `ScorecardExporter` class
2. Implement JSON, CSV, HTML, and Markdown export formats
3. Add CLI commands for export and reset
4. Create visualization templates

### Phase 4: Analytics Dashboard
1. Add real-time scorecard updates
2. Create leaderboard view
3. Implement trend analysis
4. Add A/B testing framework for prompt types

---

## 8. Key Files Modified

| File | Lines | Purpose |
|------|-------|---------|
| `src/config/schema.ts` | +50 | Enhanced schemas for infinite loop and scorecard |
| `src/background/background-manager.ts` | +200 | Infinite loop logic, detailed tracking |
| `src/background/scorecard-exporter.ts` | +150 | Export/report generation |
| `src/cli/fallback.ts` | +100 | CLI commands for scorecard management |
| `src/background/infinite-fallback-engine.ts` | +200 | New infinite loop engine |

---

## 9. Competitive Leaderboard Concept

With the enhanced scorecard system, models compete on multiple metrics:

### Leaderboard Categories

1. **Success Rate Champions**: Models with highest success rates (>95%)
2. **Speed Demons**: Fastest average response times
3. **Marathon Runners**: Most total calls handled
4. **Comeback Kids**: Models that succeed after circuit breaker recovery
5. **Prompt Specialists**: Best performance by prompt type

### Gamification Elements

```typescript
interface Achievement {
  id: string;
  name: string;
  description: string;
  condition: (scorecard: TriageScorecard) => boolean;
  badge: string;
}

const ACHIEVEMENTS: Achievement[] = [
  {
    id: 'perfect-score',
    name: 'Perfect Score',
    description: '100% success rate over 50+ calls',
    condition: (s) => s.successRate === 1 && s.totalCalls >= 50,
    badge: '🏆',
  },
  {
    id: 'speed-king',
    name: 'Speed King',
    description: 'Sub-100ms average response time',
    condition: (s) => s.avgResponseTimeMs < 100,
    badge: '⚡',
  },
  {
    id: 'workhorse',
    name: 'Workhorse',
    description: '1000+ total calls',
    condition: (s) => s.totalCalls >= 1000,
    badge: '💪',
  },
  {
    id: 'phoenix',
    name: 'Phoenix',
    description: 'Recovered from circuit breaker 3+ times',
    condition: (s) => s.circuitBreakerActivations >= 3 && s.successRate > 0.5,
    badge: '🔥',
  },
];
```

---

## 10. Conclusion

The Theseus plugin's fallback system provides a solid foundation for implementing infinite loops and comprehensive analytics. By:

1. **Modifying the fallback loop** to iterate infinitely with configurable delays
2. **Enhancing the triage schema** to track detailed performance metrics
3. **Adding export capabilities** for end-game analysis
4. **Implementing competitive leaderboards** for model comparison

We create a system that:
- Never gives up (infinite retry)
- Learns from every attempt (detailed scorecard)
- Provides actionable insights (exportable reports)
- Gamifies model selection (competitive leaderboards)

This transforms the fallback system from a simple fail-through mechanism into a sophisticated model testing and optimization platform.

---

**End of Analysis**
