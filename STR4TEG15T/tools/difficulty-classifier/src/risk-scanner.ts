/**
 * Risk Keyword Scanner
 * Detects risk-related keywords and phrases in queries
 * Part of DECISION_087 Phase 1
 */

import type { RiskIndicator, RiskSeverity } from './types.js';

/**
 * Risk keyword pattern definition
 */
interface RiskPattern {
  pattern: RegExp;
  severity: RiskSeverity;
  contextWindow: number; // chars around match to capture
}

/**
 * Risk keyword patterns organized by severity
 */
const RISK_PATTERNS: RiskPattern[] = [
  // Critical risk keywords
  {
    pattern: /\b(?:break(?:ing)?\s+change|backward[s]?\s+incompatib(?:le|ility))\b/i,
    severity: 'critical',
    contextWindow: 80,
  },
  {
    pattern: /\b(?:data\s+loss|data\s+corrupt(?:ion)?|irreversib(?:le|ly))\b/i,
    severity: 'critical',
    contextWindow: 80,
  },
  {
    pattern: /\b(?:production\s+(?:down|outage|failure)|system\s+crash)\b/i,
    severity: 'critical',
    contextWindow: 80,
  },
  {
    pattern: /\b(?:security\s+vulnerabilit(?:y|ies)|exploit(?:able)?|zero[\s-]day)\b/i,
    severity: 'critical',
    contextWindow: 80,
  },
  {
    pattern: /\b(?:credential\s+(?:leak|exposure)|secret\s+(?:leak|exposure))\b/i,
    severity: 'critical',
    contextWindow: 80,
  },

  // High risk keywords
  {
    pattern: /\b(?:critical|mission[\s-]critical|blocking|blocker)\b/i,
    severity: 'high',
    contextWindow: 60,
  },
  {
    pattern: /\b(?:migration|database\s+migration|schema\s+migration)\b/i,
    severity: 'high',
    contextWindow: 60,
  },
  {
    pattern: /\b(?:deprecat(?:e|ed|ion|ing)|removal|removing)\b/i,
    severity: 'high',
    contextWindow: 60,
  },
  {
    pattern: /\b(?:rewrite|complete\s+rewrite|from\s+scratch)\b/i,
    severity: 'high',
    contextWindow: 60,
  },
  {
    pattern: /\b(?:security|authentication|authorization)\b/i,
    severity: 'high',
    contextWindow: 60,
  },
  {
    pattern: /\b(?:rollback|revert|undo|downgrade)\b/i,
    severity: 'high',
    contextWindow: 60,
  },

  // Medium risk keywords
  {
    pattern: /\b(?:refactor(?:ing)?|restructur(?:e|ing))\b/i,
    severity: 'medium',
    contextWindow: 40,
  },
  {
    pattern: /\b(?:performance|latency|timeout|bottleneck)\b/i,
    severity: 'medium',
    contextWindow: 40,
  },
  {
    pattern: /\b(?:dependency|version\s+(?:bump|update|upgrade))\b/i,
    severity: 'medium',
    contextWindow: 40,
  },
  {
    pattern: /\b(?:concurrent|race\s+condition|deadlock|thread[\s-]safe)\b/i,
    severity: 'medium',
    contextWindow: 40,
  },
  {
    pattern: /\b(?:cross[\s-]cutting|cross[\s-]platform|backward[\s-]compat(?:ible|ibility))\b/i,
    severity: 'medium',
    contextWindow: 40,
  },

  // Low risk keywords
  {
    pattern: /\b(?:config(?:uration)?\s+change|setting\s+update)\b/i,
    severity: 'low',
    contextWindow: 30,
  },
  {
    pattern: /\b(?:add(?:ing)?\s+feature|new\s+feature|enhancement)\b/i,
    severity: 'low',
    contextWindow: 30,
  },
  {
    pattern: /\b(?:documentation|comment|readme|typo|formatting)\b/i,
    severity: 'low',
    contextWindow: 30,
  },
  {
    pattern: /\b(?:style|cosmetic|cleanup|lint)\b/i,
    severity: 'low',
    contextWindow: 30,
  },
];

/**
 * Extract context around a match
 */
function extractContext(
  text: string,
  matchIndex: number,
  matchLength: number,
  windowSize: number
): string {
  const start = Math.max(0, matchIndex - windowSize);
  const end = Math.min(text.length, matchIndex + matchLength + windowSize);
  let context = text.slice(start, end).trim();

  // Add ellipsis if truncated
  if (start > 0) context = `...${context}`;
  if (end < text.length) context = `${context}...`;

  // Clean up whitespace
  return context.replace(/\s+/g, ' ');
}

/**
 * Scan text for risk indicators
 */
export function scanRisks(text: string): RiskIndicator[] {
  const risks: RiskIndicator[] = [];
  const seenKeywords = new Set<string>();

  for (const riskPattern of RISK_PATTERNS) {
    const globalRegex = new RegExp(riskPattern.pattern, 'gi');
    let match: RegExpExecArray | null;

    while ((match = globalRegex.exec(text)) !== null) {
      const keyword = match[0].toLowerCase();

      // Deduplicate keywords
      if (seenKeywords.has(keyword)) continue;
      seenKeywords.add(keyword);

      const context = extractContext(
        text,
        match.index,
        match[0].length,
        riskPattern.contextWindow
      );

      risks.push({
        keyword: match[0],
        severity: riskPattern.severity,
        context,
      });
    }
  }

  // Sort by severity (critical first)
  const severityOrder: Record<RiskSeverity, number> = {
    critical: 0,
    high: 1,
    medium: 2,
    low: 3,
  };

  risks.sort((a, b) => severityOrder[a.severity] - severityOrder[b.severity]);

  return risks;
}

/**
 * Calculate risk score (0-10)
 * Based on number and severity of detected risks
 */
export function calculateRiskScore(risks: RiskIndicator[]): number {
  if (risks.length === 0) return 0;

  const severityWeights: Record<RiskSeverity, number> = {
    critical: 4.0,
    high: 2.5,
    medium: 1.5,
    low: 0.5,
  };

  let weightedSum = 0;
  for (const risk of risks) {
    weightedSum += severityWeights[risk.severity];
  }

  return Math.min(10, Math.round(weightedSum * 10) / 10);
}
