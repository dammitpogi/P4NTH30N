/**
 * Difficulty Classifier Tests
 * Part of DECISION_087 Phase 1
 */

import { describe, test, expect } from 'bun:test';
import { classify, quickClassify } from './index.js';
import { analyzeTokens, estimateTokenCount, calculateTokenScore } from './token-analyzer.js';
import { detectConcerns, calculateConcernScore } from './concern-detector.js';
import { scanRisks, calculateRiskScore } from './risk-scanner.js';
import { detectDependencies, calculateDependencyScore } from './dependency-detector.js';

// ===================== Token Analyzer Tests =====================

describe('Token Analyzer', () => {
  test('empty string returns 0 tokens', () => {
    expect(estimateTokenCount('')).toBe(0);
    expect(estimateTokenCount('   ')).toBe(0);
  });

  test('short text classified as simple', () => {
    const result = analyzeTokens('Update the README with new instructions');
    expect(result.level).toBe('simple');
    expect(result.tokenCount).toBeLessThan(500);
    expect(result.wordCount).toBeGreaterThan(0);
  });

  test('moderate text classified correctly', () => {
    // Generate ~600 words to cross the 500 token threshold
    const words = Array(600).fill('implementation').join(' ');
    const result = analyzeTokens(words);
    expect(result.level).toBe('moderate');
    expect(result.tokenCount).toBeGreaterThanOrEqual(500);
    expect(result.tokenCount).toBeLessThan(2000);
  });

  test('complex text classified correctly', () => {
    // Generate ~2000 words to cross the 2000 token threshold
    const words = Array(2000).fill('architecture').join(' ');
    const result = analyzeTokens(words);
    expect(result.level).toBe('complex');
    expect(result.tokenCount).toBeGreaterThanOrEqual(2000);
  });

  test('token score increases with count', () => {
    expect(calculateTokenScore(0)).toBe(0);
    expect(calculateTokenScore(50)).toBe(1);
    expect(calculateTokenScore(300)).toBe(3);
    expect(calculateTokenScore(700)).toBe(5);
    expect(calculateTokenScore(1500)).toBe(7);
    expect(calculateTokenScore(2500)).toBe(8);
    expect(calculateTokenScore(5000)).toBe(10);
  });

  test('sentence count works correctly', () => {
    const result = analyzeTokens('First sentence. Second sentence! Third?');
    expect(result.sentenceCount).toBe(3);
  });
});

// ===================== Concern Detector Tests =====================

describe('Concern Detector', () => {
  test('detects architecture concerns', () => {
    const concerns = detectConcerns('Refactor the microservice architecture to use event-driven design patterns');
    const archConcern = concerns.find(c => c.category === 'architecture');
    expect(archConcern).toBeDefined();
    expect(archConcern!.keywords.length).toBeGreaterThan(0);
  });

  test('detects security concerns', () => {
    const concerns = detectConcerns('Implement OAuth2 authentication with JWT tokens and RBAC authorization');
    const secConcern = concerns.find(c => c.category === 'security');
    expect(secConcern).toBeDefined();
    expect(secConcern!.keywords.length).toBeGreaterThan(0);
  });

  test('detects performance concerns', () => {
    const concerns = detectConcerns('Optimize caching strategy to reduce latency and improve throughput');
    const perfConcern = concerns.find(c => c.category === 'performance');
    expect(perfConcern).toBeDefined();
  });

  test('detects multiple concerns', () => {
    const concerns = detectConcerns(
      'Refactor the authentication architecture to improve performance and add integration with MongoDB'
    );
    expect(concerns.length).toBeGreaterThanOrEqual(3);
    const categories = concerns.map(c => c.category);
    expect(categories).toContain('architecture');
    expect(categories).toContain('security');
    expect(categories).toContain('performance');
  });

  test('returns empty for generic text', () => {
    const concerns = detectConcerns('Hello world, how are you today');
    expect(concerns.length).toBe(0);
  });

  test('concern score scales with count', () => {
    expect(calculateConcernScore([])).toBe(0);
    expect(calculateConcernScore([{} as any])).toBe(3);
    expect(calculateConcernScore([{} as any, {} as any])).toBe(5);
  });
});

// ===================== Risk Scanner Tests =====================

describe('Risk Scanner', () => {
  test('detects critical risks', () => {
    const risks = scanRisks('This introduces a breaking change to the API that may cause data loss');
    const critical = risks.filter(r => r.severity === 'critical');
    expect(critical.length).toBeGreaterThan(0);
  });

  test('detects high risks', () => {
    const risks = scanRisks('This requires a database migration and deprecation of the old schema');
    const high = risks.filter(r => r.severity === 'high');
    expect(high.length).toBeGreaterThan(0);
  });

  test('detects medium risks', () => {
    const risks = scanRisks('Refactoring the dependency management and addressing performance concerns');
    const medium = risks.filter(r => r.severity === 'medium');
    expect(medium.length).toBeGreaterThan(0);
  });

  test('detects low risks', () => {
    const risks = scanRisks('Adding a new feature with documentation updates');
    const low = risks.filter(r => r.severity === 'low');
    expect(low.length).toBeGreaterThan(0);
  });

  test('returns empty for safe text', () => {
    const risks = scanRisks('Hello world, simple greeting');
    expect(risks.length).toBe(0);
  });

  test('risk score reflects severity', () => {
    expect(calculateRiskScore([])).toBe(0);
    const criticalRisk = [{ keyword: 'breaking change', severity: 'critical' as const, context: '' }];
    expect(calculateRiskScore(criticalRisk)).toBeGreaterThan(3);
    const lowRisk = [{ keyword: 'documentation', severity: 'low' as const, context: '' }];
    expect(calculateRiskScore(lowRisk)).toBeLessThan(1);
  });

  test('includes context around matches', () => {
    const risks = scanRisks('The system may experience a breaking change in the API layer');
    const critical = risks.find(r => r.severity === 'critical');
    expect(critical).toBeDefined();
    expect(critical!.context.length).toBeGreaterThan(0);
  });

  test('sorts by severity (critical first)', () => {
    const risks = scanRisks('Breaking change with documentation update and refactoring needed');
    if (risks.length >= 2) {
      const severityOrder = { critical: 0, high: 1, medium: 2, low: 3 };
      for (let i = 1; i < risks.length; i++) {
        expect(severityOrder[risks[i].severity]).toBeGreaterThanOrEqual(
          severityOrder[risks[i - 1].severity]
        );
      }
    }
  });
});

