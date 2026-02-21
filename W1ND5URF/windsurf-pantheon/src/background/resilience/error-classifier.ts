/**
 * INFRA-037: Error classifier for subagent task failures.
 * Categorizes errors as transient (retryable) vs permanent (fatal) vs logic (bug).
 * Target: 95% classification accuracy.
 */

export enum ErrorCategory {
  /** Network transient - safe to retry (ECONNREFUSED, ECONNRESET, timeout) */
  NetworkTransient = 'network_transient',
  /** Rate limiting - retry with backoff */
  RateLimited = 'rate_limited',
  /** Authentication failure - permanent, needs human intervention */
  AuthFailure = 'auth_failure',
  /** Resource not found - permanent */
  NotFound = 'not_found',
  /** Server error (5xx) - transient, retry with backoff */
  ServerError = 'server_error',
  /** Logic/application error - not retryable, needs bug fix */
  LogicError = 'logic_error',
  /** Configuration error - permanent until config is fixed */
  ConfigError = 'config_error',
  /** Unknown - default to non-retryable for safety */
  Unknown = 'unknown',
}

export interface ClassifiedError {
  category: ErrorCategory;
  isRetryable: boolean;
  originalError: Error;
  errorCode?: string;
  httpStatus?: number;
  message: string;
  timestamp: Date;
}

/** Pattern-based error classification rules */
interface ClassificationRule {
  pattern: RegExp;
  codes?: string[];
  httpStatuses?: number[];
  category: ErrorCategory;
  retryable: boolean;
}

const CLASSIFICATION_RULES: ClassificationRule[] = [
  // Network transient errors
  {
    pattern: /ECONNREFUSED|ECONNRESET|ECONNABORTED|EPIPE|EHOSTUNREACH|ENETUNREACH/i,
    codes: ['ECONNREFUSED', 'ECONNRESET', 'ECONNABORTED', 'EPIPE', 'EHOSTUNREACH', 'ENETUNREACH'],
    category: ErrorCategory.NetworkTransient,
    retryable: true,
  },
  {
    pattern: /timeout|ETIMEDOUT|ESOCKETTIMEDOUT|request timed out|socket hang up/i,
    codes: ['ETIMEDOUT', 'ESOCKETTIMEDOUT'],
    category: ErrorCategory.NetworkTransient,
    retryable: true,
  },
  {
    pattern: /DNS|ENOTFOUND|getaddrinfo/i,
    codes: ['ENOTFOUND'],
    category: ErrorCategory.NetworkTransient,
    retryable: true,
  },
  // Rate limiting
  {
    pattern: /rate limit|too many requests|429/i,
    httpStatuses: [429],
    category: ErrorCategory.RateLimited,
    retryable: true,
  },
  // Auth failures
  {
    pattern: /unauthorized|forbidden|authentication|invalid.*token|invalid.*key|401|403/i,
    httpStatuses: [401, 403],
    category: ErrorCategory.AuthFailure,
    retryable: false,
  },
  // Not found
  {
    pattern: /not found|404|no such|does not exist/i,
    httpStatuses: [404],
    category: ErrorCategory.NotFound,
    retryable: false,
  },
  // Server errors (5xx)
  {
    pattern: /internal server error|bad gateway|service unavailable|gateway timeout|50[0-4]/i,
    httpStatuses: [500, 501, 502, 503, 504],
    category: ErrorCategory.ServerError,
    retryable: true,
  },
  // Config errors
  {
    pattern: /invalid config|missing.*config|configuration.*error|ENOENT.*config/i,
    category: ErrorCategory.ConfigError,
    retryable: false,
  },
];

export class ErrorClassifier {
  private classificationCount = 0;
  private categoryStats: Map<ErrorCategory, number> = new Map();

  /**
   * Classifies an error into a category and determines retryability.
   */
  classify(error: Error, httpStatus?: number): ClassifiedError {
    this.classificationCount++;

    const errorCode = (error as any).code as string | undefined;
    const message = error.message || String(error);

    for (const rule of CLASSIFICATION_RULES) {
      // Check HTTP status first (most reliable)
      if (httpStatus && rule.httpStatuses?.includes(httpStatus)) {
        return this.createResult(rule, error, errorCode, httpStatus, message);
      }

      // Check error code
      if (errorCode && rule.codes?.includes(errorCode)) {
        return this.createResult(rule, error, errorCode, httpStatus, message);
      }

      // Check message pattern
      if (rule.pattern.test(message)) {
        return this.createResult(rule, error, errorCode, httpStatus, message);
      }
    }

    // Default: unknown, non-retryable
    const result: ClassifiedError = {
      category: ErrorCategory.Unknown,
      isRetryable: false,
      originalError: error,
      errorCode,
      httpStatus,
      message,
      timestamp: new Date(),
    };
    this.recordStat(ErrorCategory.Unknown);
    return result;
  }

  private createResult(
    rule: ClassificationRule,
    error: Error,
    errorCode?: string,
    httpStatus?: number,
    message?: string,
  ): ClassifiedError {
    this.recordStat(rule.category);
    return {
      category: rule.category,
      isRetryable: rule.retryable,
      originalError: error,
      errorCode,
      httpStatus,
      message: message || error.message,
      timestamp: new Date(),
    };
  }

  private recordStat(category: ErrorCategory): void {
    this.categoryStats.set(category, (this.categoryStats.get(category) || 0) + 1);
  }

  /** Returns classification statistics. */
  getStats(): { total: number; byCategory: Record<string, number> } {
    const byCategory: Record<string, number> = {};
    this.categoryStats.forEach((count, cat) => { byCategory[cat] = count; });
    return { total: this.classificationCount, byCategory };
  }
}
