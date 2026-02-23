/**
 * Connection Health Monitor
 *
 * Tracks per-session connection health with success/failure rate
 * and provides pre-flight health checks before sending prompts.
 *
 * DECISION_037 (INFRA-037-003)
 */

import { log } from '../../utils/debug';

export interface HealthStatus {
  /** Number of successes in the tracking window */
  successes: number;
  /** Number of failures in the tracking window */
  failures: number;
  /** Computed failure rate (0.0 - 1.0) */
  failureRate: number;
  /** Unix ms timestamp of last recorded event */
  lastEventAt: number;
  /** Whether outage is currently detected */
  outageDetected: boolean;
}

export interface ConnectionHealthConfig {
  /** Max events to track per session (sliding window) */
  windowSize: number;
  /** Failure rate threshold to declare outage (0.0 - 1.0) */
  outageThreshold: number;
  /** Minimum events before evaluating health */
  minEventsForEvaluation: number;
}

const DEFAULT_CONFIG: ConnectionHealthConfig = {
  windowSize: 20,
  outageThreshold: 0.5,
  minEventsForEvaluation: 3,
};

interface SessionHealth {
  /** Sliding window of recent outcomes: true = success, false = failure */
  events: boolean[];
  lastEventAt: number;
  outageDetected: boolean;
}

export class ConnectionHealthMonitor {
  private sessions = new Map<string, SessionHealth>();
  private config: ConnectionHealthConfig;

  constructor(config?: Partial<ConnectionHealthConfig>) {
    this.config = { ...DEFAULT_CONFIG, ...config };
  }

  /**
   * Record a successful connection/prompt to a session.
   */
  recordSuccess(sessionId: string): void {
    const health = this.getOrCreate(sessionId);
    health.events.push(true);
    this.trimWindow(health);
    health.lastEventAt = Date.now();
    this.evaluateHealth(sessionId, health);
  }

  /**
   * Record a failed connection/prompt to a session.
   */
  recordFailure(sessionId: string): void {
    const health = this.getOrCreate(sessionId);
    health.events.push(false);
    this.trimWindow(health);
    health.lastEventAt = Date.now();
    this.evaluateHealth(sessionId, health);
  }

  /**
   * Check if a session is currently healthy.
   * Returns true if the session is healthy or unknown.
   */
  isHealthy(sessionId: string): boolean {
    const health = this.sessions.get(sessionId);
    if (!health) return true; // Unknown = assume healthy
    return !health.outageDetected;
  }

  /**
   * Get detailed health status for a session.
   */
  getStatus(sessionId: string): HealthStatus {
    const health = this.sessions.get(sessionId);
    if (!health) {
      return {
        successes: 0,
        failures: 0,
        failureRate: 0,
        lastEventAt: 0,
        outageDetected: false,
      };
    }

    const successes = health.events.filter(Boolean).length;
    const failures = health.events.filter((e) => !e).length;
    const total = health.events.length;

    return {
      successes,
      failures,
      failureRate: total > 0 ? failures / total : 0,
      lastEventAt: health.lastEventAt,
      outageDetected: health.outageDetected,
    };
  }

  /**
   * Remove tracking for a session (cleanup on session end).
   */
  removeSession(sessionId: string): void {
    this.sessions.delete(sessionId);
  }

  /**
   * Get all tracked sessions and their health.
   */
  getAllStatuses(): Record<string, HealthStatus> {
    const result: Record<string, HealthStatus> = {};
    for (const [id] of this.sessions) {
      result[id] = this.getStatus(id);
    }
    return result;
  }

  private getOrCreate(sessionId: string): SessionHealth {
    let health = this.sessions.get(sessionId);
    if (!health) {
      health = {
        events: [],
        lastEventAt: Date.now(),
        outageDetected: false,
      };
      this.sessions.set(sessionId, health);
    }
    return health;
  }

  private trimWindow(health: SessionHealth): void {
    while (health.events.length > this.config.windowSize) {
      health.events.shift();
    }
  }

  private evaluateHealth(sessionId: string, health: SessionHealth): void {
    if (health.events.length < this.config.minEventsForEvaluation) {
      return; // Not enough data to evaluate
    }

    const failures = health.events.filter((e) => !e).length;
    const failureRate = failures / health.events.length;
    const wasOutage = health.outageDetected;

    health.outageDetected = failureRate >= this.config.outageThreshold;

    if (health.outageDetected && !wasOutage) {
      log(
        `[health-monitor] Outage detected for session ${sessionId}: failure rate ${(failureRate * 100).toFixed(1)}%`,
      );
    } else if (!health.outageDetected && wasOutage) {
      log(
        `[health-monitor] Outage recovered for session ${sessionId}: failure rate ${(failureRate * 100).toFixed(1)}%`,
      );
    }
  }
}
