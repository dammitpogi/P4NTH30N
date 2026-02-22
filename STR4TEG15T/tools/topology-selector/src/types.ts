/**
 * Types for the Topology Selector
 * Part of DECISION_087 Phase 1 - AdaptOrch Pillar (Topology Selection)
 */

import { z } from 'zod';

/**
 * Available workflow topologies per DECISION_087
 * Each offers 12-23% improvement over naive selection
 */
export type Topology = 'sequential' | 'parallel' | 'hierarchical' | 'hybrid';

/**
 * Decision categories in the Pantheon system
 */
export type DecisionCategory =
  | 'ARCH'    // Architecture
  | 'IMPL'    // Implementation
  | 'AUTO'    // Automation
  | 'BUGFIX'  // Bug fixes
  | 'PERF'    // Performance
  | 'SEC'     // Security
  | 'DOC'     // Documentation
  | 'TOOL'    // Tooling
  | 'PROC'    // Process
  | 'PLAT'    // Platform
  | 'RES'     // Research
  | 'UI';     // User Interface

/**
 * Difficulty levels (from difficulty-classifier)
 */
export type DifficultyLevel = 'simple' | 'moderate' | 'complex';

/**
 * Agent role definitions for pool configuration
 */
export type AgentRole =
  | 'strategist'
  | 'oracle'
  | 'designer'
  | 'librarian'
  | 'explorer'
  | 'fixer'
  | 'windfixer'
  | 'openfixer'
  | 'forgewright';

/**
 * Agent pool configuration - which agents participate and how
 */
export interface AgentPoolConfig {
  required: AgentRole[];
  optional: AgentRole[];
  parallelGroups: AgentRole[][];  // Groups of agents that can run simultaneously
  sequentialOrder: AgentRole[];    // Order for sequential execution
}

/**
 * Topology selection result
 */
export interface TopologyResult {
  topology: Topology;
  confidence: number;              // 0.0 - 1.0
  agentPool: AgentPoolConfig;
  estimatedDurationMinutes: number;
  estimatedTokens: number;
  reasoning: string;
  selectionTimeMs: number;
  alternativeTopology?: Topology;  // Second-best option
  alternativeReasoning?: string;
}

/**
 * Input for topology selection
 */
export const TopologyInputSchema = z.object({
  difficulty: z.enum(['simple', 'moderate', 'complex']),
  category: z.string().optional(),
  concernCount: z.number().min(0).default(0),
  riskCount: z.number().min(0).default(0),
  dependencyCount: z.number().min(0).default(0),
  hasSecurityConcerns: z.boolean().default(false),
  hasArchitectureConcerns: z.boolean().default(false),
  hasPerformanceConcerns: z.boolean().default(false),
  requiresResearch: z.boolean().default(false),
  isUrgent: z.boolean().default(false),
});

export type TopologyInput = z.infer<typeof TopologyInputSchema>;

/**
 * Topology profile - characteristics of each topology
 */
export interface TopologyProfile {
  topology: Topology;
  description: string;
  bestFor: string[];
  agentPattern: string;
  avgDurationMinutes: { simple: number; moderate: number; complex: number };
  avgTokens: { simple: number; moderate: number; complex: number };
  parallelismLevel: number; // 1 = fully sequential, 5 = fully parallel
}
