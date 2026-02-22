/**
 * Concern Detection Module
 * Identifies distinct concerns within a query using regex patterns
 * Part of DECISION_087 Phase 1
 */

import type { ConcernCategory, DetectedConcern } from './types.js';

/**
 * Concern pattern definition
 */
interface ConcernPattern {
  category: ConcernCategory;
  patterns: RegExp[];
  description: string;
  weight: number; // How much this concern affects difficulty
}

/**
 * Master concern pattern list
 * Each pattern group detects a category of concern
 */
const CONCERN_PATTERNS: ConcernPattern[] = [
  {
    category: 'architecture',
    patterns: [
      /\b(?:architect(?:ure|ural)?|refactor(?:ing)?|restructur(?:e|ing)|redesign|re-?architect)\b/i,
      /\b(?:micro[-\s]?service|monolith|service[\s-]?mesh|event[\s-]?driven|cqrs|ddd)\b/i,
      /\b(?:component|module|layer|tier|hierarchy|separation[\s-]?of[\s-]?concerns)\b/i,
      /\b(?:dependency[\s-]?inject(?:ion)?|inversion[\s-]?of[\s-]?control|ioc|di[\s-]?container)\b/i,
      /\b(?:pattern|design[\s-]?pattern|factory|singleton|observer|strategy|adapter)\b/i,
    ],
    description: 'Architectural design or restructuring concerns',
    weight: 1.5,
  },
  {
    category: 'security',
    patterns: [
      /\b(?:secur(?:ity|e|ing)|auth(?:enticat(?:ion|e)|oriz(?:ation|e))|credential|secret|encrypt(?:ion)?)\b/i,
      /\b(?:vulnerabilit(?:y|ies)|exploit|attack|threat|csrf|xss|injection|sanitiz(?:e|ation))\b/i,
      /\b(?:token|jwt|oauth|api[\s-]?key|certificate|ssl|tls|https)\b/i,
      /\b(?:permission|role[\s-]?based|rbac|access[\s-]?control|privilege|firewall)\b/i,
    ],
    description: 'Security, authentication, or authorization concerns',
    weight: 2.0,
  },
  {
    category: 'performance',
    patterns: [
      /\b(?:perform(?:ance)?|optimi(?:z(?:e|ation)|s(?:e|ation))|speed|fast(?:er)?|slow(?:er)?|latency)\b/i,
      /\b(?:cach(?:e|ing)|memory[\s-]?leak|bottleneck|throughput|bandwidth|scalab(?:le|ility))\b/i,
      /\b(?:profil(?:e|ing)|benchmark|load[\s-]?test|stress[\s-]?test|cpu|ram|disk[\s-]?io)\b/i,
      /\b(?:lazy[\s-]?load|pagination|batch(?:ing)?|parallel(?:is(?:m|ation))?|concurrent)\b/i,
    ],
    description: 'Performance optimization or scalability concerns',
    weight: 1.3,
  },
  {
    category: 'integration',
    patterns: [
      /\b(?:integrat(?:e|ion|ing)|api|endpoint|webhook|callback|third[\s-]?party)\b/i,
      /\b(?:mcp|rag|mongodb|database|redis|queue|kafka|rabbitmq|message[\s-]?broker)\b/i,
      /\b(?:rest(?:ful)?|graphql|grpc|websocket|http|protocol|sdk)\b/i,
      /\b(?:import|export|sync(?:hroniz(?:e|ation))?|data[\s-]?exchange|etl|pipeline)\b/i,
    ],
    description: 'Integration with external systems or services',
    weight: 1.2,
  },
  {
    category: 'data-model',
    patterns: [
      /\b(?:data[\s-]?model|schema|migration|database[\s-]?design|entity|relation(?:ship)?)\b/i,
      /\b(?:collection|table|index|query[\s-]?optimi(?:z|s)ation|normali(?:z|s)ation)\b/i,
      /\b(?:json[\s-]?schema|zod|validation|type[\s-]?safe(?:ty)?|typescript[\s-]?type)\b/i,
      /\b(?:crud|repository|dao|orm|mongoose|prisma)\b/i,
    ],
    description: 'Data modeling, schema, or database concerns',
    weight: 1.1,
  },
  {
    category: 'ui-ux',
    patterns: [
      /\b(?:ui|ux|user[\s-]?interface|user[\s-]?experience|frontend|front[\s-]?end)\b/i,
      /\b(?:component|widget|layout|responsive|mobile|accessibility|a11y)\b/i,
      /\b(?:css|style|theme|dark[\s-]?mode|animation|transition)\b/i,
      /\b(?:form|input|button|modal|dialog|toast|notification)\b/i,
    ],
    description: 'User interface or experience concerns',
    weight: 1.0,
  },
  {
    category: 'testing',
    patterns: [
      /\b(?:test(?:ing)?|unit[\s-]?test|integration[\s-]?test|e2e|end[\s-]?to[\s-]?end)\b/i,
      /\b(?:mock(?:ing)?|stub|fixture|assertion|coverage|tdd|bdd)\b/i,
      /\b(?:ci[\s-]?cd|continuous[\s-]?integration|pipeline|github[\s-]?actions)\b/i,
      /\b(?:regression|smoke[\s-]?test|acceptance|qa|quality[\s-]?assurance)\b/i,
    ],
    description: 'Testing, quality assurance, or CI/CD concerns',
    weight: 1.0,
  },
  {
    category: 'deployment',
    patterns: [
      /\b(?:deploy(?:ment|ing)?|release|publish|ship(?:ping)?|rollout)\b/i,
      /\b(?:docker|container|kubernetes|k8s|helm|terraform|infrastructure)\b/i,
      /\b(?:environment|staging|production|dev(?:elopment)?|config(?:uration)?[\s-]?manage(?:ment)?)\b/i,
      /\b(?:rollback|blue[\s-]?green|canary|feature[\s-]?flag|toggle)\b/i,
    ],
    description: 'Deployment, infrastructure, or release concerns',
    weight: 1.2,
  },
  {
    category: 'documentation',
    patterns: [
      /\b(?:document(?:ation|ing)?|readme|guide|tutorial|reference|wiki)\b/i,
      /\b(?:comment|jsdoc|tsdoc|api[\s-]?doc|changelog|release[\s-]?note)\b/i,
      /\b(?:spec(?:ification)?|requirement|design[\s-]?doc|rfc|adr)\b/i,
    ],
    description: 'Documentation or specification concerns',
    weight: 0.7,
  },
  {
    category: 'tooling',
    patterns: [
      /\b(?:tool(?:ing)?|cli|command[\s-]?line|script|automation|workflow)\b/i,
      /\b(?:linter|formatter|bundler|compiler|transpiler|build[\s-]?tool)\b/i,
      /\b(?:bun|npm|yarn|pnpm|webpack|vite|eslint|biome|prettier)\b/i,
    ],
    description: 'Tooling, build system, or developer experience concerns',
    weight: 0.8,
  },
  {
    category: 'process',
    patterns: [
      /\b(?:process|workflow|protocol|procedure|standard|convention)\b/i,
      /\b(?:decision|approval|review|consultation|handoff|delegation)\b/i,
      /\b(?:agent|sub[\s-]?agent|orchestrat(?:or|ion)|strateg(?:ist|y))\b/i,
      /\b(?:iteration|phase|milestone|sprint|roadmap|timeline)\b/i,
    ],
    description: 'Process, workflow, or organizational concerns',
    weight: 0.9,
  },
];

