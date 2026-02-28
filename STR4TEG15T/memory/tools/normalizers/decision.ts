import { parseDocument } from '../parser';
import { sanitizeId, sanitizeKeywords } from '../utils/validation';
import type { DocumentMetadata, NormalizedDocument } from '../types';

export function extractDecisionId(sourcePath: string, content: string): string {
  // Try to extract from filename
  const filename = sourcePath.split('/').pop() || '';
  const match = filename.match(/(DECISION_\d+|DECISION-[A-Z]+-\d+)/i);
  if (match) {
    return sanitizeId(match[1]);
  }
  
  // Try to extract from content
  const contentMatch = content.match(/DECISION[_-]?\d+/i);
  if (contentMatch) {
    return sanitizeId(contentMatch[0]);
  }
  
  // Generate from filename
  return sanitizeId(filename.replace('.md', ''));
}

export function extractKeywords(content: string): string[] {
  const keywords = new Set<string>();
  
  // Extract from headers
  const headerMatches = content.match(/^#{1,3}\s+(.+)$/gm);
  if (headerMatches) {
    for (const match of headerMatches) {
      const words = match.replace(/^#+\s+/, '').split(/\s+/);
      for (const word of words) {
        const clean = word.toLowerCase().replace(/[^a-z0-9]/g, '');
        if (clean.length >= 3) keywords.add(clean);
      }
    }
  }
  
  // Extract significant words from content
  const words = content.toLowerCase().match(/\b[a-z]{4,}\b/g) || [];
  const wordFreq = new Map<string, number>();
  for (const word of words) {
    wordFreq.set(word, (wordFreq.get(word) || 0) + 1);
  }
  
  // Add words that appear multiple times
  for (const [word, freq] of wordFreq) {
    if (freq >= 2 && !isStopWord(word)) {
      keywords.add(word);
    }
  }
  
  return sanitizeKeywords(Array.from(keywords));
}

export function extractSummary(content: string): string {
  // Try to find Executive Summary section
  const summaryMatch = content.match(/##\s*Executive Summary\s*\n\n?([\s\S]{50,500}?)\n\n##/i);
  if (summaryMatch) {
    return summaryMatch[1].trim().replace(/\s+/g, ' ');
  }
  
  // Try first paragraph after title
  const firstParaMatch = content.match(/^#[^\n]+\n\n([\s\S]{50,500}?)\n\n/);
  if (firstParaMatch) {
    return firstParaMatch[1].trim().replace(/\s+/g, ' ');
  }
  
  // Fallback: first 500 chars
  return content.slice(0, 500).trim().replace(/\s+/g, ' ');
}

function isStopWord(word: string): boolean {
  const stopWords = new Set([
    'this', 'that', 'with', 'from', 'they', 'have', 'will', 'been',
    'were', 'said', 'each', 'which', 'their', 'time', 'would',
    'there', 'could', 'other', 'after', 'first', 'well', 'also',
    'these', 'think', 'where', 'being', 'every', 'great', 'might',
    'shall', 'while', 'those', 'both', 'upon', 'dont', 'does'
  ]);
  return stopWords.has(word);
}

export function mapStatus(status: string | undefined): 'active' | 'deprecated' | 'superseded' | 'draft' {
  if (!status) return 'active';
  const normalized = status.toLowerCase();
  if (normalized.includes('complete')) return 'active';
  if (normalized.includes('deprecated')) return 'deprecated';
  if (normalized.includes('superseded')) return 'superseded';
  if (normalized.includes('draft')) return 'draft';
  return 'active';
}

export function normalizeDecision(sourcePath: string, content: string): NormalizedDocument {
  const { metadata, content: body } = parseDocument(content);
  
  // Extract decision ID from filename or content
  const decisionId = extractDecisionId(sourcePath, body);
  
  // Extract keywords from content
  const keywords = extractKeywords(body);
  
  // Extract summary from Executive Summary section
  const summary = extractSummary(body);
  
  // Extract date from content
  const dateMatch = body.match(/Date:\s*(\d{4}-\d{2}-\d{2})/i);
  const createdAt = dateMatch ? `${dateMatch[1]}T00:00:00Z` : new Date().toISOString();
  
  const normalized: DocumentMetadata = {
    type: 'decision',
    id: decisionId,
    category: (metadata.category as string) || 'architecture',
    status: mapStatus(metadata.status as string),
    version: (metadata.version as string) || '1.0.0',
    created_at: (metadata.created_at as string) || createdAt,
    last_reviewed: new Date().toISOString(),
    keywords,
    roles: (metadata.roles as string[]) || ['librarian', 'oracle'],
    summary,
    source: {
      type: 'decision',
      original_path: sourcePath
    }
  };
  
  return {
    metadata: normalized,
    content: body,
    raw: content
  };
}
