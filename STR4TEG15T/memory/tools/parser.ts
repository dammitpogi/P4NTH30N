import matter from 'gray-matter';

export interface ParsedDocument {
  metadata: Record<string, unknown>;
  content: string;
}

export function parseDocument(content: string): ParsedDocument {
  const parsed = matter(content);
  return {
    metadata: parsed.data,
    content: parsed.content
  };
}

export function serializeDocument(metadata: Record<string, unknown>, content: string): string {
  return matter.stringify(content, metadata);
}