import type { NormalizedDocument } from '../types';

export function generateMetadataTable(documents: NormalizedDocument[]): string {
  const headers = ['id', 'type', 'category', 'status', 'created_at', 'keywords', 'roles', 'summary'];
  
  const rows = documents.map(doc => [
    doc.metadata.id,
    doc.metadata.type,
    doc.metadata.category,
    doc.metadata.status,
    doc.metadata.created_at,
    JSON.stringify(doc.metadata.keywords),
    JSON.stringify(doc.metadata.roles),
    `"${doc.metadata.summary.replace(/"/g, '""')}"`
  ]);
  
  return [headers.join(','), ...rows.map(r => r.join(','))].join('\n');
}