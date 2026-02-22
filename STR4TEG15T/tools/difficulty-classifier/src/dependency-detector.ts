/**
 * Cross-Cutting Dependency Detector
 * Identifies dependencies across agents, tools, services, and directories
 * Part of DECISION_087 Phase 1
 */

import type { CrossCuttingDependency } from './types.js';

/**
 * Pattern definition for dependency detection
 */
interface DependencyPattern {
  type: CrossCuttingDependency['type'];
  pattern: RegExp;
  nameExtractor: (match: RegExpMatchArray) => string;
  relationship: CrossCuttingDependency['relationship'];
}

/**
 * Agent name patterns
 */
const AGENT_PATTERNS: DependencyPattern[] = [
  {
    type: 'agent',
    pattern: /\b@?(strategist|pyxis)\b/i,
    nameExtractor: () => 'strategist',
    relationship: 'depends-on',
  },
  {
    type: 'agent',
    pattern: /\b@?(oracle|orion)\b/i,
    nameExtractor: () => 'oracle',
    relationship: 'depends-on',
  },
  {
    type: 'agent',
    pattern: /\b@?(designer|aegis)\b/i,
    nameExtractor: () => 'designer',
    relationship: 'depends-on',
  },
  {
    type: 'agent',
    pattern: /\b@?(librarian|provenance)\b/i,
    nameExtractor: () => 'librarian',
    relationship: 'depends-on',
  },
  {
    type: 'agent',
    pattern: /\b@?(fixer|vigil)\b/i,
    nameExtractor: () => 'fixer',
    relationship: 'depends-on',
  },
  {
    type: 'agent',
    pattern: /\b@?(windfixer)\b/i,
    nameExtractor: () => 'windfixer',
    relationship: 'depends-on',
  },
  {
    type: 'agent',
    pattern: /\b@?(openfixer)\b/i,
    nameExtractor: () => 'openfixer',
    relationship: 'depends-on',
  },
  {
    type: 'agent',
    pattern: /\b@?(forgewright)\b/i,
    nameExtractor: () => 'forgewright',
    relationship: 'depends-on',
  },
  {
    type: 'agent',
    pattern: /\b@?(explorer)\b/i,
    nameExtractor: () => 'explorer',
    relationship: 'depends-on',
  },
  {
    type: 'agent',
    pattern: /\b@?(four[\s_]?eyes)\b/i,
    nameExtractor: () => 'four_eyes',
    relationship: 'depends-on',
  },
];

/**
 * Tool/service patterns
 */
const TOOL_PATTERNS: DependencyPattern[] = [
  {
    type: 'tool',
    pattern: /\b(?:rag[\s-]?server|rag[\s-]?watcher|rag[\s-]?ingest)\b/i,
    nameExtractor: () => 'rag-server',
    relationship: 'depends-on',
  },
  {
    type: 'tool',
    pattern: /\b(?:decisions?[\s-]?server)\b/i,
    nameExtractor: () => 'decisions-server',
    relationship: 'depends-on',
  },
  {
    type: 'tool',
    pattern: /\b(?:toolhive|mcp[\s-]?optimizer)\b/i,
    nameExtractor: () => 'toolhive',
    relationship: 'depends-on',
  },
  {
    type: 'tool',
    pattern: /\b(?:difficulty[\s-]?classif(?:ier|ication))\b/i,
    nameExtractor: () => 'difficulty-classifier',
    relationship: 'related',
  },
  {
    type: 'tool',
    pattern: /\b(?:topology[\s-]?select(?:or|ion))\b/i,
    nameExtractor: () => 'topology-selector',
    relationship: 'related',
  },
];

/**
 * Service patterns
 */
const SERVICE_PATTERNS: DependencyPattern[] = [
  {
    type: 'service',
    pattern: /\b(?:mongo(?:db)?)\b/i,
    nameExtractor: () => 'mongodb',
    relationship: 'depends-on',
  },
  {
    type: 'service',
    pattern: /\b(?:chrome|cdp|devtools)\b/i,
    nameExtractor: () => 'chrome-cdp',
    relationship: 'depends-on',
  },
  {
    type: 'service',
    pattern: /\b(?:speech(?:ify)?|tts|text[\s-]?to[\s-]?speech)\b/i,
    nameExtractor: () => 'speechify',
    relationship: 'depends-on',
  },
  {
    type: 'service',
    pattern: /\b(?:arxiv|google[\s-]?scholar)\b/i,
    nameExtractor: () => 'arxiv',
    relationship: 'reads',
  },
];

