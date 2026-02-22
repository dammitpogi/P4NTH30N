/**
 * Topology Selector Tests
 * Part of DECISION_087 Phase 1
 */

import { describe, test, expect } from 'bun:test';
import { select, quickSelect, TOPOLOGY_PROFILES } from './index.js';
import { selectTopology } from './selection-matrix.js';
import { getAgentPool } from './profiles.js';

// ===================== Selection Matrix Tests =====================

describe('Selection Matrix', () => {
  test('simple + low concerns prefers sequential', () => {
    const results = selectTopology({
      difficulty: 'simple',
      concernCount: 0,
      riskCount: 0,
      dependencyCount: 0,
    });
    expect(results[0].topology).toBe('sequential');
  });

  test('moderate + multiple concerns prefers parallel', () => {
    const results = selectTopology({
      difficulty: 'moderate',
      concernCount: 3,
      riskCount: 1,
      dependencyCount: 3,
    });
    expect(results[0].topology).toBe('parallel');
  });

  test('complex + security + architecture prefers hierarchical', () => {
    const results = selectTopology({
      difficulty: 'complex',
      concernCount: 5,
      riskCount: 3,
      dependencyCount: 6,
      hasSecurityConcerns: true,
      hasArchitectureConcerns: true,
    });
    expect(['hierarchical', 'hybrid']).toContain(results[0].topology);
  });

  test('returns all 4 topologies scored', () => {
    const results = selectTopology({
      difficulty: 'moderate',
      concernCount: 2,
      riskCount: 1,
      dependencyCount: 2,
    });
    expect(results.length).toBe(4);
    const topologies = results.map(r => r.topology);
    expect(topologies).toContain('sequential');
    expect(topologies).toContain('parallel');
    expect(topologies).toContain('hierarchical');
    expect(topologies).toContain('hybrid');
  });

  test('results sorted by score descending', () => {
    const results = selectTopology({
      difficulty: 'moderate',
      concernCount: 2,
      riskCount: 1,
      dependencyCount: 2,
    });
    for (let i = 1; i < results.length; i++) {
      expect(results[i].score).toBeLessThanOrEqual(results[i - 1].score);
    }
  });

  test('category preference boosts relevant topology', () => {
    const withArch = selectTopology({
      difficulty: 'moderate',
      category: 'ARCH',
      concernCount: 2,
      riskCount: 1,
      dependencyCount: 2,
    });
    const withDoc = selectTopology({
      difficulty: 'moderate',
      category: 'DOC',
      concernCount: 2,
      riskCount: 1,
      dependencyCount: 2,
    });
    // ARCH prefers hierarchical/hybrid → those should score higher for ARCH than DOC
    const archHierarchical = withArch.find(r => r.topology === 'hierarchical')!.score;
    const docHierarchical = withDoc.find(r => r.topology === 'hierarchical')!.score;
    expect(archHierarchical).toBeGreaterThan(docHierarchical);
  });

  test('urgency boosts parallel topology', () => {
    const urgent = selectTopology({
      difficulty: 'moderate',
      concernCount: 2,
      riskCount: 1,
      dependencyCount: 2,
      isUrgent: true,
    });
    const notUrgent = selectTopology({
      difficulty: 'moderate',
      concernCount: 2,
      riskCount: 1,
      dependencyCount: 2,
      isUrgent: false,
    });
    // Parallel should score higher with urgency
    const urgentParallel = urgent.find(r => r.topology === 'parallel')!.score;
    const notUrgentParallel = notUrgent.find(r => r.topology === 'parallel')!.score;
    expect(urgentParallel).toBeGreaterThan(notUrgentParallel);
  });
});

// ===================== Agent Pool Tests =====================

describe('Agent Pool Configuration', () => {
  test('sequential simple has minimal agents', () => {
    const pool = getAgentPool('sequential', 'simple');
    expect(pool.required).toContain('strategist');
    expect(pool.required.length).toBeLessThanOrEqual(4);
    expect(pool.parallelGroups.length).toBe(0);
  });

  test('parallel moderate has parallel groups', () => {
    const pool = getAgentPool('parallel', 'moderate');
    expect(pool.parallelGroups.length).toBeGreaterThan(0);
    expect(pool.required).toContain('oracle');
    expect(pool.required).toContain('designer');
  });

  test('hierarchical complex has all key agents', () => {
    const pool = getAgentPool('hierarchical', 'complex');
    expect(pool.required).toContain('strategist');
    expect(pool.required).toContain('oracle');
    expect(pool.required).toContain('designer');
    expect(pool.required).toContain('windfixer');
    expect(pool.required.length).toBeGreaterThanOrEqual(5);
  });

  test('hybrid complex has both parallel and sequential', () => {
    const pool = getAgentPool('hybrid', 'complex');
    expect(pool.parallelGroups.length).toBeGreaterThan(0);
    expect(pool.sequentialOrder.length).toBeGreaterThan(0);
  });

  test('all pools include strategist', () => {
    const topologies = ['sequential', 'parallel', 'hierarchical', 'hybrid'] as const;
    const difficulties = ['simple', 'moderate', 'complex'] as const;
    for (const t of topologies) {
      for (const d of difficulties) {
        const pool = getAgentPool(t, d);
        expect(pool.required).toContain('strategist');
      }
    }
  });
});

