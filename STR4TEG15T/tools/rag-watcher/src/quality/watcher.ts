/**
 * Quality Watcher
 * Sampling-based async quality monitoring for document ingestion
 * Part of DECISION_087 Phase 1 - COCO Pillar (Continuous Oversight)
 *
 * Characteristics:
 * - O(1) overhead per document (sampling-based)
 * - 10% default sampling rate
 * - Async quality checks (non-blocking)
 * - Intervention triggers at <70% quality
 * - Target: <5% total overhead on ingestion pipeline
 */

import { logger } from '../logger.js';
import {
  type WatcherQualityConfig,
  type WatcherStats,
  type QualityCheckResult,
  type InterventionEvent,
  DEFAULT_QUALITY_CONFIG,
} from './types.js';
import { runAllChecks, calculateOverallScore } from './checks.js';

/**
 * Quality Watcher class
 * Monitors document quality through sampling-based checks
 */
export class QualityWatcher {
  private config: WatcherQualityConfig;
  private stats: WatcherStats;
  private startTime: number;
  private interventionHandlers: Array<
    (event: InterventionEvent) => void | Promise<void>
  > = [];
  private activeChecks = 0;

  constructor(config?: Partial<WatcherQualityConfig>) {
    this.config = { ...DEFAULT_QUALITY_CONFIG, ...config };
    this.startTime = Date.now();
    this.stats = {
      totalDocumentsProcessed: 0,
      totalDocumentsSampled: 0,
      totalQualityChecksRun: 0,
      averageQualityScore: 0,
      passRate: 0,
      interventionCount: 0,
      uptimeMs: 0,
      overheadPercentage: 0,
    };
  }

  /**
   * Register an intervention handler
   */
  onIntervention(
    handler: (event: InterventionEvent) => void | Promise<void>
  ): void {
    this.interventionHandlers.push(handler);
  }

  /**
   * Should this document be sampled for quality checking?
   * Uses probabilistic sampling at the configured rate.
   */
  shouldSample(): boolean {
    if (!this.config.enabled) return false;
    if (this.activeChecks >= this.config.maxConcurrentChecks) return false;
    return Math.random() < this.config.samplingRate;
  }

  /**
   * Process a document through the quality pipeline
   * This is the main entry point called from the ingestion pipeline.
   *
   * O(1) for non-sampled documents (just increments counter).
   * Full quality check only for sampled documents.
   */
  async processDocument(
    documentId: string,
    filePath: string,
    content: string
  ): Promise<QualityCheckResult | null> {
    this.stats.totalDocumentsProcessed++;

    // Probabilistic sampling - most documents pass through with O(1) cost
    if (!this.shouldSample()) {
      return null; // Not sampled, no quality check performed
    }

    this.stats.totalDocumentsSampled++;
    this.activeChecks++;

    try {
      const result = await this.runQualityCheck(
        documentId,
        filePath,
        content
      );

      // Update rolling average
      this.updateStats(result);

      // Check for intervention
      if (result.interventionRequired) {
        await this.triggerIntervention(result);
      }

      return result;
    } finally {
      this.activeChecks--;
    }
  }

  /**
   * Run quality checks on a document
   */
  private async runQualityCheck(
    documentId: string,
    filePath: string,
    content: string
  ): Promise<QualityCheckResult> {
    const checks = runAllChecks(content);
    const score = calculateOverallScore(checks);
    const passed = score >= this.config.qualityThreshold;
    const interventionRequired =
      score < this.config.interventionThreshold;

    this.stats.totalQualityChecksRun += checks.length;

    const failedCheckNames = checks
      .filter((c) => !c.passed)
      .map((c) => c.name);

    return {
      documentId,
      filePath,
      timestamp: new Date().toISOString(),
      score,
      passed,
      checks,
      interventionRequired,
      interventionReason: interventionRequired
        ? `Quality score ${score} below threshold ${this.config.interventionThreshold}. Failed: ${failedCheckNames.join(', ')}`
        : undefined,
    };
  }

  /**
   * Update running statistics
   */
  private updateStats(result: QualityCheckResult): void {
    const n = this.stats.totalDocumentsSampled;

    // Running average: avg = ((n-1) * avg + new) / n
    this.stats.averageQualityScore =
      Math.round(
        (((n - 1) * this.stats.averageQualityScore + result.score) / n) *
          100
      ) / 100;

    // Pass rate
    const totalPassed =
      Math.round(
        this.stats.passRate * (n - 1) / 100
      ) + (result.passed ? 1 : 0);
    this.stats.passRate =
      Math.round((totalPassed / n) * 10000) / 100;

    this.stats.lastCheckTimestamp = result.timestamp;
    this.stats.uptimeMs = Date.now() - this.startTime;
    this.stats.overheadPercentage =
      Math.round(
        (this.stats.totalDocumentsSampled /
          Math.max(1, this.stats.totalDocumentsProcessed)) *
          10000
      ) / 100;
  }

  /**
   * Trigger intervention for low-quality documents
   */
  private async triggerIntervention(
    result: QualityCheckResult
  ): Promise<void> {
    this.stats.interventionCount++;

    const event: InterventionEvent = {
      documentId: result.documentId,
      filePath: result.filePath,
      timestamp: result.timestamp,
      qualityScore: result.score,
      failedChecks: result.checks
        .filter((c) => !c.passed)
        .map((c) => c.name),
      action: result.score < 0.3 ? 'block' : 'alert',
    };

    logger.warn(
      `Quality intervention triggered for ${result.filePath}`,
      {
        score: result.score,
        action: event.action,
        failedChecks: event.failedChecks,
      }
    );

    // Notify all intervention handlers
    for (const handler of this.interventionHandlers) {
      try {
        await handler(event);
      } catch (error) {
        logger.error('Intervention handler failed', {
          error:
            error instanceof Error ? error.message : String(error),
        });
      }
    }
  }

  /**
   * Get current watcher statistics
   */
  getStats(): WatcherStats {
    return {
      ...this.stats,
      uptimeMs: Date.now() - this.startTime,
    };
  }

  /**
   * Update configuration at runtime
   */
  updateConfig(config: Partial<WatcherQualityConfig>): void {
    this.config = { ...this.config, ...config };
    logger.info('Quality watcher config updated', {
      samplingRate: this.config.samplingRate,
      qualityThreshold: this.config.qualityThreshold,
    });
  }

  /**
   * Force a quality check (bypass sampling)
   */
  async forceCheck(
    documentId: string,
    filePath: string,
    content: string
  ): Promise<QualityCheckResult> {
    this.stats.totalDocumentsProcessed++;
    this.stats.totalDocumentsSampled++;
    this.activeChecks++;

    try {
      const result = await this.runQualityCheck(
        documentId,
        filePath,
        content
      );
      this.updateStats(result);
      if (result.interventionRequired) {
        await this.triggerIntervention(result);
      }
      return result;
    } finally {
      this.activeChecks--;
    }
  }
}
