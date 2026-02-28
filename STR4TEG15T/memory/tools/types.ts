export interface DocumentMetadata {
  type: 'decision' | 'log' | 'research' | 'tool';
  id: string;
  category: string;
  status: 'active' | 'deprecated' | 'superseded' | 'draft';
  version: string;
  created_at: string;
  last_reviewed: string;
  keywords: string[];
  roles: string[];
  summary: string;
  source?: {
    type: string;
    original_path: string;
  };
}

export interface NormalizedDocument {
  metadata: DocumentMetadata;
  content: string;
  raw: string;
}

export interface KeywordIndex {
  [keyword: string]: {
    documents: string[];
    frequency: number;
    lastUpdated: string;
  };
}

export interface SearchQuery {
  text?: string;
  keywords?: string[];
  filters?: {
    type?: string[];
    category?: string[];
    status?: string[];
    roles?: string[];
  };
  limit?: number;
}

export interface SearchResult {
  id: string;
  type: string;
  score: number;
  metadata: DocumentMetadata;
  excerpt: string;
}

export interface SweepCache {
  timestamp: string;
  documentCount: number;
  sources: string[];
  processedFiles: string[];
}
