/**
 * Quality Check Functions
 * Individual check implementations for document quality
 * Part of DECISION_087 Phase 1 - COCO Pillar
 */

import type { QualityCheck } from './types.js';

/**
 * Check if document has valid YAML frontmatter metadata
 */
export function checkMetadata(content: string): QualityCheck {
  const hasFrontmatter = /^---\n[\s\S]*?\n---/.test(content);
  const hasDecisionId = /\*\*Decision ID\*\*:\s*DECISION_\d+/i.test(content);
  const hasStatus = /\*\*Status\*\*:\s*\w+/i.test(content);
  const hasCategory = /\*\*Category\*\*:\s*\w+/i.test(content);
  const hasPriority = /\*\*Priority\*\*:\s*\w+/i.test(content);
  const hasDate = /\*\*Date\*\*:\s*\d{4}-\d{2}-\d{2}/i.test(content);

  const checks = [
    hasFrontmatter || hasDecisionId,
    hasStatus,
    hasCategory,
    hasPriority,
    hasDate,
  ];
  const passCount = checks.filter(Boolean).length;
  const score = passCount / checks.length;

  return {
    name: 'metadata',
    passed: score >= 0.6,
    score,
    message:
      score >= 0.6
        ? `Metadata present (${passCount}/${checks.length} fields)`
        : `Missing metadata fields (only ${passCount}/${checks.length})`,
  };
}

/**
 * Check if document has required sections
 */
export function checkStructure(content: string): QualityCheck {
  const requiredSections = [
    /##\s+Executive Summary/i,
    /##\s+Specification/i,
    /##\s+Action Items/i,
    /##\s+Dependencies/i,
    /##\s+Risks/i,
    /##\s+Success Criteria/i,
  ];

  const optionalSections = [
    /##\s+Background/i,
    /##\s+Token Budget/i,
    /##\s+Bug-Fix Section/i,
    /##\s+Research/i,
    /##\s+Implementation/i,
  ];

  const requiredCount = requiredSections.filter((r) =>
    r.test(content)
  ).length;
  const optionalCount = optionalSections.filter((r) =>
    r.test(content)
  ).length;

  // Required sections count more heavily
  const requiredScore = requiredCount / requiredSections.length;
  const optionalScore = optionalCount / optionalSections.length;
  const score = requiredScore * 0.7 + optionalScore * 0.3;

  return {
    name: 'structure',
    passed: requiredScore >= 0.5,
    score: Math.round(score * 100) / 100,
    message:
      requiredScore >= 0.5
        ? `Structure valid (${requiredCount}/${requiredSections.length} required, ${optionalCount}/${optionalSections.length} optional)`
        : `Missing required sections (only ${requiredCount}/${requiredSections.length})`,
  };
}

/**
 * Check document content quality (length, completeness)
 */
export function checkContentQuality(content: string): QualityCheck {
  const wordCount = content.split(/\s+/).filter((w) => w.length > 0).length;
  const lineCount = content.split('\n').length;
  const hasCodeBlocks = /```[\s\S]*?```/.test(content);
  const hasTables = /\|.*\|.*\|/.test(content);
  const hasLinks = /\[.*\]\(.*\)/.test(content);

  // Minimum thresholds
  const isLongEnough = wordCount >= 100;
  const hasSubstance = lineCount >= 20;
  const hasRichContent = hasCodeBlocks || hasTables || hasLinks;

  const checks = [isLongEnough, hasSubstance, hasRichContent];
  const passCount = checks.filter(Boolean).length;
  const score = passCount / checks.length;

  return {
    name: 'content-quality',
    passed: score >= 0.66,
    score: Math.round(score * 100) / 100,
    message:
      score >= 0.66
        ? `Content quality acceptable (${wordCount} words, ${lineCount} lines)`
        : `Content too thin (${wordCount} words, ${lineCount} lines, rich=${hasRichContent})`,
  };
}

/**
 * Check for approval ratings and consultation evidence
 */
export function checkApprovalEvidence(content: string): QualityCheck {
  const hasOracleApproval = /Oracle[\s_-]?Approval.*?\d+%/i.test(content);
  const hasDesignerApproval = /Designer[\s_-]?Approval.*?\d+%/i.test(content);
  const hasConsultationLog = /##\s+Research.*?Consultation.*?Log/i.test(content) ||
    /###\s+Loop\s+\d+/i.test(content);
  const hasActionItems = /\|\s*ACT-\d+/i.test(content);

  const checks = [
    hasOracleApproval,
    hasDesignerApproval,
    hasConsultationLog,
    hasActionItems,
  ];
  const passCount = checks.filter(Boolean).length;
  const score = passCount / checks.length;

  return {
    name: 'approval-evidence',
    passed: score >= 0.5,
    score: Math.round(score * 100) / 100,
    message:
      score >= 0.5
        ? `Approval evidence present (${passCount}/${checks.length})`
        : `Missing approval evidence (only ${passCount}/${checks.length}: oracle=${hasOracleApproval}, designer=${hasDesignerApproval})`,
  };
}

/**
 * Check for cross-references and dependencies
 */
export function checkReferences(content: string): QualityCheck {
  const decisionRefs = content.match(/DECISION_\d+/g) || [];
  const uniqueRefs = new Set(decisionRefs);
  const hasBlocks = /Blocks|Blocked By/i.test(content);
  const hasRelated = /Related/i.test(content);

  // Self-reference (the decision's own ID) doesn't count
  const externalRefCount = Math.max(0, uniqueRefs.size - 1);
  const hasExternalRefs = externalRefCount > 0;

  const checks = [hasExternalRefs, hasBlocks, hasRelated];
  const passCount = checks.filter(Boolean).length;
  const score = passCount / checks.length;

  return {
    name: 'references',
    passed: score >= 0.33,
    score: Math.round(score * 100) / 100,
    message: `References: ${externalRefCount} external decisions, blocks=${hasBlocks}, related=${hasRelated}`,
  };
}

/**
 * Run all quality checks on a document
 */
export function runAllChecks(content: string): QualityCheck[] {
  return [
    checkMetadata(content),
    checkStructure(content),
    checkContentQuality(content),
    checkApprovalEvidence(content),
    checkReferences(content),
  ];
}

/**
 * Calculate overall quality score from individual checks
 * Weighted average: metadata (25%), structure (25%), content (20%), approval (20%), references (10%)
 */
export function calculateOverallScore(checks: QualityCheck[]): number {
  const weights: Record<string, number> = {
    metadata: 0.25,
    structure: 0.25,
    'content-quality': 0.20,
    'approval-evidence': 0.20,
    references: 0.10,
  };

  let weightedSum = 0;
  let totalWeight = 0;

  for (const check of checks) {
    const weight = weights[check.name] || 0.1;
    weightedSum += check.score * weight;
    totalWeight += weight;
  }

  return totalWeight > 0
    ? Math.round((weightedSum / totalWeight) * 100) / 100
    : 0;
}
