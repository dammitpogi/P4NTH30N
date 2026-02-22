/**
 * Types for the Difficulty Classifier
 * Part of DECISION_087 Phase 1 - Dynamic Workflow Generation (DAAO)
 */

import { z } from 'zod';

/**
 * Difficulty levels for decision queries
 */
export type DifficultyLevel = 'simple' | 'moderate' | 'complex';

/**
 * Concern categories that affect difficulty
 */
export type ConcernCategory =
  | 'architecture'
  | 'security'
  | 'performance'
  | 'integration'
  | 'data-model'
  | 'ui-ux'
  | 'testing'
  | 'deployment'
  | 'documentation'
  | 'tooling'
  | 'process';

/**
 * Risk keywords and their severity
 */
export type RiskSeverity = 'low' | 'medium' | 'high' | 'critical';

/**
 * A detected concern within a query
 */
export interface DetectedConcern {
  category: ConcernCategory;
  keywords: string[];
  confidence: number; // 0.0 - 1.0
  description: string;
}

/**
 * A detected risk indicator
 */
export interface RiskIndicator {
  keyword: string;
  severity: RiskSeverity;
  context: string; // surrounding text
}

/**
 * Cross-cutting dependency detected
 */
export interface CrossCuttingDependency {
  type: 'agent' | 'tool' | 'service' | 'config' | 'directory';
  name: string;
  relationship: 'reads' | 'writes' | 'depends-on' | 'blocks' | 'related';
}

/**
 * Token analysis result
 */
export interface TokenAnalysis {
  tokenCount: number;
  wordCount: number;
  sentenceCount: number;
  level: DifficultyLevel;
}

/**
 * Complete classification result
 */
export interface ClassificationResult {
  difficulty: DifficultyLevel;
  confidence: number; // 0.0 - 1.0
  tokenAnalysis: TokenAnalysis;
  concerns: DetectedConcern[];
  risks: RiskIndicator[];
  crossCuttingDependencies: CrossCuttingDependency[];
  scores: {
    tokenScore: number; // 0-10
    concernScore: number; // 0-10
    riskScore: number; // 0-10
    dependencyScore: number; // 0-10
    overall: number; // 0-10 weighted average
  };
  reasoning: string;
  classificationTimeMs: number;
}

/**
 * Input for classification
 */
export const ClassificationInputSchema = z.object({
  query: z.string().min(1, 'Query cannot be empty'),
  context: z.string().optional(),
  decisionCategory: z.string().optional(),
  existingDecisionIds: z.array(z.string()).optional(),
});

export type ClassificationInput = z.infer<typeof ClassificationInputSchema>;
