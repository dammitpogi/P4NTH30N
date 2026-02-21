# Tool Output: tool_c6408c804001NPBiNGrasi8uO9
**Date**: 2026-02-16 01:20:23 UTC
**Size**: 66,562 bytes

```
/**
 * Background Task Manager
 *
 * Manages long-running AI agent tasks that execute in separate sessions.
 * Background tasks run independently from the main conversation flow, allowing
 * the user to continue working while tasks complete asynchronously.
 *
 * Key features:
 * - Fire-and-forget launch (returns task_id immediately)
 * - Creates isolated sessions for background work
 * - Event-driven completion detection via session.status
 * - Start queue with configurable concurrency limit
 * - Supports task cancellation and result retrieval
 */

import type { PluginInput } from '@opencode-ai/plugin';
import type {
  AgentOverrideConfig,
  BackgroundTaskConfig,
  PluginConfig,
} from '../config';
import {
  FALLBACK_FAILOVER_TIMEOUT_MS,
  SUBAGENT_DELEGATION_RULES,
} from '../config';

// Hardcoded default models - source of truth when config doesn't provide them
const HARDCODED_DEFAULTS: Record<string, string> = {
  orchestrator: 'free/openrouter/free',
  oracle: 'free/openrouter/free',
  librarian: 'free/openrouter/free',
  explorer: 'free/openrouter/free',
  designer: 'free/openrouter/free',
  fixer: 'free/openrouter/free',
};

import type { TmuxConfig } from '../config/schema';
import { applyAgentVariant, resolveAgentVariant } from '../utils';
import { log } from '../utils/debug';

function detectProviderError(errorMessage: string): boolean {
  const providerErrorPatterns = [
    /rate.limit/i,
    /context.length/i,
    /token.limit/i,
    /max.token/i,
    /more.credit/i,
    /fewer.max_token/i,
    /model.unavailable/i,
    /credit.exceeded/i,
    /insufficient.quota/i,
    /api.usage/i,
    /429/, // HTTP status code for rate limit
    /503/, // HTTP status code for service unavailable
    /504/, // HTTP status code for gateway timeout
    // Invalid model errors should trigger fallback
    /invalid.*model/i,
    /model.*not.*found/i,
    /unknown.*model/i,
    /model.*not.*available/i,
    // Generic unknown errors should trigger fallback
    /unknown.*error/i,
    /unknown.*failure/i,
    // Auth and key errors should trigger fallback
    /api.*key/i,
    /authentication/i,
    /unauthorized/i,
    /invalid.*api/i,
    // Network and connection errors
    /network.*error/i,
    /connection.*error/i,
    /timeout/i,
    /econnrefused/i,
    /econnreset/i,
    /enotfound/i,
    // Agent-specific errors that should trigger fallback
    /agent.*not.*found/i,
    /agent.*not.*available/i,
    /subagent.*error/i,
    // General provider failures
    /provider.*error/i,
    /upstream.*error/i,
    /server.*error/i,
    /internal.*error/i,
    // Google/Gemini quota and resource errors
    /quota.exceeded/i,
    /exceeded.your.current.quota/i,
    /RESOURCE_EXHAUSTED/,
    /generativelanguage\.googleapis\.com/,
    /typo.in.the.url.or.port/i,
    /unable.to.connect/i,
  ];

  return providerErrorPatterns.some((pattern) => pattern.test(errorMessage));
}

type PromptBody = {
  messageID?: string;
  model?: { providerID: string; modelID: string };
  agent?: string;
  noReply?: boolean;
  system?: string;
  tools?: { [key: string]: boolean };
  parts: Array<{ type: 'text'; text: string }>;
  variant?: string;
};

type OpencodeClient = PluginInput['client'];

function parseModelReference(model: string): {
  providerID: string;
  modelID: string;
} | null {
  const slashIndex = model.indexOf('/');
  if (slashIndex <= 0 || slashIndex >= model.length - 1) {
    return null;
  }

  return {
    providerID: model.slice(0, slashIndex),
    modelID: model.slice(slashIndex + 1),
  };
}

/**
 * Represents a fallback attempt during task execution.
 */
export interface FallbackAttempt {
  model: string;
  success: boolean;
  error?: string;
  timestamp: number;
}

/**
 * Tracks fallback events for a background task.
 */
export interface FallbackInfo {
  occurred: boolean;
  attempts: FallbackAttempt[];
  successfulModel?: string;
  totalAttempts: number;
}

export interface HangRecoveryEvent {
  timestamp: number;
  reason: string;
  action: 'fallback-retry-started' | 'fallback-exhausted';
}

/**
 * Represents a background task running in an isolated session.
 * Tasks are tracked from creation through completion or failure.
 */
export interface BackgroundTask {
  id: string; // Unique task identifier (e.g., "bg_abc123")
  sessionId?: string; // OpenCode session ID (set when starting)
  description: string; // Human-readable task description
  agent: string; // Agent name handling the task
  status:
    | 'pending'
    | 'starting'
    | 'running'
    | 'completed'
    | 'failed'
    | 'cancelled';
  result?: string; // Final output from the agent (when completed)
  error?: string; // Error message (when failed)
  config: BackgroundTaskConfig; // Task configuration
  parentSessionId: string; // Parent session ID for notifications
  startedAt: Date; // Task creation timestamp
  completedAt?: Date; // Task completion/failure timestamp
  prompt: string; // Initial prompt
  fallbackInfo?: FallbackInfo; // Fallback tracking info
  connectivityRetryCount?: number; // Retry count for transient connectivity failures
  hangRecoveryEvents?: HangRecoveryEvent[];
  lastActivityAt?: number;
  missingSinceAt?: number;
  hangRecoveryInProgress?: boolean;
  activeModel?: string;
}

interface QueuedNotification {
  message: string;
  urgent?: boolean;
}

/**
 * Options for launching a new background task.
 */
export interface LaunchOptions {
  agent: string; // Agent to handle the task
  prompt: string; // Initial prompt to send to the agent
  description: string; // Human-readable task description
  parentSessionId: string; // Parent session ID for task hierarchy
}

function generateTaskId(): string {
  return `bg_${Math.random().toString(36).substring(2, 10)}`;
}

export class BackgroundTaskManager {
  private tasks = new Map<string, BackgroundTask>();
  private tasksBySessionId = new Map<string, string>();
  // Track which agent type owns each session for delegation permission checks
  private agentBySessionId = new Map<string, string>();
  private client: OpencodeClient;
  private directory: string;
  private tmuxEnabled: boolean;
  private config?: PluginConfig;
  private backgroundConfig: BackgroundTaskConfig;
  // Guaranteed fallback config with all required fields
  private fallbackConfig!: {
    enabled: boolean;
    timeoutMs: number;
    chains?: Record<string, string[]>;
    triage: Record<
      string,
      {
        lastFailure?: number;
        failureCount: number;
        lastSuccess?: number;
        lastChecked?: number;
        disabled?: boolean;
      }
    >;
  };

  // Start queue
  private startQueue: BackgroundTask[] = [];
  private activeStarts = 0;
  private maxConcurrentStarts: number;

  // Completion waiting
  private completionResolvers = new Map<
    string,
    (task: BackgroundTask) => void
  >();

  // Parent-session notification queues
  private queuedNotifications = new Map<string, QueuedNotification[]>();
  private flushingNotifications = new Set<string>();
  private sessionStatusById = new Map<string, string>();

  // Circuit breaker configuration
  private readonly CIRCUIT_BREAKER_THRESHOLD = 3; // Number of consecutive failures before opening circuit
  private readonly CIRCUIT_BREAKER_COOLDOWN_MS = 3600000; // 1 hour cooldown before retrying failed models
  private readonly MAX_CONNECTIVITY_RETRIES = 5;
  private readonly STATUS_POLL_INTERVAL_MS = 5000;
  private hangInactivityTimeoutMs = 300000;
  private statusPollTimer?: ReturnType<typeof setInterval>;

  private isConnectivityError(message: string): boolean {
    return /unable\s*to\s*connect|access\s+the\s+url|unable\s+to\s+access\s+url|network\s*error|connection\s*error|econnrefused|econnreset|enotfound|timeout|typo\s+in\s+the\s+url\s+or\s+port/i.test(
      message,
    );
  }

  constructor(
    ctx: PluginInput,
    tmuxConfig?: TmuxConfig,
    config?: PluginConfig,
  ) {
    this.client = ctx.client;
    this.directory = ctx.directory;
    this.tmuxEnabled = tmuxConfig?.enabled ?? false;
    this.config = config ?? {};

    // Debug: log config received
    log('[background-manager] Constructor received config:', {
      hasConfig: !!config,
      hasAgents: !!config?.agents,
      hasFallback: !!config?.fallback,
    });

    this.backgroundConfig = config?.background ?? {
      maxConcurrentStarts: 10,
    };
    this.maxConcurrentStarts = this.backgroundConfig.maxConcurrentStarts;
    this.hangInactivityTimeoutMs =
      config?.hangDetection?.detection?.inactivityTimeout ??
      this.hangInactivityTimeoutMs;

    // Initialize fallback config if not present
    if (!this.config.fallback) {
      this.config.fallback = {
        enabled: true,
        timeoutMs: 15000,
        triage: {},
      };
    } else {
      // Ensure triage exists
      if (!this.config.fallback.triage) {
        this.config.fallback.triage = {};
      }
    }

    // Store reference to guaranteed fallback config
    this.fallbackConfig = this.config.fallback;

    this.startStatusPolling();
  }

  /**
   * Get the currently configured model for an agent.
   */
  private getConfiguredAgentModel(agentName: string): string | undefined {
    const agentConfig = this.config?.agents?.[agentName] as
      | Record<string, unknown>
      | undefined;

    return typeof agentConfig?.currentModel === 'string'
      ? agentConfig.currentModel
      : undefined;
  }

  /**
   * Persist the active model on agents[agentName].currentModel.
   */
  private async setConfiguredAgentModel(
    agentName: string,
    model: string,
    persist = true,
  ): Promise<void> {
    if (!this.config) return;

    const current = this.getConfiguredAgentModel(agentName);
    if (current === model) return;

    if (!this.config.agents) {
      this.config.agents = {};
    }

    const existing = this.config.agents[agentName];
    const agentConfig: Record<string, unknown> =
      existing && typeof existing === 'object' ? { ...existing } : {};

    agentConfig.currentModel = model;
    delete agentConfig.model;
    this.config.agents[agentName] = agentConfig as AgentOverrideConfig;

    log(`[fallback] Updated agents.${agentName}.currentModel to ${model}`);

    if (persist) {
      // Persistence is best-effort; do not block task startup.
      void this.persistConfig();
    }
  }

  /**
   * Persist the current config state (including model health) back to file
   */
  private async persistConfig(): Promise<void> {
    if (!this.config) return;

    try {
      // Import fs dynamically to avoid issues
      const fs = await import('node:fs/promises');
      const path = await import('node:path');
      const os = await import('node:os');

      // Look for config file in user config directory (NOT project directory)
      // The plugin config is in ~/.config/opencode/
      const userConfigDir = path.join(os.homedir(), '.config', 'opencode');
      const configPaths = [
        path.join(userConfigDir, 'oh-my-opencode-theseus.json'),
        path.join(this.directory, 'oh-my-opencode-theseus.json'),
        path.join(this.directory, '.opencode', 'oh-my-opencode-theseus.json'),
      ];

      let configPath: string | null = null;
      for (const p of configPaths) {
        try {
          await fs.access(p);
          configPath = p;
          log('[config] Found config file at:', p);
          break;
        } catch {
          // File doesn't exist, try next
        }
      }

      if (!configPath) {
        log(
          '[config] ERROR: Could not find config file to persist model health',
        );
        return;
      }

      // Write updated config
      await fs.writeFile(
        configPath,
        JSON.stringify(this.config, null, 2),
        'utf-8',
      );
      log('[config] Persisted model health state to config file');
    } catch (error) {
      const msg = error instanceof Error ? error.message : String(error);
      log('[config] ERROR: Failed to persist config', { error: msg });
    }
  }

  /**
   * Look up the delegation rules for an agent type.
   * Unknown agent types default to explorer-only access, making it easy
   * to add new background agent types without updating SUBAGENT_DELEGATION_RULES.
   */
  private getSubagentRules(agentName: string): readonly string[] {
    return (
      SUBAGENT_DELEGATION_RULES[
        agentName as keyof typeof SUBAGENT_DELEGATION_RULES
      ] ?? ['explorer']
    );
  }

  /**
   * Check if a parent session is allowed to delegate to a specific agent type.
   * @param parentSessionId - The session ID of the parent
   * @param requestedAgent - The agent type being requested
   * @returns true if allowed, false if not
   */
  isAgentAllowed(parentSessionId: string, requestedAgent: string): boolean {
    // Untracked sessions are the root orchestrator (created by OpenCode, not by us)
    const parentAgentName =
      this.agentBySessionId.get(parentSessionId) ?? 'orchestrator';

    const allowedSubagents = this.getSubagentRules(parentAgentName);

    if (allowedSubagents.length === 0) return false;

    return allowedSubagents.includes(requestedAgent);
  }

  /**
   * Get the list of allowed subagents for a parent session.
   * @param parentSessionId - The session ID of the parent
   * @returns Array of allowed agent names, empty if none
   */
  getAllowedSubagents(parentSessionId: string): readonly string[] {
    // Untracked sessions are the root orchestrator (created by OpenCode, not by us)
    const parentAgentName =
      this.agentBySessionId.get(parentSessionId) ?? 'orchestrator';

    return this.getSubagentRules(parentAgentName);
  }

  /**
   * Launch a new background task (fire-and-forget).
   *
   * Phase A (sync): Creates task record and returns immediately.
   * Phase B (async): Session creation and prompt sending happen in background.
   *
   * @param opts - Task configuration options
   * @returns The created background task with pending status
   */
  launch(opts: LaunchOptions): BackgroundTask {
    const task: BackgroundTask = {
      id: generateTaskId(),
      sessionId: undefined,
      description: opts.description,
      agent: opts.agent,
      status: 'pending',
      startedAt: new Date(),
      config: {
        maxConcurrentStarts: this.maxConcurrentStarts,
      },
      parentSessionId: opts.parentSessionId,
      prompt: opts.prompt,
      hangRecoveryEvents: [],
      lastActivityAt: Date.now(),
    };

    this.tasks.set(task.id, task);
    this.startStatusPolling();

    // Queue task for background start
    this.enqueueStart(task);

    log(`[background-manager] task launched: ${task.id}`, {
      agent: opts.agent,
      description: opts.description,
    });

    return task;
  }

  /**
   * Enqueue task for background start.
   */
  private enqueueStart(task: BackgroundTask): void {
    this.startQueue.push(task);
    this.processQueue();
  }

  /**
   * Process start queue with concurrency limit.
   */
  private processQueue(): void {
    while (
      this.activeStarts < this.maxConcurrentStarts &&
      this.startQueue.length > 0
    ) {
      const task = this.startQueue.shift();
      if (!task) break;
      this.startTask(task);
    }
  }

  private touchTaskActivity(task: BackgroundTask): void {
    task.lastActivityAt = Date.now();
    task.missingSinceAt = undefined;
  }

  private startStatusPolling(): void {
    if (this.statusPollTimer) return;

    this.statusPollTimer = setInterval(() => {
      void this.pollRunningTasks();
    }, this.STATUS_POLL_INTERVAL_MS);
  }

  private stopStatusPolling(): void {
    if (!this.statusPollTimer) return;
    clearInterval(this.statusPollTimer);
    this.statusPollTimer = undefined;
  }

  private async pollRunningTasks(): Promise<void> {
    if (!this.hasActiveTasks()) return;

    try {
      const statusResult = await this.client.session.status();
      const allStatuses = (statusResult.data ?? {}) as Record<
        string,
        { type: string }
      >;

      const now = Date.now();
      const terminalTasks: BackgroundTask[] = [];
      const hangingTasks: BackgroundTask[] = [];

      for (const task of this.tasks.values()) {
        if (task.status !== 'running' || !task.sessionId) continue;

        const status = allStatuses[task.sessionId];
        if (status?.type) {
          this.sessionStatusById.set(task.sessionId, status.type);
          this.touchTaskActivity(task);

          if (
            status.type === 'idle' ||
            status.type === 'error' ||
            status.type === 'failed' ||
            status.type === 'completed'
          ) {
            terminalTasks.push(task);
          }
          continue;
        }

        task.missingSinceAt = task.missingSinceAt ?? now;

        const sinceActivity =
          now - (task.lastActivityAt ?? task.startedAt.getTime());
        if (sinceActivity >= this.hangInactivityTimeoutMs) {
          hangingTasks.push(task);
        }
      }

      for (const task of terminalTasks) {
        await this.extractAndCompleteTask(task);
      }

      for (const task of hangingTasks) {
        await this.recoverFromHang(task);
      }
    } catch (error) {
      log('[background-manager] pollRunningTasks error', {
        error: error instanceof Error ? error.message : String(error),
      });
    }
  }

  private async recoverFromHang(task: BackgroundTask): Promise<void> {
    if (task.status !== 'running') return;
    if (task.hangRecoveryInProgress) return;

    task.hangRecoveryInProgress = true;
    try {
      const reason = `Hang detected: no task progress for ${Math.round(
        this.hangInactivityTimeoutMs / 1000,
      )}s`;
      log('[background-manager] attempting hang recovery', {
        taskId: task.id,
        agent: task.agent,
        reason,
      });

      const retried = await this.retryWithNextModel(task, reason);
      if (!retried) {
        task.hangRecoveryEvents = task.hangRecoveryEvents ?? [];
        task.hangRecoveryEvents.push({
          timestamp: Date.now(),
          reason,
          action: 'fallback-exhausted',
        });
        await this.extractAndCompleteTask(task);
        if (task.status === 'running') {
          this.completeTask(
            task,
            'failed',
            `${reason}. No fallback model recovered task.`,
          );
        }
      } else {
        task.hangRecoveryEvents = task.hangRecoveryEvents ?? [];
        task.hangRecoveryEvents.push({
          timestamp: Date.now(),
          reason,
          action: 'fallback-retry-started',
        });
      }
      this.touchTaskActivity(task);
    } finally {
      task.hangRecoveryInProgress = false;
    }
  }

  private normalizeModelChain(chain: Array<string | undefined>): string[] {
    const seen = new Set<string>();
    const valid: string[] = [];

    for (const model of chain) {
      if (!model || seen.has(model)) continue;
      if (!parseModelReference(model)) {
        log(`[fallback] Ignoring invalid model reference in chain: ${model}`);
        continue;
      }
      seen.add(model);
      valid.push(model);
    }

    return valid;
  }

  /**
   * Get the model chain for an agent.
   * Source order:
   * 1) config.agents[agentName].models
   * 2) config.agents[agentName].currentModel
   * 3) config.fallback.chains[agentName] (legacy/CLI compatibility)
   * 4) HARDCODED_DEFAULTS
   */
  private getFullModelChain(agentName: string): string[] {
    const agents = this.config?.agents;
    const chainCandidates: Array<string | undefined> = [];

    if (agents && agents[agentName]) {
      const agentConfig = agents[agentName] as
        | Record<string, unknown>
        | undefined;
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

    // Fall back to HARDCODED_DEFAULTS if nothing in config
    if (chain.length === 0) {
      const defaultModel = HARDCODED_DEFAULTS[agentName];
      if (defaultModel) {
        chain = this.normalizeModelChain([defaultModel]);
      }
    }

    return chain;
  }

  private async resolveFallbackChain(agentName: string): Promise<string[]> {
    const fallback = this.config?.fallback;
    const now = Date.now();

    // Get the full chain
    const chain = this.getFullModelChain(agentName);

    if (chain.length === 0) {
      log(`[fallback] WARNING: No model chain for ${agentName}`);
      return [];
    }

    // Get model health from triage in config
    const triage = fallback?.triage ?? {};
    let triageUpdated = false;

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
          log(
            `[circuit-breaker] Skipping model ${m} (circuit open: ${failureCount} failures)`,
          );
          return false;
        }

        // Allow one probe after cooldown; this is the periodic health check.
        triage[m] = {
          ...health,
          lastChecked: now,
        };
        triageUpdated = true;

        log(
          `[circuit-breaker] Model ${m} cooldown complete, allowing health-check retry`,
        );
      }

      return true;
    });

    // Provider-aware prioritization: providers with recent repeated failures
    // are deprioritized so we fail over across providers sooner.
    const providerPenalty = new Map<string, number>();
    for (const [model, health] of Object.entries(triage)) {
      const parsed = parseModelReference(model);
      if (!parsed) continue;

      const count = (health.failureCount as number) ?? 0;
      const lastFailure = (health.lastFailure as number) ?? 0;
      if (count <= 0 || lastFailure <= 0) continue;

      const ageMs = now - lastFailure;
      if (ageMs > this.CIRCUIT_BREAKER_COOLDOWN_MS) continue;

      providerPenalty.set(
        parsed.providerID,
        (providerPenalty.get(parsed.providerID) ?? 0) + count,
      );
    }

    const providerAwareChain = availableChain
      .map((model, index) => {
        const provider = parseModelReference(model)?.providerID ?? 'unknown';
        return {
          model,
          index,
          penalty: providerPenalty.get(provider) ?? 0,
        };
      })
      .sort((a, b) => a.penalty - b.penalty || a.index - b.index)
      .map((entry) => entry.model);

    if (triageUpdated) {
      void this.persistConfig();
    }

    log(`[fallback] Resolved fallback chain for ${agentName}:`, {
      originalChainLength: chain.length,
      availableChainLength: availableChain.length,
      availableChain: providerAwareChain.slice(0, 3),
      providerPenalty: Object.fromEntries(providerPenalty.entries()),
      triageKeys: Object.keys(triage),
    });

    return providerAwareChain;
  }

  private async recordModelFailure(model: string): Promise<void> {
    if (!this.config?.fallback) {
      log('[circuit-breaker] ERROR: No fallback config found');
      return;
    }

    // Ensure triage exists (it's now the health record itself)
    if (!this.config.fallback.triage) {
      this.config.fallback.triage = {};
    }

    const triage = this.config.fallback.triage;
    const now = Date.now();
    const existingHealth = triage[model] ?? { failureCount: 0 };
    const failureCount = (existingHealth.failureCount ?? 0) + 1;

    triage[model] = {
      ...existingHealth,
      failureCount,
      lastFailure: now,
      lastChecked: now,
    };

    log(`[circuit-breaker] Recorded failure for ${model}`, {
      failureCount,
      threshold: this.CIRCUIT_BREAKER_THRESHOLD,
      willTrip: failureCount >= this.CIRCUIT_BREAKER_THRESHOLD,
      triageList: Object.keys(triage),
    });

    // Persist updated health state (best-effort; do not block task flow)
    void this.persistConfig();
  }

  private async recordModelSuccess(model: string): Promise<void> {
    if (!this.config?.fallback) return;

    // Ensure triage exists (it's now the health record itself)
    if (!this.config.fallback.triage) {
      this.config.fallback.triage = {};
    }

    const triage = this.config.fallback.triage;
    const existingHealth = triage[model];

    // Remove model from triage entirely once it succeeds.
    if (existingHealth) {
      log(`[circuit-breaker] Removing healthy model from triage: ${model}`);
      delete triage[model];

      // Persist updated health state (best-effort; do not block task flow)
      void this.persistConfig();
    }
  }

  /**
   * Detect if an error is a context length error that can be resolved with compaction
   */
  private isContextLengthError(error: unknown): boolean {
    const msg = error instanceof Error ? error.message : String(error);
    return (
      msg.includes('maximum context length') ||
      msg.includes('context limit') ||
      msg.includes('too many tokens') ||
      msg.includes('4096') || // Various context error codes
      msg.includes('400')
    );
  }

  /**
   * Compact the session to reduce context length and retry the prompt
   */
  private async compactAndRetry(
    sessionId: string,
    promptFn: () => Promise<void>,
  ): Promise<void> {
    try {
      log('[compact] Invoking /compact command to reduce context');
      await this.client.session.command({
        path: { id: sessionId },
        body: { command: 'compact', arguments: '' },
      });
      log('[compact] Compaction complete, retrying prompt');
      await promptFn();
    } catch (compactError) {
      log('[compact] Compaction failed:', compactError);
      throw compactError;
    }
  }

  private async promptWithTimeout(
    args: Parameters<OpencodeClient['session']['promptAsync']>[0],
    timeoutMs: number,
  ): Promise<void> {
    await Promise.race([
      this.client.session.promptAsync(args),
      new Promise<never>((_, reject) => {
        setTimeout(() => {
          reject(new Error(`Prompt timed out after ${timeoutMs}ms`));
        }, timeoutMs);
      }),
    ]);
  }

  /**
   * Start a task in the background (Phase B).
   */
  private async startTask(task: BackgroundTask): Promise<void> {
    log(`[background-manager] Starting task ${task.id}`, {
      agent: task.agent,
      parentSession: task.parentSessionId,
      directory: this.directory,
      fallbackEnabled: this.config?.fallback?.enabled,
    });

    task.status = 'starting';
    this.activeStarts++;

    // Check if cancelled after incrementing activeStarts (to catch race)
    // Use type assertion since cancel() can change status during race condition
    if ((task as BackgroundTask & { status: string }).status === 'cancelled') {
      this.completeTask(task, 'cancelled', 'Task cancelled before start');
      return;
    }

    try {
      // Create session
      log(`[background-manager] Creating session for task ${task.id}`, {
        parentID: task.parentSessionId,
        directory: this.directory,
      });

      const session = await this.client.session.create({
        body: {
          parentID: task.parentSessionId,
          title: `Background: ${task.description}`,
        },
        query: { directory: this.directory },
      });

      if (!session.data?.id) {
        throw new Error('Failed to create background session');
      }

      log(`[background-manager] Session created: ${session.data.id}`);

      task.sessionId = session.data.id;
      this.tasksBySessionId.set(session.data.id, task.id);
      // Track the agent type for this session for delegation checks
      this.agentBySessionId.set(session.data.id, task.agent);
      task.status = 'running';
      this.touchTaskActivity(task);

      // Give TmuxSessionManager time to spawn the pane
      if (this.tmuxEnabled) {
        await new Promise((r) => setTimeout(r, 500));
      }

      // Send prompt
      const promptQuery: Record<string, string> = { directory: this.directory };
      const resolvedVariant = resolveAgentVariant(this.config, task.agent);
      const basePromptBody = applyAgentVariant(resolvedVariant, {
        agent: task.agent,
        parts: [{ type: 'text' as const, text: task.prompt }],
      } as PromptBody) as unknown as PromptBody;

      const timeoutMs =
        this.config?.fallback?.timeoutMs ?? FALLBACK_FAILOVER_TIMEOUT_MS;
      const fallbackEnabled = this.config?.fallback?.enabled ?? true;

      // Get the full chain (without circuit breaker filtering)
      const fullChain = this.getFullModelChain(task.agent);
      // Get filtered chain (with circuit breaker)
      const filteredChain = fallbackEnabled
        ? await this.resolveFallbackChain(task.agent)
        : [];

      // Use filtered chain if available, otherwise use full chain (circuit breaker bypassed)
      const chain = filteredChain.length > 0 ? filteredChain : fullChain;
      const attemptModels = chain.length > 0 ? chain : [undefined];

      log(`[fallback] Model chain for ${task.agent}:`, {
        fullChainLength: fullChain.length,
        filteredChainLength: filteredChain.length,
        finalChainLength: attemptModels.length,
        chain: attemptModels,
      });

      // Log circuit breaker status
      if (filteredChain.length === 0 && fullChain.length > 0) {
        log(
          `[fallback] WARNING: All models filtered by circuit breaker, bypassing for task ${task.id}`,
          {
            agent: task.agent,
            fullChainLength: fullChain.length,
          },
        );
      }

      // Initialize fallback tracking
      task.fallbackInfo = {
        occurred: false,
        attempts: [],
        totalAttempts: 0,
      };

      const errors: string[] = [];
      let succeeded = false;
      let attemptCount = 0;

      log(`[fallback] Model chain for ${task.agent}:`, attemptModels);
      log(`[fallback] Starting fallback sequence for task ${task.id}`, {
        agent: task.agent,
        attemptCount: attemptModels.length,
        timeoutMs,
        usingFilteredChain: filteredChain.length > 0,
        modelChain: attemptModels,
      });

      for (const model of attemptModels) {
        attemptCount++;
        const modelLabel = model ?? 'default-model';
        this.touchTaskActivity(task);

        log(
          ` Trying model: ${modelLabel}, attempt: ${attemptCount}/${attemptModels.length}`,
        );

        // Track the current model being used for this agent
        if (model) {
          task.activeModel = model;
          await this.setConfiguredAgentModel(task.agent, model, false);
        }

        // Build the prompt body outside try-catch so it's accessible in catch block
        const body: PromptBody = {
          ...basePromptBody,
          model: undefined,
        };

        if (model) {
          const ref = parseModelReference(model);
          if (!ref) {
            log(` Invalid model format: ${model}, skipping to next`);
            continue;
          }
          body.model = ref;
          log(`Task ${task.id} using model: ${modelLabel}`);
        }

        try {
          log(
            `[fallback] Attempt ${attemptCount}/${attemptModels.length} with model: ${modelLabel}`,
            {
              taskId: task.id,
              agent: task.agent,
            },
          );

          await this.promptWithTimeout(
            {
              path: { id: session.data.id },
              body,
              query: promptQuery,
            },
            timeoutMs,
          );

          // promptAsync returns immediately - completion detected via session.status events
          this.touchTaskActivity(task);

          log(
            `[fallback] SUCCESS: Attempt ${attemptCount} with ${modelLabel}`,
            {
              taskId: task.id,
              agent: task.agent,
              attempts: attemptCount,
            },
          );

          // Record success to reset circuit breaker
          if (model) {
            await this.setConfiguredAgentModel(task.agent, model, true);
            await this.recordModelSuccess(model);
          }

          // Track fallback attempt
          if (task.fallbackInfo && model) {
            task.fallbackInfo.attempts.push({
              model: modelLabel,
              success: true,
              timestamp: Date.now(),
            });
            task.fallbackInfo.successfulModel = modelLabel;
            task.fallbackInfo.totalAttempts = attemptCount;
            task.fallbackInfo.occurred = attemptCount > 1;
          }

          succeeded = true;
          break;
        } catch (error) {
          const msg = error instanceof Error ? error.message : String(error);
          const errorDetail = `${modelLabel}: ${msg}`;
          errors.push(errorDetail);

          log(` ERROR with ${modelLabel}: ${msg}`);

          log(`[fallback] ERROR caught in fallback loop:`, {
            taskId: task.id,
            model: modelLabel,
            error: msg,
            attemptCount,
            totalInChain: attemptModels.length,
          });

          // Check if this is a context length error
          if (this.isContextLengthError(error)) {
            log(
              '[fallback] Context length error detected, attempting compaction',
            );
            try {
              // Try to compact and retry once
              await this.compactAndRetry(session.data.id, async () => {
                await this.promptWithTimeout(
                  {
                    path: { id: session.data.id },
                    body,
                    query: promptQuery,
                  },
                  timeoutMs,
                );
              });
              // If compaction worked, continue to next iteration
              succeeded = true;
              continue;
            } catch {
              // If compaction also fails, log and continue to fallback
              log('[fallback] Compaction failed, trying next model');
            }
          }

          // EVERY error triggers fallback - try next model
          // Record failure for circuit breaker
          if (model) {
            await this.recordModelFailure(model);
          }

          // Track fallback attempt
          if (task.fallbackInfo && model) {
            task.fallbackInfo.attempts.push({
              model: modelLabel,
              success: false,
              error: msg,
              timestamp: Date.now(),
            });
            task.fallbackInfo.totalAttempts = attemptCount;
          }

          log(`[fallback] FAILED: Attempt ${attemptCount} with ${modelLabel}`, {
            taskId: task.id,
            agent: task.agent,
            error: msg,
          });

          // Try next model in chain
          if (attemptCount < attemptModels.length) {
            log(`[fallback] Retrying with next model in chain...`, {
              taskId: task.id,
              agent: task.agent,
              nextAttempt: attemptCount + 1,
            });
          }
        }
      }

      if (!succeeded) {
        const finalError = `All fallback models failed after ${attemptCount} attempts. ${errors.join(' | ')}`;
        log(`[fallback] COMPLETE FAILURE: ${finalError}`, {
          taskId: task.id,
          agent: task.agent,
          totalAttempts: attemptCount,
        });
        throw new Error(finalError);
      }

      log(`[background-manager] task started: ${task.id}`, {
        sessionId: session.data.id,
      });
    } catch (error) {
      log(` Caught error in startTask:`);
      const errorMessage =
        error instanceof Error ? error.message : String(error);
      log(` Error message: ${errorMessage}`);
      this.completeTask(task, 'failed', errorMessage);
    } finally {
      this.activeStarts--;
      this.processQueue();
    }
  }

  /**
   * Handle session.status events for completion detection.
   * Uses session.status instead of deprecated session.idle.
   */
  async handleSessionStatus(event: {
    type: string;
    properties?: { sessionID?: string; status?: { type: string } };
  }): Promise<void> {
    if (event.type !== 'session.status') return;

    const sessionId = event.properties?.sessionID;
    if (!sessionId) return;

    const statusType = event.properties?.status?.type;
    if (statusType) {
      this.sessionStatusById.set(sessionId, statusType);
      const trackedTaskId = this.tasksBySessionId.get(sessionId);
      if (trackedTaskId) {
        const trackedTask = this.tasks.get(trackedTaskId);
        if (trackedTask) {
          this.touchTaskActivity(trackedTask);
        }
      }
      if (statusType === 'idle') {
        await this.flushQueuedNotifications(sessionId);
      }
    }

    const taskId = this.tasksBySessionId.get(sessionId);
    if (!taskId) return;

    const task = this.tasks.get(taskId);
    if (!task || task.status !== 'running') return;

    log(` Session ${sessionId} status: ${event.properties?.status?.type}`);

    // Check if session is idle (completed) or any terminal status
    if (
      statusType === 'idle' ||
      statusType === 'error' ||
      statusType === 'failed' ||
      statusType === 'completed'
    ) {
      log(` Calling extractAndCompleteTask for ${task.id}`);
      await this.extractAndCompleteTask(task);
    }
  }

  /**
   * Check if a session has actual assistant content (not just error messages).
   */
  private async checkSessionHasContent(sessionId: string): Promise<boolean> {
    try {
      const messagesResult = await this.client.session.messages({
        path: { id: sessionId },
      });
      const taskId = this.tasksBySessionId.get(sessionId);
      if (taskId) {
        const task = this.tasks.get(taskId);
        if (task) {
          this.touchTaskActivity(task);
        }
      }
      const messages = (messagesResult.data ?? []) as Array<{
        info?: { role: string };
        parts?: Array<{ type: string; text?: string }>;
      }>;

      // Check for assistant messages with actual content
      const hasAssistantContent = messages.some((m) => {
        if (m.info?.role !== 'assistant') return false;
        return m.parts?.some(
          (p) =>
            (p.type === 'text' || p.type === 'reasoning') &&
            p.text &&
            p.text.length > 0,
        );
      });

      return hasAssistantContent;
    } catch {
      // If we can't check, assume there's content
      return true;
    }
  }

  /**
   * Extract task result and mark complete.
   * If the session contains a provider error (credit, rate limit, etc.) and
   * there are remaining models in the fallback chain, retry with the next model.
   */
  private async extractAndCompleteTask(task: BackgroundTask): Promise<void> {
    if (!task.sessionId) return;

    log(` Starting for task ${task.id}, session ${task.sessionId}`);

    try {
      const messagesResult = await this.client.session.messages({
        path: { id: task.sessionId },
      });
      this.touchTaskActivity(task);
      const messages = (messagesResult.data ?? []) as Array<{
        info?: { role: string; error?: { data?: { message?: string } } };
        parts?: Array<{ type: string; text?: string }>;
      }>;

      log(` Session ${task.sessionId} has ${messages.length} messages`);

      // Log first few messages for debugging
      for (let i = 0; i < Math.min(3, messages.length); i++) {
        const m = messages[i];
        log(` Message ${i}: role=${m.info?.role}, parts=${m.parts?.length}`);
        for (const p of m.parts ?? []) {
          log(`   Part type=${p.type}, textLen=${p.text?.length ?? 0}`);
        }
      }

      // First, try to extract assistant messages
      const assistantMessages = messages.filter(
        (m) => m.info?.role === 'assistant',
      );

      const extractedContent: string[] = [];
      for (const message of assistantMessages) {
        for (const part of message.parts ?? []) {
          // Accept text, reasoning, or any part with text content
          if (
            part.text &&
            (part.type === 'text' || part.type === 'reasoning')
          ) {
            extractedContent.push(part.text);
          }
          // Also check for content field (some models use this)
          if (
            (part as any).content &&
            typeof (part as any).content === 'string'
          ) {
            extractedContent.push((part as any).content);
          }
        }
      }

      const responseText = extractedContent
        .filter((t) => t.length > 0)
        .join('\n\n');

      // If no content extracted, check for error messages in the session
      if (!responseText) {
        // Check for error in message info (e.g., info.error from APIError)
        const errorMessages = messages.filter((m) => {
          // Check info.error for API errors
          const info = m as any;
          if (info.info?.error) {
            return true;
          }
          // Also check parts for error text
          return m.parts?.some(
            (p) =>
              p.text &&
              (p.text.includes('error') ||
                p.text.includes('Error') ||
                p.text.includes('credit') ||
                p.text.includes('rate limit') ||
                p.text.includes('quota') ||
                p.text.includes('Retry Error')),
          );
        });

        if (errorMessages.length > 0) {
          // Extract error message from info.error if available
          const firstErrorMsg = errorMessages[0];
          const info = firstErrorMsg as any;
          let errorText = 'API Error';
          if (info.info?.error?.data?.message) {
            errorText = info.info.error.data.message;
          } else {
            errorText =
              firstErrorMsg.parts?.map((p) => p.text).join(' ') ||
              'Unknown error';
          }

          // Connectivity failures should use immediate retry logic in completeTask()
          // before model triage/fallback to avoid polluting circuit breaker state.
          const isConnectivityFailure = this.isConnectivityError(errorText);

          // Check if this is a provider error that should trigger fallback
          if (!isConnectivityFailure && detectProviderError(errorText)) {
            log(
              `[fallback] Provider error detected in session messages: ${errorText}`,
            );
            const retried = await this.retryWithNextModel(task, errorText);
            if (retried) return; // Retry in progress, don't complete yet
          }

          this.completeTask(task, 'failed', `Model error: ${errorText}`);
          return;
        }
      }

      // If no content extracted, check if there's a successful model
      log(
        ` responseText length: ${responseText?.length || 0}, fallbackInfo:`,
        task.fallbackInfo,
      );
      if (!responseText && task.fallbackInfo) {
        log(
          ` Checking fallback - successfulModel: ${task.fallbackInfo.successfulModel}, totalAttempts: ${task.fallbackInfo.totalAttempts}, occurred: ${task.fallbackInfo.occurred}`,
        );
        if (task.fallbackInfo.successfulModel) {
          // Model succeeded but produced no output - complete successfully
          log(` Model succeeded, completing with no output`);
          this.completeTask(task, 'completed', '(No output)');
          return;
        } else if (task.fallbackInfo.totalAttempts > 0) {
          // Fallback was used but all models failed - mark as failed
          log(` All models failed, completing with error`);
          const errorMsg = task.fallbackInfo.attempts
            .map((a) => `${a.model}: ${a.error || 'unknown error'}`)
            .join('; ');
          this.completeTask(task, 'failed', `All models failed: ${errorMsg}`);
          return;
        }
      }

      if (responseText) {
        // Check if responseText is actually a provider error returned as assistant text
        // (e.g., Gemini quota errors surfaced as "Retry Error\nYou exceeded your current quota...")
        // Gate on specific markers to avoid false positives when an assistant merely discusses quotas.
        const isConnectivityFailure = this.isConnectivityError(responseText);
        const looksLikeProviderError =
          (responseText.includes('Retry Error') ||
            responseText.includes('generativelanguage.googleapis.com') ||
            responseText.includes('exceeded your current quota')) &&
          detectProviderError(responseText);

        if (!isConnectivityFailure && looksLikeProviderError) {
          log(
            `[fallback] Provider error detected in responseText: ${responseText.slice(0, 200)}`,
          );
          const retried = await this.retryWithNextModel(task, responseText);
          if (retried) return; // Retry in progress, don't complete yet
          // If no more models to try, fall through and fail
          this.completeTask(
            task,
            'failed',
            `Provider error: ${responseText.slice(0, 500)}`,
          );
          return;
        }

        this.completeTask(task, 'completed', responseText);
      } else {
        this.completeTask(task, 'completed', '(No output)');
      }
    } catch (error) {
      this.completeTask(
        task,
        'failed',
        error instanceof Error ? error.message : String(error),
      );
    }
  }

  /**
   * Retry a failed task with the next model in the fallback chain.
   * Called when a provider error is detected in session messages (post-promptAsync).
   *
   * @returns true if a retry was initiated, false if no more models available
   */
  private async retryWithNextModel(
    task: BackgroundTask,
    errorText: string,
  ): Promise<boolean> {
    const fallbackEnabled = this.config?.fallback?.enabled ?? true;
    if (!fallbackEnabled) return false;

    const chain = await this.resolveFallbackChain(task.agent);

    const failedModels = new Set(
      (task.fallbackInfo?.attempts ?? [])
        .filter((attempt) => !attempt.success)
        .map((attempt) => attempt.model),
    );

    const currentlyConfigured =
      task.activeModel ?? this.getConfiguredAgentModel(task.agent);
    if (currentlyConfigured) {
      failedModels.add(currentlyConfigured);
    }

    // Start from top of chain each retry; pick first model not already failed.
    const nextModel = chain.find((candidate) => !failedModels.has(candidate));
    if (!nextModel) {
      log(
        `[fallback] No more models in chain for ${task.agent} (tried ${failedModels.size}/${chain.length})`,
      );
      return false;
    }

    const ref = parseModelReference(nextModel);
    if (!ref) {
      log(`[fallback] Invalid model format for retry: ${nextModel}`);
      return false;
    }

    // Record failure for the model that just failed.
    const failedModel =
      task.activeModel ??
      this.getConfiguredAgentModel(task.agent) ??
      (task.fallbackInfo?.attempts ?? [])
        .filter((attempt) => !attempt.success)
        .at(-1)?.model;
    if (failedModel) {
      await this.recordModelFailure(failedModel);
    }

    // Track the failed attempt
    if (task.fallbackInfo) {
      if (failedModel) {
        task.fallbackInfo.attempts.push({
          model: failedModel,
          success: false,
          error: errorText,
          timestamp: Date.now(),
        });
      }
      task.fallbackInfo.totalAttempts =
        (task.fallbackInfo.totalAttempts ?? 0) + 1;
      task.fallbackInfo.occurred = true;
    }

    log(
      `[fallback] Retrying task ${task.id} with next model: ${nextModel} (attempt ${task.fallbackInfo?.totalAttempts ?? 1}/${chain.length})`,
    );
    log(`Task ${task.id} retrying with model: ${nextModel}`);

    // Track the current model for this retry
    task.activeModel = nextModel;
    await this.setConfiguredAgentModel(task.agent, nextModel, false);

    // Reset task status to running for the retry
    task.status = 'running';
    this.touchTaskActivity(task);

    // Create a new session for the retry
    try {
      // Clean up old session tracking
      if (task.sessionId) {
        this.tasksBySessionId.delete(task.sessionId);
        this.agentBySessionId.delete(task.sessionId);
      }

      const session = await this.client.session.create({
        body: {
          parentID: task.parentSessionId,
          title: `Background: ${task.description} (retry ${task.fallbackInfo?.totalAttempts ?? 1})`,
        },
        query: { directory: this.directory },
      });

      if (!session.data?.id) {
        log(`[fallback] Failed to create retry session for task ${task.id}`);
        return false;
      }

      task.sessionId = session.data.id;
      this.tasksBySessionId.set(session.data.id, task.id);
      this.agentBySessionId.set(session.data.id, task.agent);

      const promptQuery: Record<string, string> = { directory: this.directory };
      const resolvedVariant = resolveAgentVariant(this.config, task.agent);
      const basePromptBody = applyAgentVariant(resolved

... (truncated)
```
