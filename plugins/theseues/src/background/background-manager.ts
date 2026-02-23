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
  DEFAULT_MODELS,
  FALLBACK_FAILOVER_TIMEOUT_MS,
  SUBAGENT_DELEGATION_RULES,
} from '../config';

import type { TmuxConfig } from '../config/schema';
import { applyAgentVariant, resolveAgentVariant } from '../utils';
import { log } from '../utils/debug';
import {
  BackoffManager,
  ConnectionHealthMonitor,
  ErrorClassifier,
  ErrorType,
  NetworkCircuitBreaker,
  RetryMetrics,
  TaskRestartManager,
} from './resilience';

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
    /generativelanguage\.googleapis\.com/i,
    /cloudaicompanion\.googleapis\.com/i,
    // Permission and forbidden errors
    /403/i,
    /forbidden/i,
    /PERMISSION_DENIED/i,
    /IAM_PERMISSION_DENIED/i,
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
  // Retry configuration for unconditional retries (10 retries, 500ms delay)
  private MAX_MODEL_RETRIES = 10; // Number of retries per model before fallback
  private RETRY_DELAY_MS = 500; // Delay between retries in milliseconds
  private readonly STATUS_POLL_INTERVAL_MS = 5000;
  private hangInactivityTimeoutMs = 300000;
  private statusPollTimer?: ReturnType<typeof setInterval>;

  // ── Resilience Layer (DECISION_037) ──────────────────────────
  private errorClassifier = new ErrorClassifier();
  private backoffManager = new BackoffManager();
  private networkCircuitBreaker = new NetworkCircuitBreaker();
  private connectionHealthMonitor = new ConnectionHealthMonitor();
  private taskRestartManager = new TaskRestartManager();
  private retryMetrics = new RetryMetrics();

  private isConnectivityError(message: string): boolean {
    return /unable\s*to\s*connect|access\s+the\s+url|unable\s+to\s+access\s+url|network\s*error|connection\s*error|econnrefused|econnreset|enotfound|timeout|typo\s+in\s+the\s+url\s+or\s+port/i.test(
      message,
    );
  }

  /**
   * Detect if an error is permanent and should not be retried
   * These errors will skip retries and go directly to fallback
   */
  private isPermanentError(errorMessage: string): boolean {
    const permanentErrorPatterns = [
      /401\s*unauthorized/i,
      /403\s*forbidden/i,
      /forbidden/i,
      /PERMISSION_DENIED/i,
      /invalid.*api.*key/i,
      /api.*key.*invalid/i,
      /authentication.*failed/i,
      /unauthorized.*access/i,
      /invalid.*model/i,
      /model.*not.*found/i,
      /unknown.*model/i,
      /model.*not.*available/i,
      /invalid.*prompt/i,
      /prompt.*parse.*error/i,
      /bad.*request/i,
      /400\s*bad/i,
    ];
    return permanentErrorPatterns.some((pattern) => pattern.test(errorMessage));
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

    // Configure retry settings (allow override for testing)
    if (config?.background?.maxModelRetries !== undefined) {
      this.MAX_MODEL_RETRIES = config.background.maxModelRetries;
    }
    if (config?.background?.retryDelayMs !== undefined) {
      this.RETRY_DELAY_MS = config.background.retryDelayMs;
    }

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
   * CRITICAL: This method MUST preserve existing config data and only update
   * specific fields (triage, currentModel). Never overwrite the entire file.
   */
  private async persistConfig(): Promise<void> {
    if (!this.config) return;

    // Safety check: don't persist empty configs (prevents config deletion bug)
    // Empty object can occur when config fails to parse and defaults to {}
    const hasContent = Object.keys(this.config).length > 0;
    const hasAgents =
      this.config.agents && Object.keys(this.config.agents).length > 0;
    const hasPresets =
      this.config.presets && Object.keys(this.config.presets).length > 0;
    const hasFallback =
      this.config.fallback && Object.keys(this.config.fallback).length > 0;

    // More strict check: must have agents OR presets OR fallback with content
    if (!hasContent || (!hasAgents && !hasPresets && !hasFallback)) {
      log('[config] WARNING: Refusing to persist empty or invalid config', {
        hasContent,
        hasAgents,
        hasPresets,
        hasFallback,
      });
      return;
    }

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

      // CRITICAL FIX: Read existing config file first to ensure we merge, not overwrite
      let existingConfig: Record<string, unknown> = {};
      try {
        const existingContent = await fs.readFile(configPath, 'utf-8');
        existingConfig = JSON.parse(existingContent) as Record<string, unknown>;
        log('[config] Read existing config for merging');
      } catch (readError) {
        log(
          '[config] WARNING: Could not read existing config, using in-memory config only',
        );
      }

      // Validate existing config has meaningful data before merging
      const existingHasAgents =
        existingConfig.agents &&
        Object.keys(existingConfig.agents as Record<string, unknown>).length >
          0;
      const existingHasFallback =
        existingConfig.fallback &&
        Object.keys(existingConfig.fallback as Record<string, unknown>).length >
          0;

      if (!existingHasAgents && !existingHasFallback && hasAgents) {
        log(
          '[config] WARNING: Existing config appears empty but in-memory has data',
        );
      }

      // Merge strategy: Preserve existing config and only update specific fields
      const mergedConfig: Record<string, unknown> = { ...existingConfig };

      // Only update triage data in fallback - never replace the entire fallback object
      if (this.config.fallback?.triage) {
        if (
          !mergedConfig.fallback ||
          typeof mergedConfig.fallback !== 'object'
        ) {
          mergedConfig.fallback = {};
        }
        (mergedConfig.fallback as Record<string, unknown>).triage =
          this.config.fallback.triage;
        log('[config] Merged triage data into existing config');
      }

      // Only update currentModel for agents - preserve all other agent properties
      if (this.config.agents) {
        if (!mergedConfig.agents || typeof mergedConfig.agents !== 'object') {
          mergedConfig.agents = {};
        }
        const existingAgents = mergedConfig.agents as Record<
          string,
          Record<string, unknown>
        >;
        const memoryAgents = this.config.agents as Record<
          string,
          Record<string, unknown>
        >;

        for (const [agentName, agentConfig] of Object.entries(memoryAgents)) {
          if (agentConfig?.currentModel) {
            if (!existingAgents[agentName]) {
              existingAgents[agentName] = {};
            }
            // Only update currentModel, preserve all other properties
            existingAgents[agentName].currentModel = agentConfig.currentModel;
            log(`[config] Updated currentModel for ${agentName}`);
          }
        }
      }

      // CRITICAL: Verify merged config is valid before writing
      const mergedHasAgents =
        mergedConfig.agents &&
        Object.keys(mergedConfig.agents as Record<string, unknown>).length > 0;
      const mergedHasFallback =
        mergedConfig.fallback &&
        Object.keys(mergedConfig.fallback as Record<string, unknown>).length >
          0;

      if (!mergedHasAgents && !mergedHasFallback) {
        log(
          '[config] ERROR: Merged config would be empty, aborting write to prevent data loss',
        );
        return;
      }

      // Create backup before writing
      const backupPath = `${configPath}.backup.${Date.now()}.json`;
      try {
        await fs.copyFile(configPath, backupPath);
        log('[config] Created backup at:', backupPath);
      } catch (backupError) {
        log('[config] WARNING: Could not create backup:', backupError);
      }

      // Write merged config
      await fs.writeFile(
        configPath,
        JSON.stringify(mergedConfig, null, 2),
        'utf-8',
      );
      log(
        '[config] Persisted model health state to config file (merged safely)',
      );
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

        // ── Resilience: check network circuit breaker (DECISION_037) ──
        if (!this.networkCircuitBreaker.canAttempt(modelLabel)) {
          log(
            `[fallback] Network circuit breaker OPEN for ${modelLabel}, skipping`,
          );
          continue;
        }

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

        // Initialize retry counter for this model
        let modelRetryCount = 0;
        let modelSucceeded = false;

        while (modelRetryCount < this.MAX_MODEL_RETRIES && !modelSucceeded) {
          modelRetryCount++;

          try {
            log(
              `[fallback] Attempt ${attemptCount}.${modelRetryCount}/${attemptModels.length} with model: ${modelLabel}`,
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
              `[fallback] SUCCESS: Attempt ${attemptCount}.${modelRetryCount} with ${modelLabel}`,
              {
                taskId: task.id,
                agent: task.agent,
                attempts: attemptCount,
              },
            );

            // Record success to reset circuit breaker
            // Note: This marks the model as "healthy" (prompt was accepted by provider)
            // Task completion success is tracked separately via fallbackInfo.successfulModel
            if (model) {
              await this.setConfiguredAgentModel(task.agent, model, true);
              await this.recordModelSuccess(model);
            }

            // ── Resilience: record success (DECISION_037) ──────
            this.networkCircuitBreaker.recordSuccess(modelLabel);
            this.backoffManager.reset(`${task.id}:${modelLabel}`);
            if (task.sessionId) {
              this.connectionHealthMonitor.recordSuccess(task.sessionId);
            }
            this.retryMetrics.recordRetry({
              taskId: task.id,
              errorType: ErrorType.NetworkTransient, // success — type doesn't matter
              model: modelLabel,
              attempt: modelRetryCount,
              delayMs: 0,
              succeeded: true,
            });

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

            modelSucceeded = true;
            break; // Exit retry loop on success
          } catch (error) {
            const msg = error instanceof Error ? error.message : String(error);
            const errorDetail = `${modelLabel}: ${msg}`;
            errors.push(errorDetail);

            log(` ERROR with ${modelLabel}: ${msg}`);

            // ── Resilience: classify error (DECISION_037) ──────
            const classifiedType = this.errorClassifier.classify(error);
            const isProviderError = detectProviderError(msg);
            const backoffKey = `${task.id}:${modelLabel}`;

            log(`[fallback] ERROR caught in fallback loop:`, {
              taskId: task.id,
              model: modelLabel,
              error: msg,
              attemptCount,
              modelRetryCount,
              totalInChain: attemptModels.length,
              isProviderError,
              classifiedType,
              willRetry: modelRetryCount < this.MAX_MODEL_RETRIES,
            });

            // Record connection failure for health monitoring
            if (task.sessionId) {
              this.connectionHealthMonitor.recordFailure(task.sessionId);
            }

            // Record network circuit breaker failure for network errors
            if (
              classifiedType === ErrorType.NetworkTransient ||
              classifiedType === ErrorType.NetworkPermanent
            ) {
              this.networkCircuitBreaker.recordFailure(modelLabel);
            }

            // ── Permanent errors: skip retries immediately ─────
            if (this.errorClassifier.isPermanent(classifiedType)) {
              log(
                `[fallback] Permanent error (${classifiedType}), skipping retries: ${msg}`,
              );
              if (model) {
                await this.recordModelFailure(model);
              }
              if (task.fallbackInfo && model) {
                task.fallbackInfo.attempts.push({
                  model: modelLabel,
                  success: false,
                  error: `Permanent error (${classifiedType}): ${msg}`,
                  timestamp: Date.now(),
                });
                task.fallbackInfo.totalAttempts = attemptCount;
              }
              this.retryMetrics.recordRetry({
                taskId: task.id,
                errorType: classifiedType,
                model: modelLabel,
                attempt: modelRetryCount,
                delayMs: 0,
                succeeded: false,
              });
              break; // Exit retry loop, move to next model
            }

            // ── Context length: compact and retry ──────────────
            if (this.errorClassifier.shouldCompact(classifiedType)) {
              log(
                '[fallback] Context length error detected, attempting compaction',
              );
              try {
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
                modelSucceeded = true;
                this.retryMetrics.recordRetry({
                  taskId: task.id,
                  errorType: classifiedType,
                  model: modelLabel,
                  attempt: modelRetryCount,
                  delayMs: 0,
                  succeeded: true,
                });
                break;
              } catch {
                log('[fallback] Compaction failed, trying next model');
              }
            }

            // ── Provider errors: skip to next model immediately ─
            if (this.errorClassifier.shouldFallbackToNextModel(classifiedType)) {
              log(
                `[fallback] Provider error (${classifiedType}), falling back to next model`,
              );
              if (model) {
                await this.recordModelFailure(model);
              }
              if (task.fallbackInfo && model) {
                task.fallbackInfo.attempts.push({
                  model: modelLabel,
                  success: false,
                  error: `Provider error (immediate fallback): ${msg}`,
                  timestamp: Date.now(),
                });
                task.fallbackInfo.totalAttempts = attemptCount;
              }
              this.retryMetrics.recordRetry({
                taskId: task.id,
                errorType: classifiedType,
                model: modelLabel,
                attempt: modelRetryCount,
                delayMs: 0,
                succeeded: false,
              });
              break; // Exit retry loop, move to next model
            }

            // ── Network transient / rate limit: backoff retry ──
            if (this.errorClassifier.shouldRetrySameModel(classifiedType)) {
              const canRetry = await this.backoffManager.wait(
                classifiedType,
                backoffKey,
              );

              if (canRetry) {
                const attemptNum = this.backoffManager.getAttemptCount(backoffKey);
                log(
                  `[fallback] Backoff retry ${attemptNum} for ${modelLabel} (${classifiedType})`,
                );
                this.retryMetrics.recordRetry({
                  taskId: task.id,
                  errorType: classifiedType,
                  model: modelLabel,
                  attempt: modelRetryCount,
                  delayMs: 0, // delay already applied by backoffManager.wait()
                  succeeded: false,
                });
                // Continue the while loop — modelRetryCount will increment
                continue;
              }
              // Backoff exhausted — fall through to legacy retry / failure
              log(
                `[fallback] Backoff exhausted for ${modelLabel} (${classifiedType}), checking legacy retries`,
              );
            }

            // ── Legacy fallback: fixed delay retry ─────────────
            if (modelRetryCount < this.MAX_MODEL_RETRIES) {
              log(
                `[fallback] Waiting ${this.RETRY_DELAY_MS}ms before retry ${modelRetryCount + 1}/${this.MAX_MODEL_RETRIES}`,
              );
              await new Promise((resolve) =>
                setTimeout(resolve, this.RETRY_DELAY_MS),
              );
              this.retryMetrics.recordRetry({
                taskId: task.id,
                errorType: classifiedType,
                model: modelLabel,
                attempt: modelRetryCount,
                delayMs: this.RETRY_DELAY_MS,
                succeeded: false,
              });
            } else {
              // All retries exhausted - record failure and move to next model
              log(
                `[fallback] All ${this.MAX_MODEL_RETRIES} retries exhausted for ${modelLabel}`,
              );

              if (model) {
                await this.recordModelFailure(model);
              }

              if (task.fallbackInfo && model) {
                task.fallbackInfo.attempts.push({
                  model: modelLabel,
                  success: false,
                  error: `Failed after ${this.MAX_MODEL_RETRIES} retries: ${msg}`,
                  timestamp: Date.now(),
                });
                task.fallbackInfo.totalAttempts = attemptCount;
              }

              this.retryMetrics.recordRetry({
                taskId: task.id,
                errorType: classifiedType,
                model: modelLabel,
                attempt: modelRetryCount,
                delayMs: 0,
                succeeded: false,
              });

              // Reset backoff counter for this model
              this.backoffManager.reset(backoffKey);

              log(
                `[fallback] FAILED: Attempt ${attemptCount} with ${modelLabel} after ${this.MAX_MODEL_RETRIES} retries`,
                {
                  taskId: task.id,
                  agent: task.agent,
                  error: msg,
                },
              );
            }
          }
        }

        if (modelSucceeded) {
          succeeded = true;
          break; // Exit model chain loop
        }

        // Try next model in chain
        if (attemptCount < attemptModels.length) {
          log(`[fallback] Retrying with next model in chain...`, {
            taskId: task.id,
            agent: task.agent,
            nextAttempt: attemptCount + 1,
          });
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
                p.text.includes('forbidden') ||
                p.text.includes('Forbidden') ||
                p.text.includes('403') ||
                p.text.includes('PERMISSION_DENIED') ||
                p.text.includes('credit') ||
                p.text.includes('rate limit') ||
                p.text.includes('quota') ||
                p.text.includes('Retry Error')),
          );
        });

        log(
          `[fallback] Checking for errors: responseText="${responseText?.slice(0, 50)}", errorMessages.length=${errorMessages.length}`,
        );

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

          // Retry with next model on any error (removed detectProviderError filtering)
          // Log analytics for tracking
          if (!isConnectivityFailure) {
            const isProviderError = detectProviderError(errorText);
            log(`[fallback] Retrying with next model after error`, {
              isProviderError,
              error: errorText.slice(0, 200),
            });
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
        // Check if responseText is actually an error returned as assistant text
        // (e.g., Gemini quota errors surfaced as "Retry Error\nYou exceeded your current quota...")
        // Gate on specific markers to avoid false positives when an assistant merely discusses quotas.
        const isConnectivityFailure = this.isConnectivityError(responseText);

        // Also check for JSON error responses (e.g., {"error": {"code": 403...}} or [{"error":...}])
        // Also handles "Forbidden: [{...}]" format
        let looksLikeJsonError = false;
        try {
          // Strip common prefixes like "Forbidden: " before parsing
          const trimmed = responseText.trim();
          const jsonStart = trimmed.search(/[[{]/);
          if (jsonStart >= 0) {
            const jsonPart = trimmed.slice(jsonStart);
            const parsed = JSON.parse(jsonPart);
            // Check for array of errors or single error object
            const errorArray = Array.isArray(parsed) ? parsed : [parsed];
            for (const item of errorArray) {
              if (item.error?.code || item.error?.status) {
                looksLikeJsonError = true;
                log(`[fallback] Detected JSON error response:`, item.error);
                break;
              }
            }
          }
        } catch {
          // Not JSON, ignore
        }

        const looksLikeError =
          responseText.includes('Retry Error') ||
          responseText.includes('generativelanguage.googleapis.com') ||
          responseText.includes('cloudaicompanion.googleapis.com') ||
          responseText.includes('exceeded your current quota') ||
          responseText.toLowerCase().includes('forbidden') ||
          responseText.includes('403') ||
          responseText.includes('PERMISSION_DENIED') ||
          looksLikeJsonError;

        log(`[fallback] Checking responseText for errors:`, {
          hasText: !!responseText,
          length: responseText?.length,
          startsWithForbidden: responseText.startsWith('Forbidden'),
          includesForbidden: responseText.includes('forbidden'),
          includes403: responseText.includes('403'),
          looksLikeJsonError,
          looksLikeError,
        });

        if (!isConnectivityFailure && looksLikeError) {
          // Log analytics using detectProviderError for tracking
          const isProviderError = detectProviderError(responseText);
          log(`[fallback] Error detected in responseText, retrying`, {
            isProviderError,
            text: responseText.slice(0, 200),
          });
          const retried = await this.retryWithNextModel(task, responseText);
          if (retried) return; // Retry in progress, don't complete yet
          // If no more models to try, fall through and fail
          this.completeTask(
            task,
            'failed',
            `Model error: ${responseText.slice(0, 500)}`,
          );
          return;
        }

        const retried = await this.retryWithNextModel(
          task,
          responseText || 'No output',
        );
        if (retried) return; // Retry in progress, don't complete yet
        // If no more models to try, fall through and complete with no output
        this.completeTask(task, 'completed', responseText || '(No output)');
      } else {
        // No responseText - treat as failure and retry with next model
        const retried = await this.retryWithNextModel(
          task,
          'No output from model',
        );
        if (retried) return; // Retry in progress, don't complete yet
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
      const basePromptBody = applyAgentVariant(resolvedVariant, {
        agent: task.agent,
        parts: [{ type: 'text' as const, text: task.prompt }],
      } as PromptBody) as unknown as PromptBody;

      const body: PromptBody = {
        ...basePromptBody,
        model: ref,
      };

      const timeoutMs =
        this.config?.fallback?.timeoutMs ?? FALLBACK_FAILOVER_TIMEOUT_MS;

      await this.promptWithTimeout(
        {
          path: { id: session.data.id },
          body,
          query: promptQuery,
        },
        timeoutMs,
      );

      // Track success attempt (will be confirmed when session completes)
      if (task.fallbackInfo) {
        task.fallbackInfo.attempts.push({
          model: nextModel,
          success: true,
          timestamp: Date.now(),
        });
        task.fallbackInfo.successfulModel = nextModel;
      }

      await this.setConfiguredAgentModel(task.agent, nextModel, true);
      await this.recordModelSuccess(nextModel);
      return true;
    } catch (retryError) {
      const msg =
        retryError instanceof Error ? retryError.message : String(retryError);
      log(`[fallback] Retry with ${nextModel} also failed: ${msg}`);

      if (task.fallbackInfo) {
        task.fallbackInfo.attempts.push({
          model: nextModel,
          success: false,
          error: msg,
          timestamp: Date.now(),
        });
      }

      await this.recordModelFailure(nextModel);

      // Recursively try the next model
      return this.retryWithNextModel(task, msg);
    }
  }

  /**
   * Complete a task and notify waiting callers.
   */
  private completeTask(
    task: BackgroundTask,
    status: 'completed' | 'failed' | 'cancelled',
    resultOrError: string,
  ): void {
    log(
      ` completeTask: ${task.id}, status: ${status}, error: ${resultOrError}`,
    );
    // Don't check for 'cancelled' here - cancel() may set status before calling
    if (task.status === 'completed' || task.status === 'failed') {
      log(` Task already completed/failed, returning early`);
      return; // Already completed
    }

    // Immediate retries for transient connectivity failures.
    if (
      status === 'failed' &&
      (task.connectivityRetryCount ?? 0) < this.MAX_CONNECTIVITY_RETRIES &&
      this.isConnectivityError(resultOrError)
    ) {
      task.connectivityRetryCount = (task.connectivityRetryCount ?? 0) + 1;
      const retryNumber = task.connectivityRetryCount;

      if (task.sessionId) {
        this.tasksBySessionId.delete(task.sessionId);
        this.agentBySessionId.delete(task.sessionId);
      }

      task.sessionId = undefined;
      task.status = 'pending';
      task.error = undefined;
      task.result = undefined;

      log(`[background-manager] Immediate retry after connectivity failure`, {
        taskId: task.id,
        description: task.description,
        retryNumber,
        maxRetries: this.MAX_CONNECTIVITY_RETRIES,
      });

      this.client.tui
        .showToast({
          body: {
            title: `Retrying: ${task.description}`,
            message: `Model connection failed (${retryNumber}/${this.MAX_CONNECTIVITY_RETRIES}). Retrying prompt now.`,
            variant: 'warning',
            duration: 4000,
          },
        })
        .catch(() => {});

      this.enqueueStart(task);
      return;
    }

    task.status = status;
    task.completedAt = new Date();

    if (status === 'completed') {
      task.result = resultOrError;
    } else {
      task.error = resultOrError;
    }

    this.sendUrgentToast(task).catch((err) => {
      const msg = err instanceof Error ? err.message : String(err);
      log('[background-manager] urgent toast failed', {
        taskId: task.id,
        status,
        error: msg,
      });
    });

    // Clean up session tracking maps to prevent memory leak
    if (task.sessionId) {
      this.tasksBySessionId.delete(task.sessionId);
      this.agentBySessionId.delete(task.sessionId);
    }

    // Queue notification for parent session (flushes on parent idle)
    if (task.parentSessionId) {
      this.queueCompletionNotification(task);
    }

    // Resolve waiting callers
    const resolver = this.completionResolvers.get(task.id);
    if (resolver) {
      resolver(task);
      this.completionResolvers.delete(task.id);
    }

    log(`[background-manager] task ${status}: ${task.id}`, {
      description: task.description,
    });

    if (!this.hasActiveTasks()) {
      this.stopStatusPolling();
    }
  }

  /**
   * Build completion notification text for parent session delivery.
   */
  private buildCompletionNotificationMessage(task: BackgroundTask): string {
    let message: string;

    if (task.status === 'completed') {
      message = `[Background task "${task.description}" completed]\n\n${task.result || '(No output)'}`;

      // Add fallback notice if fallback occurred
      if (task.fallbackInfo?.occurred && task.fallbackInfo.successfulModel) {
        message += `\n\nSubagent ${task.agent} required model fallback, but succeeded on ${task.fallbackInfo.successfulModel}. Minor inconvenience, continuing normally.`;
      }
    } else if (task.status === 'cancelled') {
      const reason = task.error || 'Cancelled by user';
      message = `[Background task "${task.description}" cancelled: ${reason}]`;
    } else {
      message = `[Background task "${task.description}" failed: ${task.error}]`;

      // Add fallback details if task failed during fallback
      if (
        task.fallbackInfo?.totalAttempts &&
        task.fallbackInfo.totalAttempts > 1
      ) {
        message += ` (tried ${task.fallbackInfo.totalAttempts} model${task.fallbackInfo.totalAttempts > 1 ? 's' : ''})`;
      }
    }

    return message;
  }

  private queueCompletionNotification(task: BackgroundTask): void {
    if (!task.parentSessionId) return;

    const message = this.buildCompletionNotificationMessage(task);
    const queue = this.queuedNotifications.get(task.parentSessionId) ?? [];
    const urgent = task.status === 'completed' || task.status === 'failed';
    queue.push({ message, urgent });
    this.queuedNotifications.set(task.parentSessionId, queue);

    this.flushQueuedNotifications(task.parentSessionId).catch((err) => {
      const msg = err instanceof Error ? err.message : String(err);
      log('[background-manager] Failed to flush queued notification', {
        parentSessionId: task.parentSessionId,
        taskId: task.id,
        error: msg,
      });
    });
  }

  private buildUrgentToastMessage(task: BackgroundTask): {
    title: string;
    message: string;
    variant: 'success' | 'error' | 'warning';
  } {
    const normalize = (value: string): string =>
      value.replace(/\s+/g, ' ').trim();

    const truncate = (value: string, max = 220): string => {
      if (value.length <= max) return value;
      return `${value.slice(0, Math.max(0, max - 3))}...`;
    };

    if (task.status === 'completed') {
      const result = task.result ? normalize(task.result) : '(No output)';
      return {
        title: `Background complete: ${task.description}`,
        message: truncate(result),
        variant: 'success',
      };
    }

    if (task.status === 'failed') {
      const error = task.error ? normalize(task.error) : 'Unknown error';
      return {
        title: `Background failed: ${task.description}`,
        message: truncate(error),
        variant: 'error',
      };
    }

    const reason = task.error ? normalize(task.error) : 'Task cancelled.';
    return {
      title: `Background cancelled: ${task.description}`,
      message: truncate(reason),
      variant: 'warning',
    };
  }

  private async sendUrgentToast(task: BackgroundTask): Promise<void> {
    const toast = this.buildUrgentToastMessage(task);

    await this.client.tui.showToast({
      body: {
        title: toast.title,
        message: toast.message,
        variant: toast.variant,
        duration: 15000,
      },
    });
  }

  private async flushQueuedNotifications(
    parentSessionId: string,
  ): Promise<void> {
    if (this.flushingNotifications.has(parentSessionId)) return;

    const queue = this.queuedNotifications.get(parentSessionId);
    if (!queue || queue.length === 0) return;

    const next = queue[0];
    if (!next) return;

    const status = this.sessionStatusById.get(parentSessionId);
    // Urgent notifications (completions/failures) bypass the idle check
    // so they appear in the chat even if the agent is busy polling.
    if (status !== 'idle' && !next.urgent) return;

    this.flushingNotifications.add(parentSessionId);

    try {
      // Send exactly one notification per cycle.
      // Once submitted, the parent session becomes busy and we'll flush the next
      // message on the next `session.status = idle` event (or next urgent trigger).
      await this.client.session.promptAsync({
        path: { id: parentSessionId },
        body: {
          parts: [{ type: 'text' as const, text: next.message }],
        },
      });

      queue.shift();
      if (queue.length === 0) {
        this.queuedNotifications.delete(parentSessionId);
      }
    } finally {
      this.flushingNotifications.delete(parentSessionId);
    }
  }

  /**
   * Retrieve the current state of a background task.
   *
   * @param taskId - The task ID to retrieve
   * @returns The task object, or null if not found
   */
  getResult(taskId: string): BackgroundTask | null {
    return this.tasks.get(taskId) ?? null;
  }

  getTaskTelemetry(taskId: string): {
    sessionStatus?: string;
    activeModel?: string;
    fallbackAttempts: number;
    lastActivityAgoMs?: number;
  } | null {
    const task = this.tasks.get(taskId);
    if (!task) return null;

    const now = Date.now();
    const lastActivityTs = task.lastActivityAt ?? task.startedAt.getTime();

    return {
      sessionStatus: task.sessionId
        ? this.sessionStatusById.get(task.sessionId)
        : undefined,
      activeModel: task.activeModel,
      fallbackAttempts: task.fallbackInfo?.totalAttempts ?? 0,
      lastActivityAgoMs: now - lastActivityTs,
    };
  }

  getActiveTasks(taskId?: string): BackgroundTask[] {
    const targets = taskId
      ? [this.tasks.get(taskId)].filter(Boolean)
      : Array.from(this.tasks.values());

    return (targets as BackgroundTask[]).filter(
      (task) =>
        task.status === 'pending' ||
        task.status === 'starting' ||
        task.status === 'running',
    );
  }

  getCancellationPreview(taskId?: string): Array<{
    taskId: string;
    agent: string;
    status: string;
    sessionId?: string;
    sessionStatus?: string;
    runtimeMs: number;
    attempts: number;
    successfulModel?: string;
    recentError?: string;
    recentResult?: string;
  }> {
    const now = Date.now();
    return this.getActiveTasks(taskId).map((task) => {
      const lastAttempt = (task.fallbackInfo?.attempts ?? []).at(-1);
      const runtimeMs = now - task.startedAt.getTime();
      return {
        taskId: task.id,
        agent: task.agent,
        status: task.status,
        sessionId: task.sessionId,
        sessionStatus: task.sessionId
          ? this.sessionStatusById.get(task.sessionId)
          : undefined,
        runtimeMs,
        attempts: task.fallbackInfo?.totalAttempts ?? 0,
        successfulModel: task.fallbackInfo?.successfulModel,
        recentError: task.error ?? lastAttempt?.error,
        recentResult: task.result?.slice(0, 200),
      };
    });
  }

  async cancelWithExtraction(
    taskId?: string,
    reason: string = 'Cancelled by user',
  ): Promise<{ cancelled: number; salvaged: number; targeted: number }> {
    const candidates = this.getActiveTasks(taskId);
    let salvaged = 0;

    for (const task of candidates) {
      if (task.status !== 'running' || !task.sessionId) continue;

      try {
        await this.extractAndCompleteTask(task);
      } catch {
        // Best effort: continue to cancellation path below.
      }

      const currentStatus = this.getResult(task.id)?.status;
      if (
        currentStatus === 'completed' ||
        currentStatus === 'failed' ||
        currentStatus === 'cancelled'
      ) {
        salvaged++;
      }
    }

    const cancelled = this.cancel(taskId, reason);
    return {
      cancelled,
      salvaged,
      targeted: candidates.length,
    };
  }

  /**
   * Returns true if any background tasks are pending/starting/running.
   *
   * Note: completed/failed/cancelled tasks remain in the tasks map for
   * inspection; this helper filters them out.
   */
  hasActiveTasks(): boolean {
    if (this.activeStarts > 0) return true;
    if (this.startQueue.length > 0) return true;

    for (const task of this.tasks.values()) {
      if (
        task.status === 'pending' ||
        task.status === 'starting' ||
        task.status === 'running'
      ) {
        return true;
      }
    }

    return false;
  }

  /**
   * Wait for a task to complete.
   *
   * @param taskId - The task ID to wait for
   * @param timeout - Maximum time to wait in milliseconds (0 = no timeout)
   * @returns The completed task, or null if not found/timeout
   */
  async waitForCompletion(
    taskId: string,
    timeout = 0,
  ): Promise<BackgroundTask | null> {
    const task = this.tasks.get(taskId);
    if (!task) return null;

    if (
      task.status === 'completed' ||
      task.status === 'failed' ||
      task.status === 'cancelled'
    ) {
      return task;
    }

    return new Promise((resolve) => {
      const resolver = (t: BackgroundTask) => resolve(t);
      this.completionResolvers.set(taskId, resolver);

      if (timeout > 0) {
        setTimeout(() => {
          this.completionResolvers.delete(taskId);
          resolve(this.tasks.get(taskId) ?? null);
        }, timeout);
      }
    });
  }

  /**
   * Cancel one or all running background tasks.
   *
   * @param taskId - Optional task ID to cancel. If omitted, cancels all pending/running tasks.
   * @returns Number of tasks cancelled
   */
  cancel(taskId?: string, reason: string = 'Cancelled by user'): number {
    log('[background-manager] cancel requested', {
      taskId: taskId ?? 'ALL',
      reason,
    });

    if (taskId) {
      const task = this.tasks.get(taskId);
      if (
        task &&
        (task.status === 'pending' ||
          task.status === 'starting' ||
          task.status === 'running')
      ) {
        // Clean up any waiting resolver
        this.completionResolvers.delete(taskId);

        // Check if in start queue (must check before marking cancelled)
        const inStartQueue = task.status === 'pending';

        // Mark as cancelled FIRST to prevent race with startTask
        // Use type assertion since we're deliberately changing status before completeTask
        (task as BackgroundTask & { status: string }).status = 'cancelled';

        // Remove from start queue if pending
        if (inStartQueue) {
          const idx = this.startQueue.findIndex((t) => t.id === taskId);
          if (idx >= 0) {
            this.startQueue.splice(idx, 1);
          }
        }

        this.completeTask(task, 'cancelled', reason);
        return 1;
      }
      return 0;
    }

    let count = 0;
    for (const task of this.tasks.values()) {
      if (
        task.status === 'pending' ||
        task.status === 'starting' ||
        task.status === 'running'
      ) {
        // Clean up any waiting resolver
        this.completionResolvers.delete(task.id);

        // Check if in start queue (must check before marking cancelled)
        const inStartQueue = task.status === 'pending';

        // Mark as cancelled FIRST to prevent race with startTask
        // Use type assertion since we're deliberately changing status before completeTask
        (task as BackgroundTask & { status: string }).status = 'cancelled';

        // Remove from start queue if pending
        if (inStartQueue) {
          const idx = this.startQueue.findIndex((t) => t.id === task.id);
          if (idx >= 0) {
            this.startQueue.splice(idx, 1);
          }
        }

        this.completeTask(task, 'cancelled', reason);
        count++;
      }
    }
    return count;
  }

  /**
   * Clean up all tasks.
   */
  cleanup(): void {
    this.stopStatusPolling();
    this.startQueue = [];
    this.completionResolvers.clear();
    this.tasks.clear();
    this.tasksBySessionId.clear();
    this.agentBySessionId.clear();
    this.queuedNotifications.clear();
    this.flushingNotifications.clear();
    this.sessionStatusById.clear();
  }
}