/**
 * Detect concerns in a text query
 */
export function detectConcerns(text: string): DetectedConcern[] {
  const concerns: DetectedConcern[] = [];

  for (const pattern of CONCERN_PATTERNS) {
    const matchedKeywords: string[] = [];
    let totalMatches = 0;

    for (const regex of pattern.patterns) {
      const matches = text.match(new RegExp(regex, 'gi'));
      if (matches) {
        totalMatches += matches.length;
        for (const match of matches) {
          if (!matchedKeywords.includes(match.toLowerCase())) {
            matchedKeywords.push(match.toLowerCase());
          }
        }
      }
    }

    if (matchedKeywords.length > 0) {
      // Calculate confidence based on number of distinct keywords matched
      const confidence = Math.min(
        1.0,
        (matchedKeywords.length * 0.25 + totalMatches * 0.1) * pattern.weight
      );

      concerns.push({
        category: pattern.category,
        keywords: matchedKeywords,
        confidence: Math.round(confidence * 100) / 100,
        description: pattern.description,
      });
    }
  }

  // Sort by confidence descending
  concerns.sort((a, b) => b.confidence - a.confidence);

  return concerns;
}

/**
 * Calculate concern score (0-10)
 * Based on number and weight of detected concerns
 */
export function calculateConcernScore(concerns: DetectedConcern[]): number {
  if (concerns.length === 0) return 0;
  if (concerns.length === 1) return 3;
  if (concerns.length === 2) return 5;
  if (concerns.length === 3) return 6;
  if (concerns.length === 4) return 7;
  if (concerns.length <= 6) return 8;
  return Math.min(10, 8 + (concerns.length - 6) * 0.5);
}
