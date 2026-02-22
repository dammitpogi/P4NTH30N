/**
 * JSON Schema Validator
 * Validates parsed documents against the agent documentation schema
 */

import { logger } from './logger.js';
import type { ParsedDocument } from './parser.js';

// Schema validation rules (simplified inline version)
const VALID_AGENTS = ['strategist', 'oracle', 'designer', 'librarian', 'fixer', 'windfixer', 'openfixer', 'forgewright'];
const VALID_TYPES = ['decision', 'assessment', 'consultation', 'architecture', 'research', 'implementation', 'handoff', 'pattern', 'bugfix', 'discovery', 'output', 'plan', 'brief', 'reference'];
const VALID_STATUSES = ['draft', 'active', 'archived', 'deleted', 'canon'];
const VALID_PRIORITIES = ['critical', 'high', 'medium', 'low'];

export interface ValidationError {
  field: string;
  message: string;
  value?: unknown;
}

export interface ValidationResult {
  valid: boolean;
  errors: ValidationError[];
  warnings: ValidationError[];
}

/**
 * Validate a parsed document against the schema
 */
export function validateDocument(doc: ParsedDocument): ValidationResult {
  const errors: ValidationError[] = [];
  const warnings: ValidationError[] = [];

  const { metadata } = doc;

  // Required fields
  if (!metadata.agent) {
    errors.push({ field: 'agent', message: 'Agent is required' });
  } else if (!VALID_AGENTS.includes(metadata.agent as string)) {
    errors.push({ 
      field: 'agent', 
      message: `Invalid agent. Must be one of: ${VALID_AGENTS.join(', ')}`,
      value: metadata.agent 
    });
  }

  if (!metadata.type) {
    errors.push({ field: 'type', message: 'Type is required' });
  } else if (!VALID_TYPES.includes(metadata.type as string)) {
    errors.push({ 
      field: 'type', 
      message: `Invalid type. Must be one of: ${VALID_TYPES.join(', ')}`,
      value: metadata.type 
    });
  }

  if (!metadata.created) {
    errors.push({ field: 'created', message: 'Created timestamp is required' });
  } else if (!isValidISO8601(metadata.created as string)) {
    errors.push({ 
      field: 'created', 
      message: 'Created must be a valid ISO 8601 timestamp',
      value: metadata.created 
    });
  }

  if (!metadata.status) {
    errors.push({ field: 'status', message: 'Status is required' });
  } else if (!VALID_STATUSES.includes(metadata.status as string)) {
    errors.push({ 
      field: 'status', 
      message: `Invalid status. Must be one of: ${VALID_STATUSES.join(', ')}`,
      value: metadata.status 
    });
  }

  // Optional field validations
  if (metadata.updated && !isValidISO8601(metadata.updated as string)) {
    warnings.push({ 
      field: 'updated', 
      message: 'Updated should be a valid ISO 8601 timestamp',
      value: metadata.updated 
    });
  }

  if (metadata.priority && !VALID_PRIORITIES.includes(metadata.priority as string)) {
    warnings.push({ 
      field: 'priority', 
      message: `Priority should be one of: ${VALID_PRIORITIES.join(', ')}`,
      value: metadata.priority 
    });
  }

  if (metadata.schemaVer && !isValidSemver(metadata.schemaVer as string)) {
    warnings.push({ 
      field: 'schemaVer', 
      message: 'Schema version should be valid semver (e.g., 1.0.0)',
      value: metadata.schemaVer 
    });
  }

  if (metadata.gitCommit && !isValidGitCommit(metadata.gitCommit as string)) {
    warnings.push({ 
      field: 'gitCommit', 
      message: 'Git commit should be a 40-character hex string',
      value: metadata.gitCommit 
    });
  }

  // Tags validation
  if (metadata.tags) {
    if (!Array.isArray(metadata.tags)) {
      warnings.push({ 
        field: 'tags', 
        message: 'Tags should be an array',
        value: metadata.tags 
      });
    } else {
      for (const tag of metadata.tags) {
        if (!/^[a-z0-9-]+$/.test(tag as string)) {
          warnings.push({ 
            field: 'tags', 
            message: `Tag "${tag}" should only contain lowercase letters, numbers, and hyphens`,
            value: tag 
          });
        }
      }
    }
  }

  // Decision ID validation
  if (metadata.decision) {
    const decisionPattern = /^(DECISION|FORGE|INFRA|OPS|STRATEGY)-[0-9]+$/;
    if (!decisionPattern.test(metadata.decision as string)) {
      warnings.push({ 
        field: 'decision', 
        message: 'Decision ID should match pattern: CATEGORY-NNN',
        value: metadata.decision 
      });
    }
  }

  // Body validation
  if (!doc.body || doc.body.trim().length === 0) {
    errors.push({ field: 'body', message: 'Document body is required' });
  }

  const result: ValidationResult = {
    valid: errors.length === 0,
    errors,
    warnings,
  };

  logger.debug('Validation result', { 
    valid: result.valid, 
    errorCount: errors.length, 
    warningCount: warnings.length 
  });

  return result;
}

/**
 * Check if string is valid ISO 8601 timestamp
 */
function isValidISO8601(str: string): boolean {
  const iso8601Regex = /^\d{4}-\d{2}-\d{2}T\d{2}:\d{2}:\d{2}(\.\d{3})?Z?$/;
  if (!iso8601Regex.test(str)) return false;
  
  const date = new Date(str);
  return !isNaN(date.getTime());
}

/**
 * Check if string is valid semver
 */
function isValidSemver(str: string): boolean {
  const semverRegex = /^\d+\.\d+\.\d+$/;
  return semverRegex.test(str);
}

/**
 * Check if string is valid git commit hash
 */
function isValidGitCommit(str: string): boolean {
  const commitRegex = /^[a-f0-9]{40}$/;
  return commitRegex.test(str);
}

/**
 * Format validation errors for display
 */
export function formatValidationErrors(result: ValidationResult): string {
  const lines: string[] = [];

  if (result.errors.length > 0) {
    lines.push('Errors:');
    for (const error of result.errors) {
      lines.push(`  - ${error.field}: ${error.message}`);
    }
  }

  if (result.warnings.length > 0) {
    lines.push('Warnings:');
    for (const warning of result.warnings) {
      lines.push(`  - ${warning.field}: ${warning.message}`);
    }
  }

  return lines.join('\n');
}
