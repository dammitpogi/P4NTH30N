import { validateMetadata } from '../schema';
import type { DocumentMetadata } from '../types';

export function validateDocumentMetadata(data: unknown): { 
  valid: boolean; 
  metadata?: DocumentMetadata; 
  errors?: string[];
  warnings?: string[];
} {
  const result = validateMetadata(data);
  
  if (result.success) {
    return { valid: true, metadata: result.data };
  }
  
  // Separate errors and warnings
  const errors: string[] = [];
  const warnings: string[] = [];
  
  for (const err of result.errors || []) {
    if (err.includes('required') || err.includes('invalid')) {
      errors.push(err);
    } else {
      warnings.push(err);
    }
  }
  
  return { valid: errors.length === 0, errors, warnings };
}

export function sanitizeId(id: string): string {
  // Remove invalid characters, keep only uppercase letters, numbers, underscores, and hyphens
  return id.replace(/[^A-Z0-9_-]/gi, '').toUpperCase();
}

export function sanitizeKeywords(keywords: string[]): string[] {
  return keywords
    .map(k => k.toLowerCase().trim())
    .filter(k => k.length >= 2 && k.length <= 50)
    .filter((k, i, arr) => arr.indexOf(k) === i) // dedupe
    .slice(0, 20);
}
