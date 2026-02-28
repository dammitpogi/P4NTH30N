import type { NormalizedDocument, KeywordIndex } from '../types';

const STOP_WORDS = new Set([
  'the', 'and', 'for', 'are', 'but', 'not', 'you', 'all', 'can', 'had',
  'her', 'was', 'one', 'our', 'out', 'day', 'get', 'has', 'him', 'his',
  'how', 'man', 'new', 'now', 'old', 'see', 'two', 'way', 'who', 'boy',
  'did', 'its', 'let', 'put', 'say', 'she', 'too', 'use', 'she', 'too'
]);

export function buildKeywordIndex(documents: NormalizedDocument[]): KeywordIndex {
  const index: KeywordIndex = {};
  
  for (const doc of documents) {
    // Index from keywords field
    for (const keyword of doc.metadata.keywords) {
      addToIndex(index, keyword.toLowerCase(), doc.metadata.id);
    }
    
    // Index from content (extract additional keywords)
    const contentWords = extractWords(doc.content);
    for (const word of contentWords) {
      if (isSignificant(word)) {
        addToIndex(index, word.toLowerCase(), doc.metadata.id);
      }
    }
  }
  
  return index;
}

function addToIndex(index: KeywordIndex, keyword: string, docId: string): void {
  // Skip empty keywords
  if (!keyword || keyword.trim() === '') return;
  
  // Use hasOwnProperty to check if key exists
  if (!Object.prototype.hasOwnProperty.call(index, keyword)) {
    index[keyword] = {
      documents: [docId],
      frequency: 1,
      lastUpdated: new Date().toISOString()
    };
    return;
  }
  
  // Update existing entry - use direct access
  const entry = index[keyword];
  if (entry && Array.isArray(entry.documents)) {
    if (!entry.documents.includes(docId)) {
      entry.documents.push(docId);
    }
    entry.frequency++;
  }
}

function extractWords(content: string): string[] {
  // Remove code blocks, URLs, and special chars
  const cleaned = content
    .replace(/```[\s\S]*?```/g, '') // Remove code blocks
    .replace(/`[^`]+`/g, '') // Remove inline code
    .replace(/https?:\/\/\S+/g, '') // Remove URLs
    .replace(/[^a-zA-Z\s]/g, ' '); // Remove special chars
  
  return cleaned
    .toLowerCase()
    .split(/\s+/)
    .filter(w => w.length >= 3 && w.length <= 30);
}

function isSignificant(word: string): boolean {
  if (STOP_WORDS.has(word)) return false;
  if (/^\d+$/.test(word)) return false; // Pure numbers
  return true;
}
