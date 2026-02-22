/**
 * Topology Profiles
 * Defines characteristics and agent configurations for each topology
 * Part of DECISION_087 Phase 1
 */

import type {
  TopologyProfile,
  AgentPoolConfig,
  Topology,
  DifficultyLevel,
} from './types.js';

/**
 * Topology profiles with performance characteristics
 */
export const TOPOLOGY_PROFILES: Record<Topology, TopologyProfile> = {
  sequential: {
    topology: 'sequential',
    description:
      'Linear execution: each agent completes before the next starts. ' +
      'Best for simple tasks with clear dependencies.',
    bestFor: [
      'Simple changes',
      'Documentation updates',
      'Config changes',
      'Single-concern tasks',
    ],
    agentPattern: 'Strategist → Oracle → Designer → Fixer',
    avgDurationMinutes: { simple: 10, moderate: 25, complex: 45 },
    avgTokens: { simple: 15000, moderate: 50000, complex: 120000 },
    parallelismLevel: 1,
  },

  parallel: {
    topology: 'parallel',
    description:
      'Concurrent execution: Oracle + Designer + Librarian run simultaneously. ' +
      'Best for moderate tasks where consultation can be parallelized.',
    bestFor: [
      'Feature implementation',
      'Multi-concern tasks',
      'Research-backed decisions',
      'Standard architecture changes',
    ],
    agentPattern:
      'Strategist → [Oracle | Designer | Librarian] → Fixer',
    avgDurationMinutes: { simple: 8, moderate: 18, complex: 35 },
    avgTokens: { simple: 20000, moderate: 65000, complex: 150000 },
    parallelismLevel: 3,
  },

  hierarchical: {
    topology: 'hierarchical',
    description:
      'Five-level hierarchy (HMAW): Strategic → Architectural → Operational → Tactical → Execution. ' +
      'Best for complex, cross-cutting changes requiring coordinated multi-agent work.',
    bestFor: [
      'Complex architecture changes',
      'Security-critical decisions',
      'Cross-cutting concerns',
      'Multi-phase implementations',
    ],
    agentPattern:
      'Strategist → [Oracle + Designer] → Librarian → [WindFixer | OpenFixer] → Forgewright',
    avgDurationMinutes: { simple: 15, moderate: 30, complex: 60 },
    avgTokens: { simple: 30000, moderate: 80000, complex: 200000 },
    parallelismLevel: 2,
  },

  hybrid: {
    topology: 'hybrid',
    description:
      'Adaptive combination: parallel consultation phase followed by hierarchical implementation. ' +
      'Best for complex tasks that benefit from both patterns.',
    bestFor: [
      'Large-scale refactoring',
      'Platform-wide changes',
      'Multi-agent coordination',
      'Research-heavy + implementation tasks',
    ],
    agentPattern:
      'Strategist → [Oracle | Designer | Librarian] → Hierarchical Implementation',
    avgDurationMinutes: { simple: 12, moderate: 25, complex: 50 },
    avgTokens: { simple: 25000, moderate: 70000, complex: 180000 },
    parallelismLevel: 4,
  },
};

/**
 * Agent pool configurations for each topology x difficulty
 */
export function getAgentPool(
  topology: Topology,
  difficulty: DifficultyLevel
): AgentPoolConfig {
  switch (topology) {
    case 'sequential':
      return getSequentialPool(difficulty);
    case 'parallel':
      return getParallelPool(difficulty);
    case 'hierarchical':
      return getHierarchicalPool(difficulty);
    case 'hybrid':
      return getHybridPool(difficulty);
  }
}

