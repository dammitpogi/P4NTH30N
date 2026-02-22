/**
 * Quality Module - Public API
 * Part of DECISION_087 Phase 1 - COCO Pillar
 */

export { QualityWatcher } from './watcher.js';
export {
  runAllChecks,
  calculateOverallScore,
  checkMetadata,
  checkStructure,
  checkContentQuality,
  checkApprovalEvidence,
  checkReferences,
} from './checks.js';
export type {
  QualityCheckResult,
  QualityCheck,
  WatcherQualityConfig,
  WatcherStats,
  InterventionEvent,
} from './types.js';
export { DEFAULT_QUALITY_CONFIG } from './types.js';