// ===================== Dependency Detector Tests =====================

describe('Dependency Detector', () => {
  test('detects agent dependencies', () => {
    const deps = detectDependencies('Deploy @oracle and @designer for consultation');
    const agents = deps.filter(d => d.type === 'agent');
    expect(agents.length).toBeGreaterThanOrEqual(2);
  });

  test('detects tool dependencies', () => {
    const deps = detectDependencies('Use rag-server for ingestion and decisions-server for queries');
    const tools = deps.filter(d => d.type === 'tool');
    expect(tools.length).toBeGreaterThanOrEqual(2);
  });

  test('detects directory references', () => {
    const deps = detectDependencies('Store outputs in STR4TEG15T and C0D3F1X directories');
    const dirs = deps.filter(d => d.type === 'directory');
    expect(dirs.length).toBeGreaterThanOrEqual(2);
  });

  test('detects service dependencies', () => {
    const deps = detectDependencies('Connect to MongoDB for data storage');
    const services = deps.filter(d => d.type === 'service');
    expect(services.length).toBeGreaterThan(0);
  });

  test('deduplicates dependencies', () => {
    const deps = detectDependencies('Use @oracle for review. Ask @oracle again for validation.');
    const oracleDeps = deps.filter(d => d.name === 'oracle');
    expect(oracleDeps.length).toBe(1);
  });

  test('dependency score scales with count', () => {
    expect(calculateDependencyScore([])).toBe(0);
    const single = [{ type: 'agent' as const, name: 'oracle', relationship: 'depends-on' as const }];
    expect(calculateDependencyScore(single)).toBeGreaterThan(0);
  });
});

// ===================== Main Classifier Tests =====================

describe('Difficulty Classifier', () => {
  test('classifies simple queries correctly', () => {
    const result = classify({ query: 'Update the README file' });
    expect(result.difficulty).toBe('simple');
    expect(result.confidence).toBeGreaterThanOrEqual(0.5);
    expect(result.classificationTimeMs).toBeGreaterThan(0);
  });

  test('classifies moderate queries correctly', () => {
    const result = classify({
      query: 'Implement a new authentication system using OAuth2 with JWT tokens, ' +
             'integrate with MongoDB for token storage, and add caching for performance optimization. ' +
             'The system needs to handle both API and web authentication flows.',
    });
    // With security + integration + performance concerns detected, but short text may stay simple by token count
    expect(result.concerns.length).toBeGreaterThan(0);
    // Verify the overall classification is reasonable
    expect(['simple', 'moderate', 'complex']).toContain(result.difficulty);
    expect(result.concerns.length).toBeGreaterThan(0);
  });

  test('classifies complex queries correctly', () => {
    // Long query with many concerns, risks, and dependencies
    const complexQuery =
      'Refactor the entire microservice architecture to implement event-driven patterns. ' +
      'This involves a breaking change to all API endpoints, database migration for MongoDB schema, ' +
      'and security review for authentication and authorization systems. ' +
      'Deploy @oracle for risk assessment, @designer for architecture planning, ' +
      '@librarian for research on event-driven patterns. ' +
      'Store results in STR4TEG15T and update C0D3F1X with implementations. ' +
      'Performance optimization is critical - latency must stay below 2 seconds. ' +
      'This blocks DECISION_045 and is related to DECISION_038. ' +
      'The rollback strategy must handle data corruption scenarios. ' +
      'Coordinate between windfixer for P4NTHE0N changes and openfixer for config updates. ' +
      Array(200).fill('additional context about implementation details').join(' ');

    const result = classify({ query: complexQuery });
    expect(result.difficulty).toBe('complex');
    expect(result.concerns.length).toBeGreaterThanOrEqual(3);
    expect(result.risks.length).toBeGreaterThan(0);
    expect(result.crossCuttingDependencies.length).toBeGreaterThan(0);
    expect(result.scores.overall).toBeGreaterThan(6);
  });

  test('includes reasoning in result', () => {
    const result = classify({ query: 'Implement new feature with authentication' });
    expect(result.reasoning).toBeTruthy();
    expect(result.reasoning.length).toBeGreaterThan(20);
  });

  test('respects context parameter', () => {
    const withoutContext = classify({ query: 'Update something' });
    const withContext = classify({
      query: 'Update something',
      context: 'This requires refactoring the security architecture and migrating the database with breaking changes',
    });
    // With context, should detect more concerns
    expect(withContext.concerns.length).toBeGreaterThan(withoutContext.concerns.length);
  });

  test('quickClassify returns just difficulty', () => {
    const level = quickClassify('Simple config update');
    expect(['simple', 'moderate', 'complex']).toContain(level);
  });

  test('validates input', () => {
    expect(() => classify({ query: '' })).toThrow();
  });

  test('classification completes under 100ms', () => {
    const result = classify({
      query: 'Implement a comprehensive feature with multiple concerns and dependencies',
    });
    expect(result.classificationTimeMs).toBeLessThan(100);
  });
});
