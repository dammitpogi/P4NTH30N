/**
 * Quality Watcher Tests
 * Part of DECISION_087 Phase 1
 */

import { describe, test, expect } from 'bun:test';
import {
  checkMetadata,
  checkStructure,
  checkContentQuality,
  checkApprovalEvidence,
  checkReferences,
  runAllChecks,
  calculateOverallScore,
} from './checks.js';
import { QualityWatcher } from './watcher.js';

// ===================== Sample Documents =====================

const GOOD_DECISION = `# DECISION_087: Agent Prompt Enhancement

**Decision ID**: DECISION_087
**Category**: AUTO
**Status**: Approved
**Priority**: Critical
**Date**: 2026-02-21
**Oracle Approval**: 98%
**Designer Approval**: 99%

---

## Executive Summary

This decision updates agent prompts and introduces automated decision creation.

## Background

### Current State
Agents operate without directory awareness.

### Desired State
Self-improving Pantheon with autonomous decision creation.

## Specification

### Requirements

1. **REQ-001**: Agent Prompt Updates

## Action Items

| ID | Action | Status |
|----|--------|--------|
| ACT-001 | Research patterns | Done |

## Dependencies

- **Blocks**: None
- **Blocked By**: DECISION_086
- **Related**: DECISION_038

## Risks and Mitigations

| Risk | Impact |
|------|--------|
| Quality degradation | High |

## Success Criteria

1. All agents updated
2. Decision creation time reduced

## Token Budget

- **Estimated**: 180K tokens

## Bug-Fix Section

- On syntax error: Auto-fix

## Research & Consultation Log

### Loop 1: Initial Research
- Status: Completed
`;

const BAD_DECISION = `# Some Document

This is a poorly structured document without any required fields.
No metadata, no sections, no substance.
`;

const MINIMAL_DECISION = `# DECISION_099: Minimal

**Decision ID**: DECISION_099
**Status**: Proposed
**Category**: DOC
**Priority**: Low
**Date**: 2026-02-21

## Executive Summary

Short summary.

## Specification

Basic spec.

## Action Items

None yet.

## Dependencies

- **Related**: None

## Risks and Mitigations

Low risk.

## Success Criteria

TBD.
`;

// ===================== Individual Check Tests =====================

describe('Metadata Check', () => {
  test('passes for good decision', () => {
    const result = checkMetadata(GOOD_DECISION);
    expect(result.passed).toBe(true);
    expect(result.score).toBeGreaterThanOrEqual(0.6);
  });

  test('fails for bad decision', () => {
    const result = checkMetadata(BAD_DECISION);
    expect(result.passed).toBe(false);
    expect(result.score).toBeLessThan(0.6);
  });

  test('passes for minimal decision', () => {
    const result = checkMetadata(MINIMAL_DECISION);
    expect(result.passed).toBe(true);
  });
});

describe('Structure Check', () => {
  test('passes for good decision', () => {
    const result = checkStructure(GOOD_DECISION);
    expect(result.passed).toBe(true);
    expect(result.score).toBeGreaterThan(0.5);
  });

  test('fails for bad decision', () => {
    const result = checkStructure(BAD_DECISION);
    expect(result.passed).toBe(false);
  });

  test('passes for minimal decision', () => {
    const result = checkStructure(MINIMAL_DECISION);
    expect(result.passed).toBe(true);
  });
});

describe('Content Quality Check', () => {
  test('passes for good decision', () => {
    const result = checkContentQuality(GOOD_DECISION);
    expect(result.passed).toBe(true);
  });

  test('fails for bad decision', () => {
    const result = checkContentQuality(BAD_DECISION);
    expect(result.passed).toBe(false);
  });
});

describe('Approval Evidence Check', () => {
  test('passes for good decision with approvals', () => {
    const result = checkApprovalEvidence(GOOD_DECISION);
    expect(result.passed).toBe(true);
  });

  test('fails for document without approvals', () => {
    const result = checkApprovalEvidence(BAD_DECISION);
    expect(result.passed).toBe(false);
  });
});

describe('References Check', () => {
  test('detects external decision references', () => {
    const result = checkReferences(GOOD_DECISION);
    expect(result.passed).toBe(true);
  });

  test('handles no references gracefully', () => {
    const result = checkReferences(BAD_DECISION);
    expect(result.score).toBeDefined();
  });
});

// ===================== Combined Check Tests =====================

