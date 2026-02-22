/**
 * YAML Frontmatter Parser
 * Extracts and parses YAML frontmatter from markdown files
 */

import YAML from 'yaml';
import { logger } from './logger.js';

export interface ParsedDocument {
  metadata: Record<string, unknown>;
  body: string;
  raw: string;
}

export interface ValidationResult {
  valid: boolean;
  errors: string[];
}

const FRONTMATTER_REGEX = /^---\s*\n([\s\S]*?)\n---\s*\n([\s\S]*)$/;

/**
 * Parse YAML frontmatter from markdown content
 */
export function parseFrontmatter(content: string): ParsedDocument {
  const match = content.match(FRONTMATTER_REGEX);

  if (!match) {
    logger.debug('No frontmatter found, treating entire content as body');
    return {
      metadata: {},
      body: content.trim(),
      raw: content,
    };
  }

  try {
    const metadata = YAML.parse(match[1]) as Record<string, unknown>;
    const body = match[2].trim();

    logger.debug('Parsed frontmatter', { 
      metadataKeys: Object.keys(metadata),
      bodyLength: body.length 
    });

    return {
      metadata,
      body,
      raw: content,
    };
  } catch (error) {
    logger.error('Failed to parse YAML frontmatter', { 
      error: error instanceof Error ? error.message : String(error) 
    });
    
    // Return empty metadata if YAML parsing fails
    return {
      metadata: {},
      body: content.trim(),
      raw: content,
    };
  }
}

/**
 * Check if content has valid frontmatter
 */
export function hasFrontmatter(content: string): boolean {
  return FRONTMATTER_REGEX.test(content);
}

/**
 * Extract title from document body (first H1 heading)
 */
export function extractTitle(body: string): string | null {
  const match = body.match(/^#\s+(.+)$/m);
  return match ? match[1].trim() : null;
}

/**
 * Extract summary from document body (first paragraph)
 */
export function extractSummary(body: string): string | null {
  const lines = body.split('\n');
  const paragraphs: string[] = [];
  
  for (const line of lines) {
    const trimmed = line.trim();
    if (trimmed && !trimmed.startsWith('#') && !trimmed.startsWith('---')) {
      paragraphs.push(trimmed);
    } else if (paragraphs.length > 0) {
      break;
    }
  }

  const summary = paragraphs.join(' ');
  return summary.length > 0 ? summary.slice(0, 500) : null;
}

/**
 * Parse a markdown file and return structured data
 */
export function parseDocument(content: string, filePath: string): ParsedDocument {
  const parsed = parseFrontmatter(content);
  
  // Add derived fields if not present
  if (!parsed.metadata.title) {
    const title = extractTitle(parsed.body);
    if (title) {
      parsed.metadata.title = title;
    }
  }

  if (!parsed.metadata.summary) {
    const summary = extractSummary(parsed.body);
    if (summary) {
      parsed.metadata.summary = summary;
    }
  }

  // Add source path
  parsed.metadata.source = filePath;

  // Ensure created timestamp exists
  if (!parsed.metadata.created) {
    parsed.metadata.created = new Date().toISOString();
  }

  // Ensure updated timestamp exists
  if (!parsed.metadata.updated) {
    parsed.metadata.updated = new Date().toISOString();
  }

  // Set default schema version
  if (!parsed.metadata.schemaVer) {
    parsed.metadata.schemaVer = '1.0.0';
  }

  return parsed;
}
