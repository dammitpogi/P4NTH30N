/**
 * Difficulty Classifier - Main Entry Point
 * Part of DECISION_087 Phase 1 - DAAO Pillar (Dynamic Workflow Generation)
 *
 * Classifies decision query difficulty using four analysis dimensions:
 * 1. Token count analysis (Simple/Moderate/Complex)
 * 2. Concern identification (regex-based)
 * 3. Cross-cutting dependency detection
 * 4. Risk keyword scanning
 *
 * Target: >90% classification accuracy, <100ms execution
 */

import {
  ClassificationInputSchema,
  type ClassificationInput,
  type ClassificationResult,
  type DifficultyLevel,
} from './types.js';
import { analyzeTokens, calculateTokenScore } from './token-analyzer.js';
import { detectConcerns, calculateConcernScore } from './concern-detector.js';
import { scanRisks, calculateRiskScore } from './risk-scanner.js';
import {
  detectDependencies,
  calculateDependencyScore,
} from './dependency-detector.js';

// Re-export all types
export type {
  ClassificationInput,
  ClassificationResult,
  DifficultyLevel,
} from './types.js';
export { ClassificationInputSchema } from './types.js';

/**
 * Score weights for the overall difficulty calculation
 * Per DECISION_087: token analysis is the primary signal,
 * concerns and risks amplify difficulty
 */
const SCORE_WEIGHTS = {
  token: 0.30,
  concern: 0.30,
  risk: 0.25,
  dependency: 0.15,
} as const;

/**
 * Difficulty thresholds for the overall weighted score
 */
const DIFFICULTY_THRESHOLDS = {
  simple: 3.5,    // overall < 3.5 => simple
  moderate: 6.5,  // overall < 6.5 => moderate, else complex
} as const;

/**
 * Map overall score to difficulty level
 */
function scoreToDifficulty(score: number): DifficultyLevel {
  if (score < DIFFICULTY_THRESHOLDS.simple) return 'simple';
  if (score < DIFFICULTY_THRESHOLDS.moderate) return 'moderate';
  return 'complex';
}

/**
 * Calculate confidence based on agreement between dimensions
 */
function calculateConfidence(
  tokenLevel: DifficultyLevel,
  overallLevel: DifficultyLevel,
  concernCount: number,
  riskCount: number
): number {
  let confidence = 0.7; // base

  // Token analysis agrees with overall
  if (tokenLevel === overallLevel) confidence += 0.15;

  // Strong signals in multiple dimensions
  if (concernCount >= 2) confidence += 0.05;
  if (riskCount >= 1) confidence += 0.05;

  // Penalty for borderline cases (few signals)
  if (concernCount === 0 && riskCount === 0) confidence -= 0.1;

  return Math.min(1.0, Math.max(0.5, Math.round(confidence * 100) / 100));
}

/**
 * Generate human-readable reasoning
 */
function generateReasoning(
  result: Omit<ClassificationResult, 'reasoning' | 'classificationTimeMs'>
): string {
  const parts: string[] = [];

  parts.push(
    `Classified as ${result.difficulty.toUpperCase()} (overall score: ${result.scores.overall}/10, confidence: ${Math.round(result.confidence * 100)}%).`
  );

  parts.push(
    `Token analysis: ${result.tokenAnalysis.tokenCount} estimated tokens (${result.tokenAnalysis.wordCount} words) → ${result.tokenAnalysis.level} level.`
  );

  if (result.concerns.length > 0) {
    const topConcerns = result.concerns
      .slice(0, 3)
      .map((c) => c.category)
      .join(', ');
    parts.push(
      `Detected ${result.concerns.length} concern(s): ${topConcerns}.`
    );
  } else {
    parts.push('No specific concerns detected.');
  }

  if (result.risks.length > 0) {
    const criticalCount = result.risks.filter(
      (r) => r.severity === 'critical'
    ).length;
    const highCount = result.risks.filter(
      (r) => r.severity === 'high'
    ).length;
    const riskSummary: string[] = [];
    if (criticalCount > 0) riskSummary.push(`${criticalCount} critical`);
    if (highCount > 0) riskSummary.push(`${highCount} high`);
    parts.push(
      `Risk indicators: ${result.risks.length} total (${riskSummary.join(', ') || 'low-medium'}).`
    );
  } else {
    parts.push('No risk indicators detected.');
  }

  if (result.crossCuttingDependencies.length > 0) {
    parts.push(
      `Cross-cutting dependencies: ${result.crossCuttingDependencies.length} (${result.crossCuttingDependencies.map((d) => d.name).join(', ')}).`
    );
  }

  return parts.join(' ');
}

/**
 * Classify the difficulty of a decision query
 *
 * @param input - The query text and optional context
 * @returns Complete classification result with scores, concerns, risks, and reasoning
 */
export function classify(input: ClassificationInput): ClassificationResult {
  const startTime = performance.now();

  // Validate input
  const validated = ClassificationInputSchema.parse(input);

  // Combine query with context for full analysis
  const fullText = validated.context
    ? `${validated.query}\n\n${validated.context}`
    : validated.query;

  // 1. Token analysis
  const tokenAnalysis = analyzeTokens(fullText);
  const tokenScore = calculateTokenScore(tokenAnalysis.tokenCount);

  // 2. Concern detection
  const concerns = detectConcerns(fullText);
  const concernScore = calculateConcernScore(concerns);

  // 3. Risk scanning
  const risks = scanRisks(fullText);
  const riskScore = calculateRiskScore(risks);

  // 4. Dependency detection
  const crossCuttingDependencies = detectDependencies(fullText);
  const dependencyScore = calculateDependencyScore(crossCuttingDependencies);

  // Calculate overall weighted score
  const overall =
    Math.round(
      (tokenScore * SCORE_WEIGHTS.token +
        concernScore * SCORE_WEIGHTS.concern +
        riskScore * SCORE_WEIGHTS.risk +
        dependencyScore * SCORE_WEIGHTS.dependency) *
        10
    ) / 10;

  const difficulty = scoreToDifficulty(overall);
  const confidence = calculateConfidence(
    tokenAnalysis.level,
    difficulty,
    concerns.length,
    risks.length
  );

  const partialResult = {
    difficulty,
    confidence,
    tokenAnalysis,
    concerns,
    risks,
    crossCuttingDependencies,
    scores: {
      tokenScore,
      concernScore,
      riskScore,
      dependencyScore,
      overall,
    },
  };

  const reasoning = generateReasoning(partialResult);
  const classificationTimeMs =
    Math.round((performance.now() - startTime) * 100) / 100;

  return {
    ...partialResult,
    reasoning,
    classificationTimeMs,
  };
}

/**
 * Quick classify - returns just the difficulty level
 * For performance-critical paths
 */
export function quickClassify(query: string): DifficultyLevel {
  return classify({ query }).difficulty;
}
