/**
 * RAG Ingestion Module
 * Handles ingestion of documents into the RAG system via ToolHive
 */

import { logger } from './logger.js';
import type { ParsedDocument } from './parser.js';

export interface IngestionResult {
  success: boolean;
  documentId?: string;
  error?: string;
}

export interface IngestionOptions {
  gitCommit?: string;
  timestamp?: string;
  skipInvalid?: boolean;
}

/**
 * Prepare document content for RAG ingestion
 */
export function prepareRagContent(doc: ParsedDocument): string {
  const sections: string[] = [];

  // Add metadata as structured content
  sections.push('# Document Metadata');
  sections.push('');
  
  for (const [key, value] of Object.entries(doc.metadata)) {
    if (value !== undefined && value !== null) {
      sections.push(`- **${key}**: ${JSON.stringify(value)}`);
    }
  }

  sections.push('');
  sections.push('# Content');
  sections.push('');
  sections.push(doc.body);

  return sections.join('\n');
}

/**
 * Prepare metadata for RAG ingestion
 */
export function prepareRagMetadata(
  doc: ParsedDocument, 
  options: IngestionOptions = {}
): Record<string, unknown> {
  const metadata: Record<string, unknown> = {
    ...doc.metadata,
    ingestedAt: options.timestamp || new Date().toISOString(),
  };

  if (options.gitCommit) {
    metadata.gitCommit = options.gitCommit;
  }

  // Ensure required metadata fields
  if (!metadata.source) {
    metadata.source = 'unknown';
  }

  if (!metadata.agent) {
    metadata.agent = 'unknown';
  }

  if (!metadata.type) {
    metadata.type = 'unknown';
  }

  // Add content-derived metadata
  if (!metadata.title && doc.body) {
    const titleMatch = doc.body.match(/^#\s+(.+)$/m);
    if (titleMatch) {
      metadata.title = titleMatch[1].trim();
    }
  }

  return metadata;
}

/**
 * Ingest a document into RAG via ToolHive gateway
 * This function simulates the RAG ingestion - in production,
 * it would call the actual rag-server_rag_ingest tool
 */
export async function ingestDocument(
  doc: ParsedDocument,
  options: IngestionOptions = {}
): Promise<IngestionResult> {
  try {
    const content = prepareRagContent(doc);
    const metadata = prepareRagMetadata(doc, options);

    logger.info('Preparing to ingest document', {
      source: metadata.source,
      agent: metadata.agent,
      type: metadata.type,
      contentLength: content.length,
    });

    // In a real implementation, this would call:
    // await toolhive_call_tool({
    //   server_name: "rag-server",
    //   tool_name: "rag_ingest",
    //   parameters: {
    //     content,
    //     source: metadata.source as string,
    //     metadata
    //   }
    // });

    // For now, we simulate success and return the metadata
    // that would be used for ingestion
    logger.debug('Document prepared for RAG ingestion', {
      metadata: Object.keys(metadata),
      contentPreview: content.slice(0, 200) + '...',
    });

    // Generate a pseudo document ID
    const documentId = `doc-${Date.now()}-${Math.random().toString(36).substr(2, 9)}`;

    return {
      success: true,
      documentId,
    };
  } catch (error) {
    const errorMessage = error instanceof Error ? error.message : String(error);
    logger.error('Failed to ingest document', { error: errorMessage });
    
    return {
      success: false,
      error: errorMessage,
    };
  }
}

/**
 * Batch ingest multiple documents
 */
export async function batchIngest(
  documents: Array<{ doc: ParsedDocument; filePath: string }>,
  options: IngestionOptions = {}
): Promise<Map<string, IngestionResult>> {
  const results = new Map<string, IngestionResult>();

  logger.info(`Starting batch ingestion of ${documents.length} documents`);

  for (const { doc, filePath } of documents) {
    const result = await ingestDocument(doc, options);
    results.set(filePath, result);

    if (result.success) {
      logger.info(`Successfully ingested: ${filePath}`);
    } else {
      logger.error(`Failed to ingest: ${filePath}`, { error: result.error });
    }
  }

  const successCount = Array.from(results.values()).filter(r => r.success).length;
  logger.info(`Batch ingestion complete: ${successCount}/${documents.length} successful`);

  return results;
}

/**
 * Check if RAG server is available
 * In production, this would query the actual RAG status
 */
export async function isRagAvailable(): Promise<boolean> {
  // In production, this would call rag-server_rag_status
  // For now, assume available
  return true;
}
