/**
 * Types for the Quality Watcher
 * Part of DECISION_087 Phase 1 - COCO Pillar (Continuous Oversight)
 *
 * O(1) overhead monitoring with sampling-based quality checks
 * Target: <5% overhead, 10% sampling rate
 */

/**
 * Quality check result for a single document
 */
export interface QualityCheckResult {
  documentId: string;
  filePath: string;
  timestamp: string;
  score: number; // 0.0 - 1.0
  passed: boolean; // score >= 0.70
  checks: QualityCheck[];
  interventionRequired: boolean;
  interventionReason?: string;
}

/**
 * Individual quality check
 */
export interface QualityCheck {
  name: string;
  passed: boolean;
  score: number; // 0.0 - 1.0
  message: string;
}

/**
 * Watcher configuration
 */
export interface WatcherQualityConfig {
  samplingRate: number; // 0.0 - 1.0, default 0.10 (10%)
  qualityThreshold: number; // minimum acceptable quality, default 0.70
  interventionThreshold: number; // below this triggers intervention, default 0.70
  maxConcurrentChecks: number; // default 3
  checkTimeoutMs: number; // default 5000
  enabled: boolean; // default true
}

/**
 * Watcher statistics
 */
export interface WatcherStats {
  totalDocumentsProcessed: number;
  totalDocumentsSampled: number;
  totalQualityChecksRun: number;
  averageQualityScore: number;
  passRate: number; // percentage
  interventionCount: number;
  lastCheckTimestamp?: string;
  uptimeMs: number;
  overheadPercentage: number;
}

/**
 * Intervention event
 */
export interface InterventionEvent {
  documentId: string;
  filePath: string;
  timestamp: string;
  qualityScore: number;
  failedChecks: string[];
  action: 'alert' | 'block' | 'reprocess';
}

/**
 * Default configuration
 */
export const DEFAULT_QUALITY_CONFIG: WatcherQualityConfig = {
  samplingRate: 0.10,
  qualityThreshold: 0.70,
  interventionThreshold: 0.70,
  maxConcurrentChecks: 3,
  checkTimeoutMs: 5000,
  enabled: true,
};