// ===================== Topology Profiles Tests =====================

describe('Topology Profiles', () => {
  test('all 4 topologies have profiles', () => {
    expect(TOPOLOGY_PROFILES.sequential).toBeDefined();
    expect(TOPOLOGY_PROFILES.parallel).toBeDefined();
    expect(TOPOLOGY_PROFILES.hierarchical).toBeDefined();
    expect(TOPOLOGY_PROFILES.hybrid).toBeDefined();
  });

  test('profiles have duration estimates for all difficulties', () => {
    for (const profile of Object.values(TOPOLOGY_PROFILES)) {
      expect(profile.avgDurationMinutes.simple).toBeGreaterThan(0);
      expect(profile.avgDurationMinutes.moderate).toBeGreaterThan(0);
      expect(profile.avgDurationMinutes.complex).toBeGreaterThan(0);
    }
  });

  test('parallel is fastest for moderate difficulty', () => {
    expect(TOPOLOGY_PROFILES.parallel.avgDurationMinutes.moderate)
      .toBeLessThanOrEqual(TOPOLOGY_PROFILES.sequential.avgDurationMinutes.moderate);
  });

  test('token estimates increase with difficulty', () => {
    for (const profile of Object.values(TOPOLOGY_PROFILES)) {
      expect(profile.avgTokens.moderate).toBeGreaterThan(profile.avgTokens.simple);
      expect(profile.avgTokens.complex).toBeGreaterThan(profile.avgTokens.moderate);
    }
  });
});

// ===================== Main Selector Tests =====================

describe('Topology Selector', () => {
  test('select returns complete result', () => {
    const result = select({
      difficulty: 'moderate',
      concernCount: 2,
      riskCount: 1,
      dependencyCount: 2,
    });
    expect(result.topology).toBeDefined();
    expect(result.confidence).toBeGreaterThan(0);
    expect(result.agentPool).toBeDefined();
    expect(result.estimatedDurationMinutes).toBeGreaterThan(0);
    expect(result.estimatedTokens).toBeGreaterThan(0);
    expect(result.reasoning).toBeTruthy();
    expect(result.selectionTimeMs).toBeGreaterThan(0);
    expect(result.alternativeTopology).toBeDefined();
  });

  test('select completes under 100ms', () => {
    const result = select({
      difficulty: 'complex',
      category: 'ARCH',
      concernCount: 5,
      riskCount: 3,
      dependencyCount: 6,
      hasSecurityConcerns: true,
      hasArchitectureConcerns: true,
    });
    expect(result.selectionTimeMs).toBeLessThan(100);
  });

  test('quickSelect returns topology name', () => {
    const topology = quickSelect('simple');
    expect(['sequential', 'parallel', 'hierarchical', 'hybrid']).toContain(topology);
  });

  test('simple defaults to sequential', () => {
    const result = select({
      difficulty: 'simple',
      concernCount: 0,
      riskCount: 0,
      dependencyCount: 0,
    });
    expect(result.topology).toBe('sequential');
  });

  test('includes alternative topology', () => {
    const result = select({
      difficulty: 'moderate',
      concernCount: 2,
      riskCount: 1,
      dependencyCount: 2,
    });
    expect(result.alternativeTopology).toBeDefined();
    expect(result.alternativeTopology).not.toBe(result.topology);
  });

  test('validates input', () => {
    expect(() => select({ difficulty: 'invalid' as any })).toThrow();
  });

  test('confidence is between 0 and 1', () => {
    const result = select({
      difficulty: 'moderate',
      concernCount: 2,
      riskCount: 1,
      dependencyCount: 2,
    });
    expect(result.confidence).toBeGreaterThanOrEqual(0);
    expect(result.confidence).toBeLessThanOrEqual(1);
  });
});
