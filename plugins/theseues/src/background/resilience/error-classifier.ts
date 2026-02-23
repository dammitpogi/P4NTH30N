/**
 * Error Classifier for Subagent Resilience
 *
 * Classifies errors into categories that determine retry strategy:
 * - NetworkTransient: Retry with exponential backoff (same model)
 * - NetworkPermanent: Fail immediately (cert/SSL/proxy issues)
 * - ProviderRateLimit: Retry with longer backoff (same model)
 * - ProviderError: Fallback to next model in chain
 * - ContextLength: Compact and retry
 * - LogicError: Fail immediately (no retry)
 *
 * DECISION_037 (INFRA-037-001)
 */

import { log } from '../../utils/debug';

export enum ErrorType {
  NetworkTransient = 'NetworkTransient',
  NetworkPermanent = 'NetworkPermanent',
  ProviderRateLimit = 'ProviderRateLimit',
  ProviderError = 'ProviderError',
  ContextLength = 'ContextLength',
  LogicError = 'LogicError',
}

/** Human-readable labels for logging */
const ERROR_TYPE_LABELS: Record<ErrorType, string> = {
  [ErrorType.NetworkTransient]: 'Network (transient)',
  [ErrorType.NetworkPermanent]: 'Network (permanent)',
  [ErrorType.ProviderRateLimit]: 'Rate limit',
  [ErrorType.ProviderError]: 'Provider error',
  [ErrorType.ContextLength]: 'Context length',
  [ErrorType.LogicError]: 'Logic error',
};

/**
 * Pattern groups for error classification.
 * Order matters: first match wins. More specific patterns go first.
 */
const CLASSIFICATION_RULES: Array<{
  type: ErrorType;
  patterns: RegExp[];
}> = [
  // Context length errors — most specific, check first
  {
    type: ErrorType.ContextLength,
    patterns: [
      /context.length/i,
      /maximum.context/i,
      /too.many.tokens/i,
      /token.limit/i,
      /max.token/i,
      /context.window/i,
      /input.too.long/i,
    ],
  },

  // Network permanent — cert/SSL/proxy failures (non-retryable)
  {
    type: ErrorType.NetworkPermanent,
    patterns: [
      /cert(?:ificate)?\s*(?:has\s*)?(?:expired|invalid|error)/i,
      /ssl\s*(?:handshake|error|failure)/i,
      /tls\s*(?:handshake|error|failure)/i,
      /self[- ]signed\s*cert/i,
      /proxy\s*(?:auth|error|connect)/i,
      /unable\s+to\s+verify.*certificate/i,
      /DEPTH_ZERO_SELF_SIGNED_CERT/,
      /UNABLE_TO_GET_ISSUER_CERT/,
      /ERR_TLS_CERT_ALTNAME_INVALID/,
    ],
  },

  // Provider rate limit — retryable with longer backoff
  {
    type: ErrorType.ProviderRateLimit,
    patterns: [
      /rate.limit/i,
      /429/,
      /too.many.requests/i,
      /quota.exceeded/i,
      /exceeded.your.current.quota/i,
      /RESOURCE_EXHAUSTED/,
      /more.credit/i,
      /credit.exceeded/i,
      /insufficient.quota/i,
      /api.usage/i,
      /requests.per.minute/i,
      /tokens.per.minute/i,
    ],
  },

  // Network transient — retryable with exponential backoff
  {
    type: ErrorType.NetworkTransient,
    patterns: [
      /econnrefused/i,
      /econnreset/i,
      /econnaborted/i,
      /enotfound/i,
      /etimedout/i,
      /epipe/i,
      /ehostunreach/i,
      /enetunreach/i,
      /enetdown/i,
      /timeout/i,
      /unable\s+to\s+connect/i,
      /network\s*error/i,
      /connection\s*error/i,
      /connection\s*refused/i,
      /connection\s*reset/i,
      /connection\s*closed/i,
      /connection\s*timed?\s*out/i,
      /socket\s*hang\s*up/i,
      /dns\s*lookup\s*fail/i,
      /getaddrinfo\s*enotfound/i,
      /fetch\s*failed/i,
      /request\s*aborted/i,
      /unable\s+to\s+access\s+url/i,
      /access\s+the\s+url/i,
      /typo\s+in\s+the\s+url\s+or\s+port/i,
      /503/,
      /504/,
      /502/,
      /service\s*unavailable/i,
      /gateway\s*timeout/i,
      /bad\s*gateway/i,
    ],
  },

  // Provider errors — fallback to next model
  {
    type: ErrorType.ProviderError,
    patterns: [
      /model.unavailable/i,
      /invalid.*model/i,
      /model.*not.*found/i,
      /unknown.*model/i,
      /model.*not.*available/i,
      /invalid.*api.*key/i,
      /api.*key.*invalid/i,
      /401\s*unauthorized/i,
      /403\s*forbidden/i,
      /forbidden/i,
      /PERMISSION_DENIED/i,
      /IAM_PERMISSION_DENIED/i,
      /authentication.*failed/i,
      /unauthorized.*access/i,
      /invalid.*prompt/i,
      /bad.*request/i,
      /400\s*bad/i,
      /unknown.*error/i,
      /unknown.*failure/i,
      /provider.*error/i,
      /upstream.*error/i,
      /server.*error/i,
      /internal.*error/i,
      /agent.*not.*found/i,
      /agent.*not.*available/i,
      /subagent.*error/i,
      /generativelanguage\.googleapis\.com/i,
      /cloudaicompanion\.googleapis\.com/i,
    ],
  },
];

export class ErrorClassifier {
  /**
   * Classify an error into a retry strategy category.
   */
  classify(error: unknown): ErrorType {
    const msg = this.extractMessage(error);

    for (const rule of CLASSIFICATION_RULES) {
      if (rule.patterns.some((p) => p.test(msg))) {
        log(
          `[error-classifier] Classified as ${ERROR_TYPE_LABELS[rule.type]}: ${msg.slice(0, 120)}`,
        );
        return rule.type;
      }
    }

    // Default: treat as logic error (no retry)
    log(
      `[error-classifier] Unclassified error (LogicError): ${msg.slice(0, 120)}`,
    );
    return ErrorType.LogicError;
  }

  /**
   * Whether this error type should retry on the same model.
   */
  shouldRetrySameModel(errorType: ErrorType): boolean {
    return (
      errorType === ErrorType.NetworkTransient ||
      errorType === ErrorType.ProviderRateLimit
    );
  }

  /**
   * Whether this error type should skip to the next model.
   */
  shouldFallbackToNextModel(errorType: ErrorType): boolean {
    return errorType === ErrorType.ProviderError;
  }

  /**
   * Whether this error type should attempt compaction.
   */
  shouldCompact(errorType: ErrorType): boolean {
    return errorType === ErrorType.ContextLength;
  }

  /**
   * Whether this error type is permanent (no retry, no fallback).
   */
  isPermanent(errorType: ErrorType): boolean {
    return (
      errorType === ErrorType.NetworkPermanent ||
      errorType === ErrorType.LogicError
    );
  }

  /**
   * Extract a message string from any error shape.
   */
  private extractMessage(error: unknown): string {
    if (error instanceof Error) return error.message;
    if (typeof error === 'string') return error;
    if (error == null) return String(error);
    try {
      return JSON.stringify(error) ?? String(error);
    } catch {
      return String(error);
    }
  }
}

/** Convenience label accessor */
export function errorTypeLabel(type: ErrorType): string {
  return ERROR_TYPE_LABELS[type];
}
