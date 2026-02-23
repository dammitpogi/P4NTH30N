interface CachedSummary {
  summary: string;
  tokens: number;
  createdAt: number;
}

const summaryCache = new Map<string, CachedSummary>();

export function getSessionCache(
  sessionCaches: Map<string, Set<string>>,
  sessionID: string,
): Set<string> {
  if (!sessionCaches.has(sessionID)) {
    sessionCaches.set(sessionID, new Set<string>());
  }
  return sessionCaches.get(sessionID)!;
}

export function clearSessionCache(
  sessionCaches: Map<string, Set<string>>,
  sessionID: string,
): void {
  sessionCaches.delete(sessionID);
}

export function buildSummaryCacheKey(input: {
  codemapPath: string;
  modifiedTime: number;
  model: string;
  maxTokens: number;
}): string {
  return [
    input.codemapPath,
    String(input.modifiedTime),
    input.model,
    String(input.maxTokens),
  ].join('::');
}

export function getCachedSummary(
  key: string,
  ttlMs: number,
): { summary: string; tokens: number } | null {
  const item = summaryCache.get(key);
  if (!item) {
    return null;
  }

  if (Date.now() - item.createdAt > ttlMs) {
    summaryCache.delete(key);
    return null;
  }

  return {
    summary: item.summary,
    tokens: item.tokens,
  };
}

export function setCachedSummary(
  key: string,
  summary: string,
  tokens: number,
): void {
  summaryCache.set(key, {
    summary,
    tokens,
    createdAt: Date.now(),
  });
}
