/**
 * Topology Selection Matrix
 * Maps decision characteristics to optimal topology
 * Part of DECISION_087 Phase 1 - AdaptOrch Pillar
 *
 * Selection logic:
 * 1. Score each topology against the input characteristics
 * 2. Select highest-scoring topology
 * 3. Target: <100ms selection time, >90% accuracy
 */

import type {
  Topology,
  TopologyInput,
  DifficultyLevel,
} from './types.js';

/**
 * Score multipliers for each topology based on characteristics
 */
interface TopologyScoreCard {
  topology: Topology;
  difficultyFit: Record<DifficultyLevel, number>;
  concernCountFit: (count: number) => number;
  riskCountFit: (count: number) => number;
  dependencyCountFit: (count: number) => number;
  securityBonus: number;
  architectureBonus: number;
  performanceBonus: number;
  researchBonus: number;
  urgencyBonus: number;
}

/**
 * Scoring cards for each topology
 */
const SCORE_CARDS: TopologyScoreCard[] = [
  {
    topology: 'sequential',
    difficultyFit: { simple: 10, moderate: 5, complex: 2 },
    concernCountFit: (c) => (c <= 1 ? 10 : c <= 2 ? 5 : 2),
    riskCountFit: (r) => (r === 0 ? 8 : r <= 2 ? 5 : 2),
    dependencyCountFit: (d) => (d <= 2 ? 8 : d <= 4 ? 4 : 1),
    securityBonus: 0,
    architectureBonus: 0,
    performanceBonus: 2,
    researchBonus: 0,
    urgencyBonus: 3,  // Fast for simple tasks
  },
  {
    topology: 'parallel',
    difficultyFit: { simple: 6, moderate: 10, complex: 7 },
    concernCountFit: (c) => (c <= 1 ? 5 : c <= 3 ? 10 : 7),
    riskCountFit: (r) => (r === 0 ? 6 : r <= 3 ? 8 : 5),
    dependencyCountFit: (d) => (d <= 2 ? 6 : d <= 5 ? 9 : 6),
    securityBonus: 2,
    architectureBonus: 3,
    performanceBonus: 4,
    researchBonus: 5,
    urgencyBonus: 5,  // Fastest for moderate tasks
  },
  {
    topology: 'hierarchical',
    difficultyFit: { simple: 3, moderate: 6, complex: 10 },
    concernCountFit: (c) => (c <= 1 ? 2 : c <= 3 ? 7 : 10),
    riskCountFit: (r) => (r === 0 ? 3 : r <= 2 ? 7 : 10),
    dependencyCountFit: (d) => (d <= 2 ? 3 : d <= 5 ? 8 : 10),
    securityBonus: 5,
    architectureBonus: 5,
    performanceBonus: 3,
    researchBonus: 4,
    urgencyBonus: 0,  // Slower, more thorough
  },
  {
    topology: 'hybrid',
    difficultyFit: { simple: 4, moderate: 8, complex: 9 },
    concernCountFit: (c) => (c <= 1 ? 3 : c <= 3 ? 8 : 9),
    riskCountFit: (r) => (r === 0 ? 4 : r <= 2 ? 8 : 8),
    dependencyCountFit: (d) => (d <= 2 ? 4 : d <= 5 ? 9 : 9),
    securityBonus: 4,
    architectureBonus: 4,
    performanceBonus: 4,
    researchBonus: 5,
    urgencyBonus: 3,
  },
];

/**
 * Category-specific topology preferences
 */
const CATEGORY_PREFERENCES: Record<string, Topology[]> = {
  ARCH: ['hierarchical', 'hybrid'],
  IMPL: ['parallel', 'sequential'],
  AUTO: ['parallel', 'hybrid'],
  BUGFIX: ['sequential', 'parallel'],
  PERF: ['parallel', 'hierarchical'],
  SEC: ['hierarchical', 'hybrid'],
  DOC: ['sequential', 'parallel'],
  TOOL: ['parallel', 'sequential'],
  PROC: ['sequential', 'hierarchical'],
  PLAT: ['hierarchical', 'hybrid'],
  RES: ['parallel', 'hybrid'],
  UI: ['parallel', 'sequential'],
};

/**
 * Score a topology against input characteristics
 */
function scoreTopology(
  card: TopologyScoreCard,
  input: TopologyInput
): number {
  let score = 0;

  // Base difficulty fit (weight: 30%)
  score += card.difficultyFit[input.difficulty] * 3;

  // Concern count fit (weight: 20%)
  score += card.concernCountFit(input.concernCount) * 2;

  // Risk count fit (weight: 15%)
  score += card.riskCountFit(input.riskCount) * 1.5;

  // Dependency count fit (weight: 15%)
  score += card.dependencyCountFit(input.dependencyCount) * 1.5;

  // Characteristic bonuses (weight: 20% total)
  if (input.hasSecurityConcerns) score += card.securityBonus;
  if (input.hasArchitectureConcerns) score += card.architectureBonus;
  if (input.hasPerformanceConcerns) score += card.performanceBonus;
  if (input.requiresResearch) score += card.researchBonus;
  if (input.isUrgent) score += card.urgencyBonus;

  // Category preference bonus
  if (input.category) {
    const prefs = CATEGORY_PREFERENCES[input.category.toUpperCase()];
    if (prefs) {
      const prefIndex = prefs.indexOf(card.topology);
      if (prefIndex === 0) score += 5; // First choice
      if (prefIndex === 1) score += 2; // Second choice
    }
  }

  return Math.round(score * 10) / 10;
}

/**
 * Select the best topology based on input characteristics
 * Returns scores for all topologies, sorted by score
 */
export function selectTopology(
  input: TopologyInput
): Array<{ topology: Topology; score: number; confidence: number }> {
  const results = SCORE_CARDS.map((card) => {
    const score = scoreTopology(card, input);
    return { topology: card.topology, score };
  });

  // Sort by score descending
  results.sort((a, b) => b.score - a.score);

  // Calculate confidence based on score separation
  const maxScore = results[0].score;
  const secondScore = results[1].score;
  const scoreSeparation = maxScore > 0 ? (maxScore - secondScore) / maxScore : 0;

  return results.map((r, i) => ({
    ...r,
    confidence:
      i === 0
        ? Math.min(1.0, 0.7 + scoreSeparation * 0.3)
        : Math.max(0.1, 1.0 - (maxScore - r.score) / maxScore),
  }));
}
