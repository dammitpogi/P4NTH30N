interface StoredDocument {
  id: string;
  content: string;
  embedding: number[];
  metadata: Record<string, unknown>;
}

const documents = new Map<string, StoredDocument>();
let initialized = false;

export async function initializeVectorStore(_path: string): Promise<void> {
  initialized = true;
}

export async function checkVectorStoreHealth(): Promise<boolean> {
  return initialized;
}

export async function addDocument(
  id: string,
  content: string,
  embedding: number[],
  metadata: Record<string, unknown> = {},
): Promise<void> {
  documents.set(id, { id, content, embedding, metadata });
}

export async function searchSimilar(
  queryEmbedding: number[],
  topK = 5,
): Promise<
  Array<{ id: string; content: string; score: number; metadata: Record<string, unknown> }>
> {
  const scored = Array.from(documents.values()).map((doc) => ({
    id: doc.id,
    content: doc.content,
    score: cosineSimilarity(queryEmbedding, doc.embedding),
    metadata: doc.metadata,
  }));

  scored.sort((a, b) => b.score - a.score);
  return scored.slice(0, topK);
}

export async function deleteDocument(id: string): Promise<boolean> {
  return documents.delete(id);
}

export async function listDocuments(): Promise<string[]> {
  return Array.from(documents.keys());
}

function cosineSimilarity(a: number[], b: number[]): number {
  if (a.length !== b.length || a.length === 0) {
    return 0;
  }

  let dot = 0;
  let normA = 0;
  let normB = 0;

  for (let i = 0; i < a.length; i += 1) {
    dot += a[i] * b[i];
    normA += a[i] * a[i];
    normB += b[i] * b[i];
  }

  if (normA === 0 || normB === 0) {
    return 0;
  }

  return dot / (Math.sqrt(normA) * Math.sqrt(normB));
}
