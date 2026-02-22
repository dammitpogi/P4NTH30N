/**
 * Topology Selector - Main Entry Point
 * Part of DECISION_087 Phase 1 - AdaptOrch Pillar (Topology Selection)
 *
 * Selects the optimal workflow topology based on:
 * - Decision difficulty (from difficulty-classifier)
 * - Decision category
 * - Concern count, risk count, dependency count
 * - Special flags (security, architecture, performance, research, urgency)
 *
 * Four topologies: Sequential, Parallel, Hierarchical, Hybrid
 * Target: <100ms selection time, >90% accuracy
 */

import {
  TopologyInputSchema,
  type TopologyInput,
  type TopologyResult,
} from './types.js';
import { TOPOLOGY_PROFILES, getAgentPool } from './profiles.js';
import { selectTopology } from './selection-matrix.js';

// Re-export types
export type {
  TopologyInput,
  TopologyResult,
  Topology,
  AgentPoolConfig,
  AgentRole,
  DecisionCategory,
} from './types.js';
export { TopologyInputSchema } from './types.js';
export { TOPOLOGY_PROFILES } from './profiles.js';

/**
 * Generate reasoning for topology selection
 */
function generateReasoning(
  input: TopologyInput,
  scores: Array<{ topology: string; score: number; confidence: number }>
): string {
  const top = scores[0];
  const second = scores[1];
  const parts: string[] = [];

  parts.push(
    `Selected ${top.topology.toUpperCase()} topology (score: ${top.score}, confidence: ${Math.round(top.confidence * 100)}%).`
  );

  parts.push(
    `Input: difficulty=${input.difficulty}, concerns=${input.concernCount}, risks=${input.riskCount}, dependencies=${input.dependencyCount}.`
  );

  if (input.category) {
    parts.push(`Category: ${input.category}.`);
  }

  const flags: string[] = [];
  if (input.hasSecurityConcerns) flags.push('security');
  if (input.hasArchitectureConcerns) flags.push('architecture');
  if (input.hasPerformanceConcerns) flags.push('performance');
  if (input.requiresResearch) flags.push('research');
  if (input.isUrgent) flags.push('urgent');
  if (flags.length > 0) {
    parts.push(`Flags: ${flags.join(', ')}.`);
  }

  parts.push(
    `Alternative: ${second.topology} (score: ${second.score}).`
  );

  return parts.join(' ');
}

/**
 * Select the optimal workflow topology for a decision
 *
 * @param input - Decision characteristics from difficulty classifier
 * @returns Topology selection result with agent pool configuration
 */
export function select(input: TopologyInput): TopologyResult {
  const startTime = performance.now();

  // Validate input
  const validated = TopologyInputSchema.parse(input);

  // Run selection matrix
  const scores = selectTopology(validated);
  const best = scores[0];
  const second = scores[1];

  // Get topology profile and agent pool
  const profile = TOPOLOGY_PROFILES[best.topology];
  const agentPool = getAgentPool(best.topology, validated.difficulty);

  // Estimate duration and tokens
  const estimatedDurationMinutes =
    profile.avgDurationMinutes[validated.difficulty];
  const estimatedTokens = profile.avgTokens[validated.difficulty];

  // Generate reasoning
  const reasoning = generateReasoning(validated, scores);

  const selectionTimeMs =
    Math.round((performance.now() - startTime) * 100) / 100;

  return {
    topology: best.topology,
    confidence: Math.round(best.confidence * 100) / 100,
    agentPool,
    estimatedDurationMinutes,
    estimatedTokens,
    reasoning,
    selectionTimeMs,
    alternativeTopology: second.topology,
    alternativeReasoning: `${second.topology} scored ${second.score} (${Math.round((best.score - second.score))} point gap)`,
  };
}

/**
 * Quick select - returns just the topology name
 * For performance-critical paths
 */
export function quickSelect(
  difficulty: TopologyInput['difficulty'],
  category?: string
): TopologyResult['topology'] {
  return select({ difficulty, category }).topology;
}