function getSequentialPool(difficulty: DifficultyLevel): AgentPoolConfig {
  if (difficulty === 'simple') {
    return {
      required: ['strategist', 'oracle', 'windfixer'],
      optional: [],
      parallelGroups: [],
      sequentialOrder: ['strategist', 'oracle', 'windfixer'],
    };
  }
  if (difficulty === 'moderate') {
    return {
      required: ['strategist', 'oracle', 'designer', 'windfixer'],
      optional: ['librarian'],
      parallelGroups: [],
      sequentialOrder: [
        'strategist',
        'oracle',
        'designer',
        'windfixer',
      ],
    };
  }
  // complex
  return {
    required: [
      'strategist',
      'oracle',
      'designer',
      'librarian',
      'windfixer',
    ],
    optional: ['openfixer', 'forgewright'],
    parallelGroups: [],
    sequentialOrder: [
      'strategist',
      'oracle',
      'designer',
      'librarian',
      'windfixer',
    ],
  };
}

function getParallelPool(difficulty: DifficultyLevel): AgentPoolConfig {
  if (difficulty === 'simple') {
    return {
      required: ['strategist', 'oracle', 'designer', 'windfixer'],
      optional: [],
      parallelGroups: [['oracle', 'designer']],
      sequentialOrder: ['strategist', 'windfixer'],
    };
  }
  if (difficulty === 'moderate') {
    return {
      required: [
        'strategist',
        'oracle',
        'designer',
        'librarian',
        'windfixer',
      ],
      optional: ['explorer'],
      parallelGroups: [['oracle', 'designer', 'librarian']],
      sequentialOrder: ['strategist', 'windfixer'],
    };
  }
  // complex
  return {
    required: [
      'strategist',
      'oracle',
      'designer',
      'librarian',
      'explorer',
      'windfixer',
      'openfixer',
    ],
    optional: ['forgewright'],
    parallelGroups: [
      ['oracle', 'designer', 'librarian'],
      ['windfixer', 'openfixer'],
    ],
    sequentialOrder: ['strategist', 'explorer'],
  };
}

function getHierarchicalPool(
  difficulty: DifficultyLevel
): AgentPoolConfig {
  if (difficulty === 'simple') {
    return {
      required: ['strategist', 'oracle', 'windfixer'],
      optional: ['designer'],
      parallelGroups: [['oracle', 'designer']],
      sequentialOrder: ['strategist', 'windfixer'],
    };
  }
  if (difficulty === 'moderate') {
    return {
      required: [
        'strategist',
        'oracle',
        'designer',
        'librarian',
        'windfixer',
      ],
      optional: ['openfixer'],
      parallelGroups: [['oracle', 'designer']],
      sequentialOrder: [
        'strategist',
        'librarian',
        'windfixer',
      ],
    };
  }
  // complex
  return {
    required: [
      'strategist',
      'oracle',
      'designer',
      'librarian',
      'windfixer',
      'openfixer',
      'forgewright',
    ],
    optional: ['explorer'],
    parallelGroups: [
      ['oracle', 'designer'],
      ['windfixer', 'openfixer'],
    ],
    sequentialOrder: [
      'strategist',
      'librarian',
      'forgewright',
    ],
  };
}

function getHybridPool(difficulty: DifficultyLevel): AgentPoolConfig {
  if (difficulty === 'simple') {
    return {
      required: [
        'strategist',
        'oracle',
        'designer',
        'windfixer',
      ],
      optional: ['librarian'],
      parallelGroups: [['oracle', 'designer']],
      sequentialOrder: ['strategist', 'windfixer'],
    };
  }
  if (difficulty === 'moderate') {
    return {
      required: [
        'strategist',
        'oracle',
        'designer',
        'librarian',
        'windfixer',
      ],
      optional: ['explorer', 'openfixer'],
      parallelGroups: [
        ['oracle', 'designer', 'librarian'],
      ],
      sequentialOrder: ['strategist', 'windfixer'],
    };
  }
  // complex
  return {
    required: [
      'strategist',
      'oracle',
      'designer',
      'librarian',
      'explorer',
      'windfixer',
      'openfixer',
    ],
    optional: ['forgewright'],
    parallelGroups: [
      ['oracle', 'designer', 'librarian'],
      ['windfixer', 'openfixer'],
    ],
    sequentialOrder: ['strategist', 'explorer', 'forgewright'],
  };
}