describe('Run All Checks', () => {
  test('returns 5 checks', () => {
    const checks = runAllChecks(GOOD_DECISION);
    expect(checks.length).toBe(5);
  });

  test('all check names present', () => {
    const checks = runAllChecks(GOOD_DECISION);
    const names = checks.map(c => c.name);
    expect(names).toContain('metadata');
    expect(names).toContain('structure');
    expect(names).toContain('content-quality');
    expect(names).toContain('approval-evidence');
    expect(names).toContain('references');
  });

  test('good decision scores high', () => {
    const checks = runAllChecks(GOOD_DECISION);
    const score = calculateOverallScore(checks);
    expect(score).toBeGreaterThanOrEqual(0.7);
  });

  test('bad decision scores low', () => {
    const checks = runAllChecks(BAD_DECISION);
    const score = calculateOverallScore(checks);
    expect(score).toBeLessThan(0.7);
  });

  test('scores are between 0 and 1', () => {
    const checks = runAllChecks(GOOD_DECISION);
    for (const check of checks) {
      expect(check.score).toBeGreaterThanOrEqual(0);
      expect(check.score).toBeLessThanOrEqual(1);
    }
    const overall = calculateOverallScore(checks);
    expect(overall).toBeGreaterThanOrEqual(0);
    expect(overall).toBeLessThanOrEqual(1);
  });
});

// ===================== Quality Watcher Tests =====================

describe('QualityWatcher', () => {
  test('creates with default config', () => {
    const watcher = new QualityWatcher();
    const stats = watcher.getStats();
    expect(stats.totalDocumentsProcessed).toBe(0);
    expect(stats.totalDocumentsSampled).toBe(0);
  });

  test('sampling rate controls check frequency', async () => {
    // 100% sampling rate
    const watcher = new QualityWatcher({ samplingRate: 1.0 });

    const result = await watcher.processDocument('doc1', '/test.md', GOOD_DECISION);
    expect(result).not.toBeNull();
    expect(result!.score).toBeGreaterThan(0);

    const stats = watcher.getStats();
    expect(stats.totalDocumentsProcessed).toBe(1);
    expect(stats.totalDocumentsSampled).toBe(1);
  });

  test('0% sampling rate skips all checks', async () => {
    const watcher = new QualityWatcher({ samplingRate: 0 });

    const result = await watcher.processDocument('doc1', '/test.md', GOOD_DECISION);
    expect(result).toBeNull();

    const stats = watcher.getStats();
    expect(stats.totalDocumentsProcessed).toBe(1);
    expect(stats.totalDocumentsSampled).toBe(0);
  });

  test('triggers intervention for low quality', async () => {
    const watcher = new QualityWatcher({
      samplingRate: 1.0,
      qualityThreshold: 0.7,
      interventionThreshold: 0.7,
    });

    let interventionTriggered = false;
    watcher.onIntervention(() => {
      interventionTriggered = true;
    });

    await watcher.processDocument('bad1', '/bad.md', BAD_DECISION);
    expect(interventionTriggered).toBe(true);

    const stats = watcher.getStats();
    expect(stats.interventionCount).toBe(1);
  });

  test('does not trigger intervention for good quality', async () => {
    const watcher = new QualityWatcher({
      samplingRate: 1.0,
      qualityThreshold: 0.7,
      interventionThreshold: 0.7,
    });

    let interventionTriggered = false;
    watcher.onIntervention(() => {
      interventionTriggered = true;
    });

    await watcher.processDocument('good1', '/good.md', GOOD_DECISION);
    expect(interventionTriggered).toBe(false);
  });

  test('forceCheck bypasses sampling', async () => {
    const watcher = new QualityWatcher({ samplingRate: 0 });

    const result = await watcher.forceCheck('doc1', '/test.md', GOOD_DECISION);
    expect(result).not.toBeNull();
    expect(result.score).toBeGreaterThan(0);

    const stats = watcher.getStats();
    expect(stats.totalDocumentsSampled).toBe(1);
  });

  test('tracks rolling average', async () => {
    const watcher = new QualityWatcher({ samplingRate: 1.0 });

    await watcher.processDocument('good', '/good.md', GOOD_DECISION);
    const statsAfterGood = watcher.getStats();
    expect(statsAfterGood.averageQualityScore).toBeGreaterThan(0);

    await watcher.processDocument('bad', '/bad.md', BAD_DECISION);
    const statsAfterBad = watcher.getStats();
    // Average should decrease after bad document
    expect(statsAfterBad.averageQualityScore).toBeLessThan(statsAfterGood.averageQualityScore);
  });

  test('config can be updated at runtime', () => {
    const watcher = new QualityWatcher({ samplingRate: 0.1 });
    watcher.updateConfig({ samplingRate: 0.5 });
    // Can't directly check config, but verify no errors
    const stats = watcher.getStats();
    expect(stats).toBeDefined();
  });

  test('overhead percentage stays low', async () => {
    const watcher = new QualityWatcher({ samplingRate: 0.1 });

    // Process 100 documents with 10% sampling
    for (let i = 0; i < 100; i++) {
      await watcher.processDocument(`doc${i}`, `/doc${i}.md`, GOOD_DECISION);
    }

    const stats = watcher.getStats();
    // With 10% sampling, overhead should be around 10%
    expect(stats.overheadPercentage).toBeLessThanOrEqual(20); // Allow some variance
  });
});