/**
 * Directory patterns (Pantheon directories)
 */
const DIRECTORY_PATTERNS: DependencyPattern[] = [
  {
    type: 'directory',
    pattern: /\bSTR4TEG15T\b/,
    nameExtractor: () => 'STR4TEG15T',
    relationship: 'writes',
  },
  {
    type: 'directory',
    pattern: /\b0R4CL3\b/,
    nameExtractor: () => '0R4CL3',
    relationship: 'writes',
  },
  {
    type: 'directory',
    pattern: /\bD351GN3R\b/,
    nameExtractor: () => 'D351GN3R',
    relationship: 'writes',
  },
  {
    type: 'directory',
    pattern: /\bL1BR4R14N\b/,
    nameExtractor: () => 'L1BR4R14N',
    relationship: 'writes',
  },
  {
    type: 'directory',
    pattern: /\bC0D3F1X\b/,
    nameExtractor: () => 'C0D3F1X',
    relationship: 'writes',
  },
  {
    type: 'directory',
    pattern: /\bOP3NF1XER\b/,
    nameExtractor: () => 'OP3NF1XER',
    relationship: 'writes',
  },
  {
    type: 'directory',
    pattern: /\bH0UND\b/,
    nameExtractor: () => 'H0UND',
    relationship: 'writes',
  },
  {
    type: 'directory',
    pattern: /\bH4ND\b/,
    nameExtractor: () => 'H4ND',
    relationship: 'writes',
  },
  {
    type: 'directory',
    pattern: /\bC0MMON\b/,
    nameExtractor: () => 'C0MMON',
    relationship: 'writes',
  },
];

/**
 * Config patterns
 */
const CONFIG_PATTERNS: DependencyPattern[] = [
  {
    type: 'config',
    pattern: /\b(?:opencode\.json|oh-my-opencode-theseus\.json)\b/i,
    nameExtractor: (m) => m[0],
    relationship: 'writes',
  },
  {
    type: 'config',
    pattern: /\b(?:Claude\.json|claude\.json)\b/i,
    nameExtractor: (m) => m[0],
    relationship: 'writes',
  },
  {
    type: 'config',
    pattern: /\b(?:tsconfig\.json|package\.json|biome\.json)\b/i,
    nameExtractor: (m) => m[0],
    relationship: 'writes',
  },
  {
    type: 'config',
    pattern: /\bAGENTS\.md\b/,
    nameExtractor: () => 'AGENTS.md',
    relationship: 'writes',
  },
];

/**
 * All patterns combined
 */
const ALL_PATTERNS: DependencyPattern[] = [
  ...AGENT_PATTERNS,
  ...TOOL_PATTERNS,
  ...SERVICE_PATTERNS,
  ...DIRECTORY_PATTERNS,
  ...CONFIG_PATTERNS,
];

/**
 * Detect cross-cutting dependencies in text
 */
export function detectDependencies(
  text: string
): CrossCuttingDependency[] {
  const dependencies: CrossCuttingDependency[] = [];
  const seen = new Set<string>();

  for (const pattern of ALL_PATTERNS) {
    const match = text.match(pattern.pattern);
    if (match) {
      const name = pattern.nameExtractor(match);
      const key = `${pattern.type}:${name}:${pattern.relationship}`;

      if (!seen.has(key)) {
        seen.add(key);
        dependencies.push({
          type: pattern.type,
          name,
          relationship: pattern.relationship,
        });
      }
    }
  }

  // Sort by type for readability
  const typeOrder: Record<CrossCuttingDependency['type'], number> = {
    agent: 0,
    tool: 1,
    service: 2,
    config: 3,
    directory: 4,
  };

  dependencies.sort(
    (a, b) => typeOrder[a.type] - typeOrder[b.type]
  );

  return dependencies;
}

/**
 * Calculate dependency score (0-10)
 * More cross-cutting dependencies = higher complexity
 */
export function calculateDependencyScore(
  dependencies: CrossCuttingDependency[]
): number {
  if (dependencies.length === 0) return 0;

  // Weight by type
  const typeWeights: Record<CrossCuttingDependency['type'], number> = {
    agent: 1.5,
    tool: 1.2,
    service: 1.5,
    config: 0.8,
    directory: 0.5,
  };

  let weightedSum = 0;
  for (const dep of dependencies) {
    weightedSum += typeWeights[dep.type];
  }

  return Math.min(10, Math.round(weightedSum * 10) / 10);
}
